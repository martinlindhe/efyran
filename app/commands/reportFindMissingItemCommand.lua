local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('app/commandQueue')

---@class FindItemBy
---@field Name string
---@field Filter string|nil

---@param command FindItemBy
local function execute(command)
    report_find_item(command.Name, command.Filter)
end

-- find missing item
-- arg: item name + optional /filter arguments as strings
local function createCommand(...)
    local name = args_string(...)
    local filter = nil
    local tokens = split_str(name, "/")
    if #tokens == 2 then
        name = trim(tokens[1])
        filter = "/" .. tokens[2]
    end
    if name ~= "" then
        commandQueue.Enqueue(function() execute({ Name = name, Filter = filter }) end)
    end
end

mq.bind("/fmid", createCommand)
