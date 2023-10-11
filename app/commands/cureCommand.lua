local commandQueue = require('app/commandQueue')
local log          = require("efyran/knightlinc/Write")

---@class CureCommand
---@field Name string
---@field Kind string

---@param command CureCommand
local function execute(command)
    cure_player(command.Name, command.Kind)
end

local function createCommand(name, kind)
    commandQueue.Enqueue(function() execute({ Name = name, Kind = kind }) end)
end

-- auto cure target (usage: is requested by another toon)
mq.bind("/cure", createCommand)
