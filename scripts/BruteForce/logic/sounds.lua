local core = require("openmw.core")
local types = require("openmw.types")

local s = {}

local path = "sound/BruteForce/"

s.lockHit = function(o, player, unlocked)
    if unlocked and o.type == types.Container then
        core.sound.playSoundFile3d(path .. "container lock split.mp3", o, {
            pitch = 1,
            volume = 1.5,
        })
    elseif not unlocked and o.type == types.Container then
        core.sound.playSoundFile3d(path .. "container lock bent.mp3", o, {
            volume = .6
        })
    elseif unlocked and o.type == types.Door then
        core.sound.playSoundFile3d(path .. "door lock split.mp3", o, {
            volume = 1,
        })
        core.sound.playSoundFile3d(path .. "container lock split.mp3", o, {
            pitch = .75
        })
    elseif not unlocked and o.type == types.Door then
        core.sound.playSoundFile3d(path .. "door lock bent.mp3", o, {
            volume = 1
        })
    end
end

return s
