local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    disband_all_peers()
end

local function createCommand()
    commandQueue.Enqueue(execute)
end

bind("/disbandall", createCommand)
