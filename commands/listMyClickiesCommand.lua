local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require('e4_CommandQueue')

---@class ListClickesCommand
---@field Category string

---@param cat string|nil Category (manaregen, xxx)
local function list_my_clickies(cat)
    if cat ~= nil then
        all_tellf("report_clickies: TODO handle category arg")
    end
    log.Info("My clickies:")

    -- XXX TODO skip Expendable
    -- XXX 15 sep 2022: item.Expendable() seem to be broken, always returns false ? https://discord.com/channels/511690098136580097/840375268685119499/1019900421248126996

    -- equipment: 0-22 is worn gear, 23-32 is inventory top level
    for i = 0, 32 do
        if mq.TLO.Me.Inventory(i).ID() then
            local inv = mq.TLO.Me.Inventory(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item.Clicky() ~= nil and not item.Expendable() then
                        --print ( "one ", item.Name(), " ", item.Charges() , " ", item.Expendable())
                        log.Info(inventory_slot_name(i).." # "..c.." "..item.ItemLink("CLICKABLE")().." effect: "..item.Clicky.Spell.Name())
                    end
                end
            else
                if inv.Clicky() ~= nil and not inv.Expendable() then
                    --print ( "two ", inv.Name(), " ", inv.Charges(), " ", inv.Expendable())
                    log.Info(inventory_slot_name(i).." "..inv.ItemLink("CLICKABLE")().." effect: "..inv.Clicky.Spell.Name())
                end
            end
        end
    end

    -- bank top level slots: 1-24 is bank bags, 25-26 is shared bank
    for i = 1, 26 do
        if mq.TLO.Me.Bank(i)() ~= nil then
            local key = "bank"..tostring(i)
            local inv = mq.TLO.Me.Bank(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item.Clicky() ~= nil and not item.Expendable() then
                        --print( "three ", item.Name(), " ", item.Charges(), " ", item.Expendable())
                        log.Info(key.." # "..c.." "..item.ItemLink("CLICKABLE")().." effect: "..item.Clicky.Spell.Name())
                    end
                end
            else
                if inv.Clicky() ~= nil and not inv.Expendable() then
                    --print ( "four ", inv.Name(), " ", inv.Charges(), " ", inv.Expendable())
                    log.Info(key.." "..inv.ItemLink("CLICKABLE")().." effect: "..inv.Clicky.Spell.Name())
                end
            end
        end
    end
end

---@param command ListClickesCommand
local function execute(command)
    list_my_clickies(command.Category)
end

-- reports all owned clickies (worn, inventory, bank) worn auguments
local function createCommand(category)
    commandQueue.Enqueue(function() execute({Category = category}) end)
end

bind("/listclickies", createCommand)
