local storage = require("openmw.storage")
local types = require("openmw.types")
local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")

local sectionDebug = storage.playerSection("SettingsBruteForce_debug")
local sectionSettings = storage.playerSection("SettingsBruteForce_settings")
local l10n = core.l10n("BruteForce")

function RegisterAttack(o)
    return sectionDebug:get("modEnabled")
        and types.Lockable.objectIsInstance(o)
        and types.Lockable.isLocked(o)
end

function AttackMissed(o)
    if I.BruteForce.isLockJammed(o.id) then
        self:sendEvent('ShowMessage', { message = l10n("lock_was_jammed") })
        return true
    end

    -- check strength
    local str = self.type.stats.attributes.strength(self).modified
    local lockLevel = types.Lockable.getLockLevel(o)
    local toughness = lockLevel + sectionSettings:get("strBonus")
    if toughness > str then
        self:sendEvent('ShowMessage', { message = l10n("too_weak") })
        return true
    end

    -- emulate hit chance
    if math.random() > CalcHitChance(self) and not sectionDebug:get("alwaysHit") then
        return true
    end

    return false
end

function Unlock(o)
    if math.random() > sectionSettings:get("jamChance") then
        -- unlock lock
        core.sendGlobalEvent("Unlock", { target = o })
        return true
    else
        -- jam lock
        I.BruteForce.setJammedLock(o.id, true)
        self:sendEvent('ShowMessage', { message = l10n("lock_got_jammed") })
        return false
    end
end

function GiveCurrWeaponXp()
    if not sectionSettings:get("enableXpReward") then return end
    I.SkillProgression.skillUsed(
        GetEquippedWeaponSkillId(self),
        { useType = I.SkillProgression.SKILL_USE_TYPES.Weapon_SuccessfulHit }
    )
end

function MakeSound(o)
    -- TODO
end

function ObjectIsOwned(o)
    return o.owner.factionId or o.owner.recordId
end

function DamageContainerEquipment(o)
    if not sectionSettings:get("damageContentsOnUnlock") then return end
    for _, item in pairs(o.type.inventory(o):getAll()) do
        local itemRecord = item.type.records[item.recordId]
        if itemRecord.health then
            core.sendGlobalEvent("ModifyItemCondition", {
                item = item,
                amount = -math.random(itemRecord.health)
            })
        end
    end
end