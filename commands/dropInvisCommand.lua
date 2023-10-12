local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    drop_invis()
end

local function createCommand()
    if is_orchestrator() then
        cmd("/dgzexecute /dropinvis")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/dropinvis", createCommand)
