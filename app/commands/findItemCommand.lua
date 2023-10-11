local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('app/commandQueue')

---@class MissingItemBy
---@field Name string
---@field Filter string|nil

---@param command MissingItemBy
local function execute(command)
    report_find_item(command.Name, command.Filter)
end

-- finds item by name in inventory/bags
-- NOTE: "/finditem" is reserved in eq live for "dragon hoard" feature
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

mq.bind("/fdi", createCommand)
