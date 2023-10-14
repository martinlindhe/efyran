local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require('e4_CommandQueue')

local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local bci = broadCastInterfaceFactory()

---@class ItemBy
---@field Slot string slot name
---@field Filter string|nil

---@param command ItemBy
local function execute(command)
    if command.Filter ~= nil and not matches_filter(command.Filter, mq.TLO.Me.Name()) then
        log.Info("/findslot: Not matching filter, giving up: %s", command.Filter)
        return
    end
    local slot = command.Slot
    if slot == "primary" then
        slot = "mainhand"
    elseif slot == "secondary" then
        slot = "offhand"
    end

    local item = mq.TLO.Me.Inventory(slot)
    if item() == nil then
        all_tellf("%s slot: empty", slot)
    else
        all_tellf("%s slot: %s", slot, item.ItemLink("CLICKABLE")())
    end
end

-- arg: item name + optional /filter arguments as strings
local function createCommand(...)
    local args = args_string(...)
    local name = args
    local filter = nil
    local tokens = split_str(name, "/")
    if #tokens == 2 then
        name = trim(tokens[1])
        filter = "/" .. tokens[2]
    end
    if name ~= "" then
        if is_orchestrator() then
            bci.ExecuteZoneCommand(string.format("/findslot %s", args))
        end
        commandQueue.Enqueue(function() execute({ Slot = name, Filter = filter }) end)
    end
end

mq.bind("/findslot", createCommand)