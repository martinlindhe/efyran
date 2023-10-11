local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('e4_commandQueue')

---@class ListClickesCommand
---@field Category string

---@param command ListClickesCommand
local function execute(command)
    list_my_clickies(command.Category)
end

-- reports all owned clickies (worn, inventory, bank) worn auguments
local function createCommand(category)
    commandQueue.Enqueue(function() execute({Category = category}) end)
end

mq.bind("/listclickies", createCommand)
