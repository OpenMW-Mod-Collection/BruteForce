require("scripts.BruteForce.utils.consts")

function GetEquippedWeaponSkillId(actor)
    local weapon = actor.type.getEquipment(actor, actor.type.EQUIPMENT_SLOT.CarriedRight)
    if weapon then
        local weaponType = weapon.type.records[weapon.recordId].type
        return WeaponTypeToSkillId[weaponType]
    else
        return "handtohand"
    end
end

function GetEquippedWeaponSkill(actor)
    local weapon = actor.type.getEquipment(actor, actor.type.EQUIPMENT_SLOT.CarriedRight)
    if weapon then
        local weaponType = weapon.type.records[weapon.recordId].type
        return WeaponTypeToSkill[weaponType](actor)
    else
        return actor.type.stats.skills.handtohand(actor)
    end
end

function CalcHitChance(actor)
    local weaponSkill = GetEquippedWeaponSkill(actor).modified
    local agility = actor.type.stats.attributes.agility(actor).modified
    local luck = actor.type.stats.attributes.luck(actor).modified

    local fatigue = actor.type.stats.dynamic.fatigue(actor)
    local currFatigue = fatigue.current
    local baseFatigue = fatigue.base

    local activeEffects = actor.type.activeEffects(actor)
    local fortAttack = activeEffects:getEffect("fortifyattack").magnitude
    local blind = activeEffects:getEffect("blind").magnitude

    return ((weaponSkill + agility / 5 + luck / 10) * (.75 + (.5 * (currFatigue / baseFatigue))) + fortAttack - blind) /
    100
    -- (Weapon Skill + Agility/5 + Luck/10) × (0.75 + (0.5 × (Current Fatigue/Maximum Fatigue))) + Fortify Attack Magnitude + Blind Magnitude
end