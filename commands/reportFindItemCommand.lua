local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require('e4_CommandQueue')

---@class MissingItemBy
---@field Name string
---@field Filter string|nil

-- used by /fdi
---@param name string
---@param filter string|nil
local function report_find_item(name, filter)
    name = strip_link(name)
    log.Info("Searching for %s", name)

    if is_orchestrator() then
        local exe = string.format("/fdi %s", name)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        bci.ExecuteZoneCommand(exe)
    end

    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
        log.Info("/fdi: I do not match filter \ay%s\ax", filter)
        return
    end

    local s = ""
    local click = ""

    local item = find_item(name)
    if item ~= nil then
        click = item.ItemLink("CLICKABLE")()
        local inv_cnt = inventory_item_count(item.Name())
        if inv_cnt == 1 then
            s = string.format("%s", inventory_slot_name(item.ItemSlot()))
        else
            s = string.format("%s (count: %d)", inventory_slot_name(item.ItemSlot()), inv_cnt)
        end
    end

    item = find_item_bank(name)
    if item ~= nil then
        click = item.ItemLink("CLICKABLE")()
        local in_bank = banked_item_count(item.Name())
        if in_bank > 0 then
            s = s .. ", "
        end
        if in_bank == 1 then
            s = s .. string.format("bank slot %d", item.ItemSlot())
        elseif in_bank > 0 then
            s = s .. string.format("bank (count: %d)", in_bank)
        end
    end

    if s ~= "" then
        all_tellf("%s in %s", click, s)
    end
end

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
mq.bind("/finditem", createCommand)