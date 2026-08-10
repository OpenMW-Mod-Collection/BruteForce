local I = require("openmw.interfaces")
local types = require("openmw.types")
local storage = require("openmw.storage")
local async = require("openmw.async")

local helpers = require("scripts.BruteForce.utils.helpers")
local settingsCache = require("scripts.BruteForce.utils.settingsCache")

local settingsAlerting = settingsCache.new(storage.globalSection("SettingsBruteForce_alerting"), async)

local c = {}

local isNpc = types.NPC.objectIsInstance
local isPlayer = types.Player.objectIsInstance
local isDead = types.Actor.isDead

c.commitCrime = function(obj, player, actorList, soundCheck)
    if not helpers.objectIsOwned(obj, player) then
        return
    end

    local objPos = obj.position
    local followers = I.FollowerDetectionUtil
        and I.FollowerDetectionUtil.getFollowerList().followers
        or {}

    local srBase = settingsAlerting.soundRange["base distance"]
    local srWeaponSkillMod = settingsAlerting.soundRange["weapon skill mult"]
    local weaponSkill = helpers.getEquippedWeaponSkill(player).modified
    local soundRange = srBase - weaponSkill * srWeaponSkillMod

    local ownedByActor = obj.owner.recordId
    local victim
    local soundHeard = false
    if ownedByActor or soundCheck then
        for _, actor in ipairs(actorList) do
            if ownedByActor and obj.owner.recordId == actor.recordId then
                victim = actor
            end

            if soundCheck
                and not soundHeard
                and isNpc(actor)
                and not isPlayer(actor)
                and not followers[actor.id]
                and not isDead(actor)
                and (objPos - actor.position):length() < soundRange
            then
                soundHeard = true
            end

            if (victim or not ownedByActor) and (soundHeard or not soundCheck) then
                break
            end
        end
    end

    I.Crimes.commitCrime(player, {
        type = types.Player.OFFENSE_TYPE.Trespassing,
        victim = victim,
        faction = obj.owner.factionId,
        victimAware = soundHeard,
    })
end

return c
