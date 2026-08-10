local storage = require("openmw.storage")
local types = require("openmw.types")
local async = require("openmw.async")

local consts = require("scripts.BruteForce.utils.consts")
local settingsCache = require("scripts.BruteForce.utils.settingsCache")

local settingsDebug = settingsCache.new(storage.globalSection("SettingsBruteForce_debug"), async)

local h = {}

h.itemCanBeDamaged = function(item)
    if not consts.damageableItemTypes[item.type] then return false end

    if item.type == types.Weapon then
        local wType = item.type.records[item.recordId].type
        if consts.nonDamageableWeaponTypes[wType] then return false end
    end

    return true
end

h.displayMessage = function(actor, message)
    if settingsDebug.enableMessages then
        actor:sendEvent('ShowMessage', { message = message })
    end
end

h.objectIsOwned = function(o, player)
    if o.owner.recordId then
        return true
    end

    if o.owner.factionId then
        local playerRank = player.type.getFactionRank(player, o.owner.factionId)
        local requiredRank = o.owner.factionRank or 1
        if playerRank < requiredRank then
            return true
        end
    end

    return false
end

h.getEquippedWeaponSkill = function(actor)
    local weaponSlot = actor.type.EQUIPMENT_SLOT.CarriedRight
    local weapon = actor.type.getEquipment(actor, weaponSlot)
    if weapon then
        local weaponType = weapon.type.records[weapon.recordId].type
        return consts.weaponTypeToSkillGetter[weaponType](actor)
    else
        return actor.type.stats.skills.handtohand(actor)
    end
end

h.getId = function(object)
    if not object.contentFile then return object.id end
    return object.contentFile .. "/" .. object.id:sub(-6)
end

return h
