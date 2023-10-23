local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

-- food + drink check
local function execute()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/food")
     end

     local foods = {
         -- food duration: select NAME,id,casttime_ from items where itemtype=14 ORDER BY casttime_ desc
         "Bristlebanes Party Platter",   -- 120: baking (PoP)
         "Misty Thicket Picnic",         -- 120: baking (Original)
         "Rye of Eternity",              -- 90: forage (PoP)
         "Halas 10lb Meat Pie",          -- 80: baking (Original)
         "Deep Cavern Toadstool",        -- 60: vendor (Kunark)
         "Fish Rolls",                   -- 35: baking (Original)
         "Patty Melt",                   -- 35: baking (Luclin)
         "Iron Ration",                  -- 25: vendor
         "Ration",                       -- 15: vendor
     }
     local drinks = {
         -- drink duration: select NAME,id,casttime_ from items where itemtype=15 ORDER BY casttime_ desc
         "Kaladim Constitutional",       -- 120: brewing (Luclin)
         "Water of Eternity",            -- 90: forage (PoP)
         "Fuzzlecutter Formula 5000",    -- 60: vendor
         "Water Flask",                  -- 15: vendor
     }

     local foundFood = "[+r+]NONE[+x+]"
     for _, v in pairs(foods) do
         local item = find_item("="..v)
         if item ~= nil then
             foundFood = string.format("%s (%d)", item.ItemLink("CLICKABLE")(), inventory_item_count(v))
             break
         end
     end

     local foundDrink = "[+r+]NONE[+x+]"
     for _, v in pairs(drinks) do
         local item = find_item("="..v)
         if item ~= nil then
             foundDrink = string.format("%s (%d)", item.ItemLink("CLICKABLE")(), inventory_item_count(v))
             break
         end
     end

     all_tellf("Food: %s, Drink: %s", foundFood, foundDrink)
end

local function createCommand(distance)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/food")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/food", createCommand)
