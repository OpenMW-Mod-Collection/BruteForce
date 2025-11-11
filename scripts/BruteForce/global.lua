local world = require("openmw.world")

-- local function onUnlock(data)
--     print("hoi")
--     for _, player in ipairs(world.players) do
--         player:sendEvent("jammedLockOpen", {id = data.target.id})
--     end
-- end

-- return {
--     eventHandlers = {
--         Unlock = onUnlock,
--     },
-- }

local time = require("openmw_aux.time")
local types = require("openmw.types")

local function checkLockables()
    for _, player in ipairs(world.players) do
        for _, obj in ipairs(player.cell:getAll(types.Door)) do
            if not types.Lockable.isLocked(obj) then
                player:sendEvent("jammedLockOpen", {id = obj.id})
            end
        end
        for _, obj in ipairs(player.cell:getAll(types.Container)) do
            if not types.Lockable.isLocked(obj) then
                player:sendEvent("jammedLockOpen", {id = obj.id})
            end
        end
    end
end

time.runRepeatedly(
    checkLockables,
    5,
    { type = time.SimulationTime })