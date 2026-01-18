local storage = require("openmw.storage")
local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")

require("scripts.BruteForce.utils.consts")
require("scripts.BruteForce.logic.onHit")
require("scripts.BruteForce.logic.alerting")
require("scripts.BruteForce.utils.openmw_utils")

local sectionOnHit = storage.globalSection("SettingsBruteForce_onHit")

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
end

local function giveCurrWeaponXp()
    I.SkillProgression.skillUsed(
        GetEquippedWeaponSkillId(self),
        { useType = I.SkillProgression.SKILL_USE_TYPES.Weapon_SuccessfulHit }
    )
end

local function aggroGuards()
    AlertNpcs(self)
end

CheckDependencies(self, Dependencies)
I.impactEffects.addHitObjectHandler(onObjectHit)

return {
    eventHandlers = {
        GiveCurrWeaponXp = giveCurrWeaponXp,
        AggroGuards = aggroGuards,
    }
}
