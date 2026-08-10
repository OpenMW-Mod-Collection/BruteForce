---@diagnostic disable: undefined-field, missing-parameter
local storage = require("openmw.storage")
local types = require("openmw.types")
local I = require("openmw.interfaces")
local world = require("openmw.world")
local core = require("openmw.core")
local async = require("openmw.async")

local helpers = require("scripts.BruteForce.utils.helpers")
local crimes = require("scripts.BruteForce.logic.crimes")
local lockLogic = require("scripts.BruteForce.logic.locks")
local settingsCache = require("scripts.BruteForce.utils.settingsCache")

local l10n = core.l10n("BruteForce")
local settingsDebug = settingsCache.new(storage.globalSection("SettingsBruteForce_debug"), async)
local settingsLocks = settingsCache.new(storage.globalSection("SettingsBruteForce_locks"), async)

local bentLocks = {}

local function lockWasBent(obj, player)
    lockLogic.wearWeapon(obj, player, true)
    if settingsLocks.triggerTrapsOn.bent then
        lockLogic.triggerTrap(obj, player)
    end
end

local function lockWasntBent(obj, player)
    if not lockLogic.unlock(obj, player, bentLocks) then
        lockWasBent(obj, player)
        return
    end

    player:sendEvent("BruteForce_GiveCurrWeaponXp")
    lockLogic.wearWeapon(obj, player, false)
    if settingsLocks.triggerTrapsOn.split then
        lockLogic.triggerTrap(obj, player)
    end

    if types.Container.objectIsInstance(obj) then
        lockLogic.damageContainerEquipment(obj)
    elseif types.Door.objectIsInstance(obj) then
        if not types.Door.destCell(obj) then
            types.Door.activateDoor(obj, true)
        end
    end
end

local function tryUnlocking(data)
    crimes.commitCrime(data.obj, data.player, world.activeActors, true)
    if bentLocks[helpers.getId(data.obj)] and not settingsDebug.ignoreBentLocks then
        helpers.displayMessage(data.player, l10n("lock_was_jammed"))
        lockWasBent(data.obj, data.player)
    else
        lockWasntBent(data.obj, data.player)
    end
end

local function lockableOpen(obj, actor)
    bentLocks[helpers.getId(obj)] = nil
end

local function onLoad(data)
    if not data then return end
    bentLocks = data.bentLocks or bentLocks
end

local function onSave()
    return {
        bentLocks = bentLocks
    }
end

I.Activation.addHandlerForType(types.Door, lockableOpen)
I.Activation.addHandlerForType(types.Container, lockableOpen)

return {
    engineHandlers = {
        onLoad = onLoad,
        onSave = onSave,
    },
    eventHandlers = {
        BruteForce_tryUnlocking = tryUnlocking,
        BruteForce_runStandardActivationAction = function(data)
            world._runStandardActivationAction(data.o, data.player)
        end
    },
}
