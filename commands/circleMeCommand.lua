local mq = require("mq")
local commandQueue = require("lib/CommandQueue")

local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

-- form bots in a circle around orchestrator
---@param dist integer|nil Distance from the center
local function make_peers_circle_me(dist)

	local n = peer_count()
    if dist == nil then
        dist = 20
    end

    bci.ExecuteZoneCommand("/followoff")

    for i, peer in pairs(get_peers()) do
        local angle = (360 / n) * i
        if is_peer_in_zone(peer) then
            local y = mq.TLO.Me.Y() + (dist * math.sin(angle))
            local x = mq.TLO.Me.X() + (dist * math.cos(angle))
            bci.ExecuteCommand(string.format("/moveto loc %d %d", y, x), {peer})
        end
    end
end

---@class CircleMeCommand
---@field Distance integer

---@param command CircleMeCommand
local function execute(command)
    make_peers_circle_me(command.Distance)
end

local function createCommand(distance)
    commandQueue.Enqueue(function() execute({Distance = toint(distance)}) end)
end

bind("/circleme", createCommand)
