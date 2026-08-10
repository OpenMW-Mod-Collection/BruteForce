local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local storage = require("openmw.storage")
local types = require("openmw.types")
local nearby = require("openmw.nearby")
local async = require("openmw.async")
local sounds= require("scripts.BruteForce.logic.sounds")

local deps = require("scripts.BruteForce.utils.dependencies")
local consts = require("scripts.BruteForce.utils.consts")
local crimes = require("scripts.BruteForce.logic.crimes")
local hits = require("scripts.BruteForce.logic.hits")
local settingsCache = require("scripts.BruteForce.utils.settingsCache")

deps.checkAll(
    "Brute Force",
    { {
        interface = I.impactEffects,
        plugin = "Impact Effects.omwscripts"
    } }
)

local settingsLocks = settingsCache.new(storage.globalSection("SettingsBruteForce_locks"), async)
local settingsAlerting = settingsCache.new(storage.globalSection("SettingsBruteForce_alerting"), async)
local settingsDebug = settingsCache.new(storage.globalSection("SettingsBruteForce_debug"), async)

local weaponSlot = self.type.EQUIPMENT_SLOT.CarriedRight
local skillUsedOptions = { useType = I.SkillProgression.SKILL_USE_TYPES.Weapon_SuccessfulHit }

local function onObjectHit(obj, var, res)
    local hitSuccessful = obj and types.Lockable.objectIsInstance(obj)
    if not hitSuccessful or not settingsDebug.modEnabled then
        return
    end

    if not types.Lockable.isLocked(obj) then
        if obj.type.getTrapSpell(obj) and settingsLocks.triggerTrapsOn.notLocked then
            core.sendGlobalEvent("BruteForce_runStandardActivationAction", { object = obj, actor = self })
        end
        return
    end

    local lockLevel = types.Lockable.getLockLevel(obj)
    local weapon = self.type.getEquipment(self, weaponSlot)
    local missed = hits.attackMissed(lockLevel) or hits.weaponTooWorn(weapon, lockLevel)

    if not weapon then
        hits.getFistsDamaged(missed, lockLevel)
    end

    if missed then
        if settingsAlerting.missingIsACrime then
            crimes.commitCrime(obj, self, nearby.actors, false)
        end
        if obj.type.getTrapSpell(obj) and settingsLocks.triggerTrapsOn.missed then
            core.sendGlobalEvent("BruteForce_runStandardActivationAction", { object = obj, actor = self })
        end
        return
    end

    core.sendGlobalEvent("BruteForce_tryUnlocking", { obj = obj, player = self })
end

local function giveCurrWeaponXp()
    local weapon = self.type.getEquipment(self, weaponSlot)
    local skillId = weapon
        and consts.weaponTypeToSkillId[weapon.type.records[weapon.recordId].type]
        or "handtohand"
    I.SkillProgression.skillUsed(skillId, skillUsedOptions)
end

I.impactEffects.addHitObjectHandler(onObjectHit)

return {
    eventHandlers = {
        BruteForce_GiveCurrWeaponXp = giveCurrWeaponXp,
    }
}
