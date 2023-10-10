local commandQueue = require('app/commandQueue')

local function execute()
    report_active_tasks()
end

local function createCommand(...)
    local name = args_string(...)
    if is_orchestrator() then
        mq.cmdf("/dgzexecute /listtasks %s", name)
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/teleportbind", createCommand)
mq.bind("/tlbind", createCommand)
