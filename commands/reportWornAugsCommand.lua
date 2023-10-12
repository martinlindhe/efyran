local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require('e4_CommandQueue')

local function execute()
    report_worn_augs()
end

-- reports all currently worn auguments
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/wornaugs", createCommand)
