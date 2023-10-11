local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('commandQueue')

---@class MissingItemById
---@field Id number

---@param command MissingItemById
local function execute(command)
    report_find_missing_item_by_id(command.Id)
end

-- find missing item by id
local function createCommand(id)
    commandQueue.Enqueue(function() execute({Id = toint(id)}) end)
end

mq.bind("/fmid", createCommand)
