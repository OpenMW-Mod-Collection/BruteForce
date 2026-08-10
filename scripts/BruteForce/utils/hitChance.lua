---@diagnostic disable: missing-parameter
local self = require("openmw.self")
local core = require("openmw.core")

local helpers = require("scripts.BruteForce.utils.helpers")

local fFatigueMult = core.getGMST("fFatigueMult")
local fFatigueBase = core.getGMST("fFatigueBase")

local activeEffects = self.type.activeEffects(self)
local agility = self.type.stats.attributes.agility(self)
local luck = self.type.stats.attributes.luck(self)
local fatigue = self.type.stats.dynamic.fatigue(self)

local hc = {}

hc.calculate = function()
    local weaponSkill = helpers.getEquippedWeaponSkill(self)
    local fortifyAttack = activeEffects:getEffect("fortifyattack").magnitude
    local blind = activeEffects:getEffect("blind").magnitude

    local normalizedFatigue = fatigue.current / fatigue.base
    local fatigueTerm = fFatigueBase - fFatigueMult * (1 - normalizedFatigue)

    local attackTerm = (
        weaponSkill.modified
        + 0.2 * agility.modified
        + 0.1 * luck.modified
    )
    attackTerm = attackTerm * fatigueTerm
    attackTerm = attackTerm + fortifyAttack - blind

    return attackTerm
end

return hc
