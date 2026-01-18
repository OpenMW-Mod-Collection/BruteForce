local storage = require("openmw.storage")
local types = require("openmw.types")
local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")

require("scripts.BruteForce.utils.consts")
require("scripts.BruteForce.logic.onHit")
require("scripts.BruteForce.logic.onUnlock")

local sectionOnHit = storage.globalSection("SettingsBruteForce_onHit")
local sectionOnUnlock = storage.globalSection("SettingsBruteForce_onUnlock")

local function onObjectHit(o, var, res)
    if not RegisterAttack(o) then return end

    if AttackMissed(o, self) or WeaponTooWorn(o, self) then
        if sectionOnHit:get("damageOnH2hMisses") then
            DamageIfH2h(self)
        end
        return
    end

    DamageIfH2h(self)
    core.sendGlobalEvent("checkJammedLock", { o = o, sender = self })
    -- check jammed lock in global script
    -- if it's OK, it will fire a tryUnlocking event back here
end

local function lockWasntJammed(data)
    local o = data.o

    if not Unlock(o, self) then
        -- lock got bent
        if sectionOnUnlock:get("enableWeaponWearAgainstBentLocks") then
            WearWeapon(o, self)
        end
        return
    end

    GiveCurrWeaponXp(self)
    WearWeapon(o, self)

    if sectionOnUnlock:get("triggerTraps") then
        TriggerTrap(o, self)
    end

    if ObjectIsOwned(o, self) then
        AlertNpcs(self)
    end

    if types.Container.objectIsInstance(o) then
        DamageContainerEquipment(o)
    end
end

local function lockWasJammed(data)
    local o = data.o

    if sectionOnUnlock:get("enableWeaponWearAgainstBentLocks") then
        WearWeapon(o, self)
    end

    if sectionOnUnlock:get("triggerTraps") then
        TriggerTrap(o, self)
    end
end

CheckDependencies(self, Dependencies)
I.impactEffects.addHitObjectHandler(onObjectHit)

return {
    eventHandlers = {
        lockWasntJammed = lockWasntJammed,
        lockWasJammed = lockWasJammed,
    },
}
