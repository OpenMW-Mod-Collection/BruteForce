---@diagnostic disable: missing-parameter, assign-type-mismatch
local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local storage = require("openmw.storage")
local async = require("openmw.async")

local utils = require("scripts.BruteForce.utils.helpers")
local hitChance = require("scripts.BruteForce.utils.hitChance")
local settingsCache = require("scripts.BruteForce.utils.settingsCache")

local settingsLocks = settingsCache.new(storage.globalSection("SettingsBruteForce_locks"), async)
local settingsDebug = settingsCache.new(storage.globalSection("SettingsBruteForce_debug"), async)
local l10n = core.l10n("BruteForce")

local strength = self.type.stats.attributes.strength(self)

local h = {}

h.attackMissed = function(lockLevel)
    local toughness = lockLevel + settingsLocks.strengthRequirement
    if toughness > strength.modified then
        utils.displayMessage(self, l10n("player_too_weak"))
        return true
    end

    local currHitChance = math.max(
        settingsLocks.minHitChance / 100,
        hitChance.calculate()
    )

    return math.random() > currHitChance
end

h.weaponTooWorn = function(weapon, lockLevel)
    if settingsDebug.unlockWithBrokenWeapons then
        return false
    end

    local wearMult = settingsLocks.weaponWearMult

    if not weapon or wearMult <= 0 then
        return false
    end

    local weaponCondition = weapon.type.itemData(weapon).condition

    if lockLevel * wearMult > weaponCondition then
        utils.displayMessage(self, l10n("weapon_too_worn"))
        return true
    else
        return false
    end
end

h.getFistsDamaged = function(missed, lockLevel)

    local damageMult = not missed
        and settingsLocks.punchDamageMult.hit
        or settingsLocks.punchDamageMult.miss

    if damageMult <= 0 then
        return
    end

    self:sendEvent("Hit", {
        sourceType = I.Combat.ATTACK_SOURCE_TYPES.Melee,
        strength = 1,
        attacker = self,
        damage = {
            health = lockLevel * damageMult,
        },
        successful = true,
    })
end

return h
