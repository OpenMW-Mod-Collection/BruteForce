local core = require("openmw.core")
local storage = require("openmw.storage")
local types = require("openmw.types")
local I = require("openmw.interfaces")

require("scripts.BruteForce.logic.onUnlock")

local sectionOnUnlock = storage.globalSection("SettingsBruteForce_onUnlock")
local l10n = core.l10n("BruteForce")

local function triggerTrap(o, player)
    if sectionOnUnlock:get("triggerTraps") then
        if o.type.getTrapSpell(o) then
            o:activateBy(player)
        elseif I.HTrapsGlobal then
            -- Hidden Traps support
            -- https://www.nexusmods.com/morrowind/mods/59667
            I.HTrapsGlobal.revealTrap(o, "Brute Force lock broken")
            -- need 1 frame delay for the trap to become real
            player:sendEvent("BruteForce_delayedActivation", o)
        end
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
    end

    if not types.Door.destCell(o) then
        types.Door.activateDoor(o, true)
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
