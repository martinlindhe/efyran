local mq = require("mq")
local commandQueue = require("CommandQueue")

---@class CircleMeCommand
---@field Distance number

---@param command CircleMeCommand
local function execute(command)
    make_peers_circle_me(command.Distance)
end

local function createCommand(distance)
    commandQueue.Enqueue(function() execute({Distance = toint(distance)}) end)
end

bind("/circleme", createCommand)
