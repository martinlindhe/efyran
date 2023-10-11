local mq = require("mq")
local commandQueue = require('app/commandQueue')

local function execute()
    use_corpse_summoner()
end

local function createCommand(distance)
    if is_orchestrator() then
        mq.cmd("/dgzexecute /usecorpsesummoner")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/usecorpsesummoner", createCommand)