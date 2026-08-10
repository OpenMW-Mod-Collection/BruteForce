---@diagnostic disable: missing-parameter
local I = require('openmw.interfaces')
local core = require("openmw.core")

local l10n = core.l10n("BruteForce")

I.Settings.registerGroup {
    key = 'SettingsBruteForce_locks',
    page = 'BruteForce',
    l10n = 'BruteForce',
    name = 'locks_group_name',
    order = 1,
    permanentStorage = true,
    settings = {
        {
            key = 'strengthRequirement',
            name = 'strengthRequirement_name',
            description = 'strengthRequirement_desc',
            renderer = 'number',
            integer = false,
            default = 25,
        },
        {
            key = "minHitChance",
            name = "minHitChance_name",
            renderer = "SuperSlider6",
            default = 15,
            argument = {
                default = 15,
                showDefaultMark = true,
                showResetButton = true,
                bottomRow = true,
                unit = "%",
            },
        },
        {
            key = 'punchDamageMult',
            name = 'punchDamageMult_name',
            description = 'punchDamageMult_desc',
            renderer = 'multinumber',
            default = { hit = 0.5, miss = 0.2 },
            argument = {
                keys = { "hit", "miss" },
                integer = false,
            },
        },
        {
            key = 'bendingChance',
            name = 'bendingChance_name',
            description = 'bendingChance_desc',
            renderer = "SuperSlider6",
            default = 15,
            argument = {
                default = 15,
                showDefaultMark = true,
                showResetButton = true,
                bottomRow = true,
                unit = "%",
            },
        },
        {
            key = 'weaponWearMult',
            name = 'weaponWearMult_name',
            description = 'weaponWearMult_desc',
            renderer = 'number',
            integer = false,
            default = 10,
            min = 0,
        },
        {
            key = 'wearWeaponsAgainstBentLocks',
            name = 'wearWeaponsAgainstBentLocks_name',
            renderer = 'checkbox',
            default = true,
        },
        {
            key = 'damageContents',
            name = 'damageContents_name',
            description = 'damageContents_desc',
            renderer = 'checkbox',
            default = true,
        },
        {
            key = 'triggerTrapsOn',
            name = 'triggerTrapsOn_name',
            renderer = 'multiselect',
            default = {
                split     = true,
                bent      = true,
                missed    = false,
                notLocked = true,
            },
            argument = {
                keys = {
                    "split",
                    "bent",
                    "missed",
                    "notLocked",
                },
                aliases = {
                    split     = l10n("triggerTrapsOn_split"),
                    bent      = l10n("triggerTrapsOn_bent"),
                    missed    = l10n("triggerTrapsOn_missed"),
                    notLocked = l10n("triggerTrapsOn_notLocked"),
                },
            },
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsBruteForce_alerting',
    page = 'BruteForce',
    l10n = 'BruteForce',
    name = 'alerting_group_name',
    description = 'alerting_group_desc',
    order = 3,
    permanentStorage = true,
    settings = {
        {
            key = 'soundRange',
            name = 'soundRange_name',
            description = 'soundRange_desc',
            renderer = 'multinumber',
            default = {
                ['base distance'] = 500,
                ["weapon skill mult"] = 1
            },
            argument = {
                keys = { "base distance", "weapon skill mult" },
                integer = false,
            },
        },
        {
            key = 'missingIsACrime',
            name = 'missingIsACrime_name',
            description = 'missingIsACrime_desc',
            renderer = 'checkbox',
            default = true,
        },
    }
}

I.Settings.registerGroup {
    key = 'SettingsBruteForce_debug',
    page = 'BruteForce',
    l10n = 'BruteForce',
    name = 'debug_group_name',
    order = 100,
    permanentStorage = true,
    settings = {
        {
            key = 'modEnabled',
            name = 'modEnabled_name',
            renderer = 'checkbox',
            default = true,
        },
        {
            key = 'enableMessages',
            name = 'enableMessages_name',
            renderer = 'checkbox',
            default = true,
        },
        {
            key = 'ignoreBentLocks',
            name = 'ignoreBentLocks_name',
            renderer = 'checkbox',
            default = false,
        },
        {
            key = 'unlockWithBrokenWeapons',
            name = 'unlockWithBrokenWeapons_name',
            description = 'unlockWithBrokenWeapons_desc',
            renderer = 'checkbox',
            default = false,
        },
    }
}
