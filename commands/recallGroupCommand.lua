local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local group   = require("e4_Group")

---@class RecallGroupCommand
---@field Name string
---@field GroupNumber string

---@param command RecallGroupCommand
local function execute(command)
    group.RecallGroup(command.Name, command.GroupNumber)
end

-- Recalls group setup from settings. The orchestrator (caller) will tell the rest how to form up
local function createCommand(name, groupNumber)
    commandQueue.Enqueue(function() execute({Name=name, GroupNumber = groupNumber}) end)
end

bind("/recallgroup", createCommand)
