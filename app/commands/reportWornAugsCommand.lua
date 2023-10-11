local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('app/commandQueue')

local function execute()
    report_worn_augs()
end

-- reports all currently worn auguments
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/wornaugs", createCommand)
