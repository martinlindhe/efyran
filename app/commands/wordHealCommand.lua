local mq = require("mq")
local commandQueue = require('app/commandQueue')

local function execute()
    cast_word_heal()
end

-- tell clerics to use word heals
local function createCommand()
    if is_orchestrator() then
        cmd("/dgzexecute /wordheal")
    end
    if not is_clr() then
        return
    end

    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/wordheal", createCommand)
