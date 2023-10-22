local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("CommandQueue")

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
---@field Slot string slot name or item link
---@field Filter string|nil

---@param slot string slot name
---@return string
local function presentEquippedItem(slot)
    local item = mq.TLO.Me.Inventory(slot)
    local s = ""
    if item() == nil then
        s = s .. string.format("%s: [+y+]empty[+x+]", slot)
    else
        s = s .. string.format("%s: %s", slot, item.ItemLink("CLICKABLE")())
    end
    return s
end

---@param command ItemBy
local function execute(command)
    if command.Filter ~= nil and not matches_filter(command.Filter, mq.TLO.Me.Name()) then
        log.Info("/findslot: Not matching filter, giving up: %s", command.Filter)
        return
    end
    local slot = command.Slot

    if is_item_link(slot) then
        local item = find_item(strip_link(slot))
        if item == nil then
            all_tellf("UNLIKELY: /findslot cant resolve item link %s", slot)
            return
        end
        -- TODO create slot name from item, auto chose the first one if multiple equippable slots allowed on the item
        -- TODO create /only|classes races filter

        -- STATUS: unsure if can be done atm with the exported properties.
        --     would need access to item equipslots, list of allowed races, list of allowed classes
        log.Info("TODO IMPL item link handling. item slot for %s: %d, %d", item.Name(), item.ItemSlot(), item.ItemSlot2())
        return
    end

    local aliases = {
        primary = "mainhand",
        secondary = "offhand",
        shoulders = "shoulder",
        hand = "hands",
        leg = "legs",
        foot = "feet",

        -- dual slot aliases
        ear = "ears",
        finger = "rings",
        fingers = "rings",
        ring = "rings",
        wrist = "wrists",
    }
    if aliases[slot] ~= nil then
        slot = aliases[slot]
    end

    local dualSlots = {
        weapons = {"mainhand", "offhand"},
        wrists = {"leftwrist", "rightwrist"},
        ears = {"leftear", "rightear"},
        rings = {"leftfinger", "rightfinger"},
    }
    if dualSlots[slot] ~= nil then
        all_tellf("slot %s, %s (%s %s)", presentEquippedItem(dualSlots[slot][1]), presentEquippedItem(dualSlots[slot][2]), class_shortname(), race_shortname())
        return
    end

    if not isValidEquipmentSlotName(slot) then
        log.Error("Invalid slot name \ay%s\ax!", slot)
        return
    end
    all_tellf("slot %s (%s %s)", presentEquippedItem(slot), class_shortname(), race_shortname())
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
