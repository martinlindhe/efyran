local mq = require("mq")
local commandQueue = require("lib/CommandQueue")

local function execute()
    disband_all_peers()
end

local function createCommand()
    commandQueue.Enqueue(execute)
end

bind("/disbandall", createCommand)
