local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('commandQueue')

local function execute()
    open_nearby_corpse()
end

-- open loot window on closest corpse
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/lcorpse", createCommand)