local mq = require("mq")
local commandQueue = require('commandQueue')

---@class CircleMeCommand
---@field Distance number

---@param command CircleMeCommand
local function execute(command)
    make_peers_circle_me(command.Distance)
end

local function createCommand(distance)
    commandQueue.Enqueue(function() execute({Distance = toint(distance)}) end)
end

mq.bind("/circleme", createCommand)
