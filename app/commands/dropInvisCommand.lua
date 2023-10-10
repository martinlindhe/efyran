local commandQueue = require('app/commandQueue')

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
