local core = require("openmw.core")
local types = require("openmw.types")
local self = require("openmw.self")

function PlaySFX(o, unlocked)
    if unlocked and o.type == types.Container then
        core.sendGlobalEvent("PlaySound3d", {
            file = "sound/container lock split.mp3",
            position = self,
            options = {
                pitch = 1,
                volume = 1.5,
            },
        })
    elseif not unlocked and o.type == types.Container then
        core.sendGlobalEvent("PlaySound3d", {
            file = "sound/container lock bent.mp3",
            position = self,
            options = {
                volume = .6
            },
        })
    elseif unlocked and o.type == types.Door then
        core.sendGlobalEvent("PlaySound3d", {
            file = "sound/door lock split.mp3",
            position = self,
            options = {
                volume = 1,
            },
        })
        core.sendGlobalEvent("PlaySound3d", {
            file = "sound/container lock split.mp3",
            position = self,
            options = {
                pitch = .75
            },
        })
    elseif not unlocked and o.type == types.Door then
        core.sendGlobalEvent("PlaySound3d", {
            file = "sound/door lock bent.mp3",
            position = self,
            options = {
                volume = 1
            },
        })
    end
end