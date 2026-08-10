---@diagnostic disable: missing-parameter, undefined-field
local storage = require("openmw.storage")
local types = require("openmw.types")
local I = require("openmw.interfaces")
local world = require("openmw.world")
local core = require("openmw.core")
local async = require("openmw.async")

local helpers = require("scripts.BruteForce.utils.helpers")
local sounds = require("scripts.BruteForce.logic.sounds")
local settingsCache = require("scripts.BruteForce.utils.settingsCache")

local settingsLocks = settingsCache.new(storage.globalSection("SettingsBruteForce_locks"), async)
local l10n = core.l10n("BruteForce")

local l = {}

l.unlock = function(obj, actor, bentLocks)
    local unlocked = false

    if math.random() * 100 > settingsLocks.bendingChance then
        -- unlock lock
        obj.type.unlock(obj)
        unlocked = true
    else
        -- bend lock
        bentLocks[helpers.getId(obj)] = true
        helpers.displayMessage(actor, l10n("lock_got_jammed"))
    end

    sounds.lockHit(obj, actor, unlocked)

    return unlocked
end

l.damageContainerEquipment = function(obj)
    if not settingsLocks.damageContents then return end

    local inv = obj.type.inventory(obj)
    -- populate container's leveled list if needed
    if not inv:isResolved() then
        inv:resolve()
    end

    for _, item in pairs(inv:getAll()) do
        if helpers.itemCanBeDamaged(item) then
            core.sendGlobalEvent("ModifyItemCondition", {
                item = item,
                amount = -1 * math.random(item.type.records[item.recordId].health)
            })
        end
    end
end

l.wearWeapon = function(obj, actor, lockBent)
    if lockBent and not settingsLocks.wearWeaponsAgainstBentLocks then
        return
    end

    local weaponSlot = actor.type.EQUIPMENT_SLOT.CarriedRight
    local weapon = actor.type.getEquipment(actor, weaponSlot)
    local wearMult = settingsLocks.weaponWearMult

    if not weapon or wearMult == 0 then return end

    local lockLevel = types.Lockable.getLockLevel(obj)
    local dmg = -1 * math.min(
        lockLevel * wearMult,
        weapon.type.records[weapon.recordId].health
    )

    core.sendGlobalEvent("ModifyItemCondition", {
        item = weapon,
        amount = dmg,
    })
end

l.triggerTrap = function(obj, player)
    -- Hidden Traps support
    -- https://www.nexusmods.com/morrowind/mods/59667
    if I.HTrapsGlobal and I.HTrapsGlobal.isTrapped(obj) and I.HTrapsGlobal.springTrap then
        I.HTrapsGlobal.springTrap(obj, player, "Brute Force: Lock split")
    elseif obj.type.getTrapSpell(obj) then
        world._runStandardActivationAction(obj, player)
    end
end

return l
