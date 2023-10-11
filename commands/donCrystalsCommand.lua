local mq = require("mq")
local commandQueue = require('e4_commandQueue')

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
        mq.cmd("/dgzexecute /doncrystals")
    end

    commandQueue.Enqueue(function() execute() end)
end

-- report DoN crystals count on all connected peers
mq.bind("/doncrystals", createCommand)
