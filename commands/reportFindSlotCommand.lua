local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require('e4_CommandQueue')

local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local bci = broadCastInterfaceFactory()

-- Returns true if `name` is a valid equipment slot
---@param name string slot name
---@return boolean
local function isValidEquipmentSlotName(name)
    local validNames = {
        "charm", "leftear", "head", "face", "rightear", "neck", "shoulder", "arms", "back", "leftwrist",
        "rightwrist", "ranged", "hands", "mainhand", "offhand", "leftfinger", "rightfinger", "chest", "legs",
        "feet", "waist", "powersource", "ammo",
    }
    for _, v in pairs(validNames) do
        if v == name then
            return true
        end
    end
    return false
end

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

    local aliases = {
        primary = "mainhand",
        secondary = "offhand",
        shoulders = "shoulder",
        hand = "hands",
        leg = "legs",
        foot = "feet",
    }
    if aliases[slot] ~= nil then
        slot = aliases[slot]
    end

    if not isValidEquipmentSlotName(slot) then
        log.Error("Invalid slot name \ay%s\ax!", slot)
        return
    end

    local item = mq.TLO.Me.Inventory(slot)
    if item() == nil then
        all_tellf("%s slot: [+y+]empty[+x+] (%s %s)", slot, class_shortname(), race_shortname())
    else
        all_tellf("%s slot: %s (%s %s)", slot, item.ItemLink("CLICKABLE")(), class_shortname(), race_shortname())
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

bind("/findslot", createCommand)