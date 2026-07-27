local core = require("openmw.core")
local types = require("openmw.types")
local storage = require("openmw.storage")
local nearby = require("openmw.nearby")
local I = require("openmw.interfaces")

require("scripts.BruteForce.utils.openmw_utils")
require("scripts.BruteForce.utils.detection")

local sectionAlerting = storage.globalSection("SettingsBruteForce_alerting")
local sectionOnUnlock = storage.globalSection("SettingsBruteForce_onUnlock")

local function aggroGuards(actor)
    for _, nearbyActor in ipairs(nearby.actors) do
        if not types.NPC.objectIsInstance(nearbyActor) then
            goto continue
        end

        ---@diagnostic disable-next-line: undefined-field
        local class = nearbyActor.type.records[nearbyActor.recordId].class
        if string.lower(class) == "guard"
            or string.find(nearbyActor.recordId, "guard")
        then
            nearbyActor:sendEvent('StartAIPackage', { type = 'Pursue', target = actor.object })
        end

        ::continue::
    end
end

function AlertNpcs(player)
    local bounty = sectionOnUnlock:get("bounty")
    if bounty <= 0 then return end

    local losMaxDistBase = sectionAlerting:get("losMaxDistBase")
    local losMaxDistSneakModifier = sectionAlerting:get("losMaxDistSneakModifier")
    local soundRangeBase = sectionAlerting:get("soundRangeBase")
    local soundRangeWeaponSkillModifier = sectionAlerting:get("soundRangeWeaponSkillModifier")
    local sneak = player.type.stats.skills.sneak(player).modified
    local weaponSkill = GetEquippedWeaponSkill(player).modified

    local losMaxDist = losMaxDistBase - sneak * losMaxDistSneakModifier
    local soundRange = soundRangeBase - weaponSkill * soundRangeWeaponSkillModifier

    local followers = I.FollowerDetectionUtil
        and I.FollowerDetectionUtil.getFollowerList().followers
        or {}

    for _, actor in ipairs(nearby.actors) do
        local isNPC       = types.NPC.objectIsInstance(actor)
        local isPlayer    = types.Player.objectIsInstance(actor)
        local isFollower  = followers[actor.id]
        local seesPlayer  = CanNpcSeePlayer(actor, player, nearby, losMaxDist)
        local hearsPlayer = IsWithinDistance(actor, player, soundRange)

        local busted = isNPC
            and not isPlayer
            and not isFollower
            and (seesPlayer or hearsPlayer)

        if busted then
            core.sendGlobalEvent("AddBounty", { player = player, bounty = bounty })
            aggroGuards(player)
            break
        end
    end
end
