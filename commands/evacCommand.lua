local mq = require("mq")
local commandQueue = require('commandQueue')

local function execute()
    cast_evac_spell()
end

local function createCommand(distance)
    if is_orchestrator() then
        mq.cmd("/dgzexecute /evac")
    end

    -- clear queue so that evac happens next
    commandQueue.Clear()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/evac", createCommand)
