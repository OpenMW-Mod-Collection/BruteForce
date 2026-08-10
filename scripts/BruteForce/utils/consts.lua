local types = require("openmw.types")

local c = {}

local wTypes = types.Weapon.TYPE
local pSkills = types.Player.stats.skills

c.weaponTypeToSkillGetter = {
    [wTypes.AxeOneHand]        = pSkills.axe,
    [wTypes.AxeTwoHand]        = pSkills.axe,
    [wTypes.BluntOneHand]      = pSkills.bluntweapon,
    [wTypes.BluntTwoClose]     = pSkills.bluntweapon,
    [wTypes.BluntTwoWide]      = pSkills.bluntweapon,
    [wTypes.LongBladeOneHand]  = pSkills.longblade,
    [wTypes.LongBladeTwoHand]  = pSkills.longblade,
    [wTypes.ShortBladeOneHand] = pSkills.shortblade,
    [wTypes.SpearTwoWide]      = pSkills.spear,
}

c.weaponTypeToSkillId = {
    [wTypes.AxeOneHand]        = "axe",
    [wTypes.AxeTwoHand]        = "axe",
    [wTypes.BluntOneHand]      = "bluntweapon",
    [wTypes.BluntTwoClose]     = "bluntweapon",
    [wTypes.BluntTwoWide]      = "bluntweapon",
    [wTypes.LongBladeOneHand]  = "longblade",
    [wTypes.LongBladeTwoHand]  = "longblade",
    [wTypes.ShortBladeOneHand] = "shortblade",
    [wTypes.SpearTwoWide]      = "spear",
}

c.damageableItemTypes = {
    [types.Weapon] = true,
    [types.Armor]  = true,
}
c.nonDamageableWeaponTypes = {
    [wTypes.Arrow]          = true,
    [wTypes.Bolt]           = true,
    [wTypes.MarksmanThrown] = true,
}

return c
