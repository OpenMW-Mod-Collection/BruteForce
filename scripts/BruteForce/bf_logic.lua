local storage = require("openmw.storage")
local types = require("openmw.types")
local self = require("openmw.self")
local core = require("openmw.core")
local I = require("openmw.interfaces")

local omw_utils = require("scripts.BruteForce.utils.openmw_utils")

local sectionDebug = storage.playerSection("SettingsBruteForce_debug")
local sectionSettings = storage.playerSection("SettingsBruteForce_settings")
local l10n = core.l10n("BruteForce")

local logic = {}

function logic.registerAttack(o)
    return sectionDebug:get("modEnabled")
        and types.Lockable.objectIsInstance(o)
        and types.Lockable.isLocked(o)
end

function logic.attackMissed(o)
    -- check strength
    local str = self.type.stats.attributes.strength(self).modified
    local lockLevel = types.Lockable.getLockLevel(o)
    local toughness = lockLevel + sectionSettings:get("strBonus")
    if toughness > str then
        self:sendEvent('ShowMessage', { message = l10n("too_weak") })
        return true
    end

    -- emulate hit chance
    if math.random() > omw_utils.calcHitChance(self) and not sectionDebug:get("alwaysHit") then
        return true
    end

    return false
end

function logic.unlock(o)
    if math.random() > sectionSettings:get("jamChance") then
        -- unlock lock
        core.sendGlobalEvent("Unlock", { target = o })
        return true
    else
        -- jam lock
        core.sendGlobalEvent("setJammedLock", { id = o.id, val = true })
        self:sendEvent('ShowMessage', { message = l10n("lock_got_jammed") })
        return false
    end
end

function logic.giveCurrWeaponXp()
    if not sectionSettings:get("enableXpReward") then return end
    I.SkillProgression.skillUsed(
        omw_utils.getEquippedWeaponSkillId(self),
        { useType = I.SkillProgression.SKILL_USE_TYPES.Weapon_SuccessfulHit }
    )
end

function logic.alertNpcs(o)
    -- TODO
end

function logic.objectIsOwned(o)
    return o.owner.factionId or o.owner.recordId
end

function logic.damageContainerEquipment(o)
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

return logic