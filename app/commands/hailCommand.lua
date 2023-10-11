local mq = require("mq")
local commandQueue = require('app/commandQueue')
local hail    = require("efyran/e4_Hail")

local function execute()
    hail.PerformHail()
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

local function createHailAllCommand()
    if is_orchestrator() then
        cmd("/dgzexecute /hailit")
    end

    commandQueue.Enqueue(function() execute() end)
end

-- hail or talk to nearby recognized NPC
mq.bind("/hailit", createCommand)

-- tells all peers to hail or talk to nearby recognized NPC
mq.bind("/hailall", createHailAllCommand)
