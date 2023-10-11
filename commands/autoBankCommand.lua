local mq = require("mq")
local commandQueue = require('commandQueue')
local autobank = require("autobank")

local function execute()
    autobank()
end

-- auto banks items from tradeskills.ini
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end


mq.bind("/autobank", createCommand)
