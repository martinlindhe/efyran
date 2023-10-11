local mq = require("mq")
local commandQueue = require('e4_commandQueue')

local function execute()
    use_alt_ability("Origin")
end

local function createCommand(distance)
    if is_orchestrator() then
        mq.cmd("/dgzexecute /origin")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/origin", createCommand)
