local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    local s = ""
    if mq.TLO.Me.RadiantCrystals() > 0 then
        s = s .. string.format("Radiant Crystals \ay%d\ax", mq.TLO.Me.RadiantCrystals())
    end
    if mq.TLO.Me.EbonCrystals() > 0 then
        if s ~= "" then
            s = s .. ", "
        end
        s = s .. string.format("Ebon Crystals \ay%d\ax", mq.TLO.Me.EbonCrystals())
    end
    if s ~= "" then
        all_tellf(s)
    end
end

local function createCommand(distance)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/doncrystals")
    end

    commandQueue.Enqueue(function() execute() end)
end

-- report DoN crystals count on all connected peers
bind("/doncrystals", createCommand)
