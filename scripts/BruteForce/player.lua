local types = require("openmw.types")
local I = require("openmw.interfaces")

require("scripts.BruteForce.utils.utils")
require("scripts.BruteForce.bf_logic")

local function onObjectHit(o, var, res)
    if not RegisterAttack(o) or AttackMissed(o) then return end
    if Unlock(o) then
        GiveCurrWeaponXp()
        if types.Container.objectIsInstance(o) then
            DamageContainerEquipment(o)
        end
        if ObjectIsOwned(o) then
            MakeSound(o)
        end
    end
end

local function onLoad(savedData)
    JammedLocks = savedData
    I.impactEffects.addHitObjectHandler(onObjectHit)
end

local function onSave()
    return JammedLocks
end

local function isLockJammed(id)
    return JammedLocks[id] == true
end

local function setJammedLock(id, val)
    JammedLocks[id] = val
end

return {
    engineHandlers = {
        onLoad = onLoad,
        onSave = onSave,
    },
    eventHandlers = {
        jammedLockOpen = function(ctx) setJammedLock(ctx.id, nil) end,
    },
    interfaceName = "BruteForce",
    interface = {
        version = 1,
        isLockJammed = isLockJammed,
        setJammedLock = setJammedLock,
    },
}
