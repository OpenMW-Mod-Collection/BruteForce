local types = require("openmw.types")
local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")

require("scripts.BruteForce.utils.consts")
local L = require("scripts.BruteForce.bf_logic")
local omw_utils = require("scripts.BruteForce.utils.openmw_utils")

local function onObjectHit(o, var, res)
    if not L.registerAttack(o) or L.attackMissed(o) then return end
    core.sendGlobalEvent("checkJammedLock", { o = o, sender = self })
    -- check jammed lock in global script
    -- if it's OK, it will fire a tryUnlocking event back here
end

local function tryUnlocking(data)
    local o = data.o
    if L.unlock(o) then
        L.giveCurrWeaponXp()
        if types.Container.objectIsInstance(o) then
            L.damageContainerEquipment(o)
        end
        if L.objectIsOwned(o) then
            L.alertNpcs(o)
        end
    end
end

local function onLoad(savedData)
    omw_utils.checkDependencies(self, Dependencies)
    I.impactEffects.addHitObjectHandler(onObjectHit)
end

return {
    engineHandlers = {
        onLoad = onLoad,
    },
    eventHandlers = {
        tryUnlocking = tryUnlocking,
    },
}
