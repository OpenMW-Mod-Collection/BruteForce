local core = require("openmw.core")
local storage = require("openmw.storage")
local types = require("openmw.types")
local I = require("openmw.interfaces")
local world = require("openmw.world")

require("scripts.BruteForce.logic.onUnlock")

local sectionOnUnlock = storage.globalSection("SettingsBruteForce_onUnlock")
local l10n = core.l10n("BruteForce")

local function triggerTrap(o, player)
    if not sectionOnUnlock:get("triggerTraps") then return end
    -- Hidden Traps support
    -- https://www.nexusmods.com/morrowind/mods/59667
    if I.HTrapsGlobal and I.HTrapsGlobal.isTrapped(o) and I.HTrapsGlobal.springTrap then
        I.HTrapsGlobal.springTrap(o, player, "Brute Force: Lock split")
    elseif o.type.getTrapSpell(o) then
        ---@diagnostic disable-next-line: undefined-field
        world._runStandardActivationAction(o, player)
    end
end

function LockWasntJammed(o, player, jammedLocks)
    if not Unlock(o, player, jammedLocks) then
        -- lock got bent
        if sectionOnUnlock:get("enableWeaponWearAgainstBentLocks") then
            WearWeapon(o, player)
        end
        return
    end

    GiveCurrWeaponXp(player)
    WearWeapon(o, player)
    triggerTrap(o, player)

    if ObjectIsOwned(o, player) then
        player:sendEvent("AggroGuards")
    end

    if types.Container.objectIsInstance(o) then
        DamageContainerEquipment(o)
    elseif types.Door.objectIsInstance(o) then
        if not types.Door.destCell(o) then
            types.Door.activateDoor(o, true)
        end
    end
end

function LockWasJammed(o, player)
    ---@diagnostic disable-next-line: missing-parameter
    DisplayMessage(player, l10n("lock_was_jammed"))

    if sectionOnUnlock:get("enableWeaponWearAgainstBentLocks") then
        WearWeapon(o, player)
    end

    triggerTrap(o, player)
end
