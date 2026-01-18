local storage = require("openmw.storage")
local nearby = require("openmw.nearby")
local types = require("openmw.types")
local core = require("openmw.core")
local I = require("openmw.interfaces")

require("scripts.BruteForce.utils.openmw_utils")
require("scripts.BruteForce.utils.detection")
require("scripts.BruteForce.logic.sounds")

local sectionOnHit = storage.globalSection("SettingsBruteForce_onHit")
local sectionOnUnlock = storage.globalSection("SettingsBruteForce_onUnlock")
local sectionAlerting = storage.globalSection("SettingsBruteForce_alerting")
local l10n = core.l10n("BruteForce")

function Unlock(o, actor)
    local unlocked = false
    if math.random() > sectionOnHit:get("jamChance") then
        -- unlock lock
        core.sendGlobalEvent("Unlock", { target = o })
        unlocked = true
    else
        -- jam lock
        ---@diagnostic disable-next-line: assign-type-mismatch
        core.sendGlobalEvent("setJammedLock", { id = o.id, val = true })
        ---@diagnostic disable-next-line: missing-parameter
        DisplayMessage(actor, l10n("lock_got_jammed"))
    end

    PlaySFX(o, unlocked)

    return unlocked
end

function WearWeapon(o, actor)
    local weaponSlot = types.Actor.EQUIPMENT_SLOT.CarriedRight
    local weapon = actor.type.getEquipment(actor, weaponSlot)
    local wearMod = sectionOnUnlock:get("weaponWearModifier")

    if not weapon or wearMod == 0 then return end

    local lockLevel = types.Lockable.getLockLevel(o)
    local dmg = -math.min(
        lockLevel * wearMod,
        weapon.type.records[weapon.recordId].health
    )

    core.sendGlobalEvent("ModifyItemCondition", {
        item = weapon,
        amount = dmg,
    })
end

function GiveCurrWeaponXp(actor)
    if not sectionOnUnlock:get("enableXpReward") then return end
    I.SkillProgression.skillUsed(
        GetEquippedWeaponSkillId(actor),
        { useType = I.SkillProgression.SKILL_USE_TYPES.Weapon_SuccessfulHit }
    )
end

function TriggerTrap(o, actor)
    if not types.Lockable.objectIsInstance(o) then return end

    local spell = o.type.getTrapSpell(o)
    if not spell then return end

    -- disarm trap
    core.sendGlobalEvent("untrapObject", { o = o })

    -- fire a spell on an actor
    local effectsWithParams = core.magic.spells.records[spell.id].effects
    local effects = {}
    for _, effect in pairs(effectsWithParams) do
        table.insert(effects, effect.index)
    end
    actor.type.activeSpells(actor):add({
        id = spell.id,
        effects = effects
    })
end

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

function AlertNpcs(actor)
    local bounty = sectionOnUnlock:get("bounty")
    if bounty <= 0 then return end

    local losMaxDistBase = sectionAlerting:get("losMaxDistBase")
    local losMaxDistSneakModifier = sectionAlerting:get("losMaxDistSneakModifier")
    local soundRangeBase = sectionAlerting:get("soundRangeBase")
    local soundRangeWeaponSkillModifier = sectionAlerting:get("soundRangeWeaponSkillModifier")
    local sneak = actor.type.stats.skills.sneak(actor).modified
    local weaponSkill = GetEquippedWeaponSkill(actor).modified

    local losMaxDist = losMaxDistBase - sneak * losMaxDistSneakModifier
    local soundRange = soundRangeBase - weaponSkill * soundRangeWeaponSkillModifier

    for _, nearbyActor in ipairs(nearby.actors) do
        local isNPC       = types.NPC.objectIsInstance(nearbyActor)
        local isPlayer    = types.Player.objectIsInstance(nearbyActor)
        local seesPlayer  = CanNpcSeePlayer(nearbyActor, actor, nearby, losMaxDist)
        local hearsPlayer = IsWithinDistance(nearbyActor, actor, soundRange)

        if isNPC and not isPlayer and (seesPlayer or hearsPlayer) then
            core.sendGlobalEvent("addBounty", { player = actor, bounty = bounty })
            aggroGuards()
            break
        end
    end
end

function DamageContainerEquipment(o)
    if not sectionOnUnlock:get("damageContents") then return end
    for _, item in pairs(o.type.inventory(o):getAll()) do
        if ItemCanBeDamaged(item) then
            local dmg = -math.random(item.type.records[item.recordId].health)
            core.sendGlobalEvent("ModifyItemCondition", {
                item = item,
                amount = dmg
            })
        end
    end
end
