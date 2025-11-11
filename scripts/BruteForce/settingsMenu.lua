local I = require('openmw.interfaces')

I.Settings.registerPage {
    key = 'BruteForce',
    l10n = 'BruteForce',
    name = 'page_name',
    description = 'page_description',
}

I.Settings.registerGroup {
    key = 'SettingsBruteForce_settings',
    page = 'BruteForce',
    l10n = 'BruteForce',
    name = 'settings_group_name',
    order = 1,
    permanentStorage = true,
    settings = {
        {
            key = 'strBonus',
            name = 'strBonus_name',
            description = 'strBonus_description',
            renderer = 'number',
            integer = false,
            default = 25,
        },
        {
            key = 'jamChance',
            name = 'jamChance_name',
            description = 'jamChance_description',
            renderer = 'number',
            integer = false,
            default = .15,
            min = 0,
            max = 1,
        },
        {
            key = 'enableXpReward',
            name = 'enableXpReward_name',
            description = 'enableXpReward_description',
            renderer = 'checkbox',
            default = true,
        },
        {
            key = 'damageContentsOnUnlock',
            name = 'damageContentsOnUnlock_name',
            description = 'damageContentsOnUnlock_description',
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
            key = 'alwaysHit',
            name = 'alwaysHit_name',
            renderer = 'checkbox',
            default = false,
        },
    }
}