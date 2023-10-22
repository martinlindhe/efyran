local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("CommandQueue")

local function execute()
    open_nearby_corpse()
end

-- open loot window on closest corpse
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/lcorpse", createCommand)
