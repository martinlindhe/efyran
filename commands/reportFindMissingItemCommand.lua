local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("CommandQueue")

---@class FindItemBy
---@field Name string
---@field Filter string|nil

---@param name string
---@param filter string|nil
local function report_find_missing_item(name, filter)
    name = strip_link(name)

    if is_orchestrator() then
        local exe = string.format("/fmi %s", name)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        bci.ExecuteZoneCommand(exe)
    end

    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
        log.Info("/fmi: I do not match filter \ay%s\ax", filter)
        return
    end

    local item = find_item(name)
    if item ~= nil then
        return
    end

    local item = find_item_bank(name)
    if item ~= nil then
        return
    end
    all_tellf("I miss \ay%s\ax", name)
end

---@param command FindItemBy
local function execute(command)
    report_find_missing_item(command.Name, command.Filter)
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

bind("/fmi", createCommand)
