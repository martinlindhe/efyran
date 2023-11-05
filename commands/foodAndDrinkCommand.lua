local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local merchant = require("lib/looting/merchant")

local bci = broadCastInterfaceFactory()

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

-- Returns the item and count, or nil
---@return item|nil
---@return integer
local function findBestFoodOrDrink(tbl)
    for _, v in pairs(tbl) do
        local item = find_item("="..v)
        if item ~= nil then
            return item, inventory_item_count(v)
        end
    end
    return nil, 0
end

-- food + drink check
local function reportFoodAndDrink()
     local foundFood = "[+r+]NONE[+x+]"
     local foundDrink = "[+r+]NONE[+x+]"

     local food, foodCount = findBestFoodOrDrink(foods)
     if food ~= nil then
        foundFood = string.format("%s (%d)", food.ItemLink("CLICKABLE")(), foodCount)
     end

     local drink, drinkCount = findBestFoodOrDrink(drinks)
     if drink ~= nil then
        foundDrink = string.format("%s (%d)", drink.ItemLink("CLICKABLE")(), drinkCount)
     end

     all_tellf("Food: %s, Drink: %s", foundFood, foundDrink)
end

-- Searches merchant listing for any of the given items
---@param items string[]
---@return string|nil
---@return integer|nil
local function findFoodOrDrinkItemOnOpenMerchant(items)
    local merchantWnd = mq.TLO.Window("MerchantWnd")
    if merchantWnd() ~= nil then
        for _, itemName in pairs(items) do
            local listPosition = merchantWnd.Child("ItemList").List("="..itemName, 2)()
            if listPosition ~= nil then
                --log.Debug("item %s, pos %d", itemName, listPosition)
                return itemName, listPosition
            end
        end
    end
    return nil, nil
end


-- assumes the item to buy is stackable (eg. all food/drink)
---@param category string eg. "food"
---@param supplies string[]
---@param purchaseCap integer the desired amount of items to have
local function restockSupply(category, supplies, purchaseCap)
    if purchaseCap < 0 then
        return
    end

    local itemName, listPosition = findFoodOrDrinkItemOnOpenMerchant(supplies)
    if itemName == nil then
        log.Info("No %s supply found on vendor (needed %d)...", category, purchaseCap)
        return
    end

    log.Info("Restock %s (buying %d, have %d) ...", itemName, purchaseCap, inventory_item_count(itemName))

    mq.cmdf("/notify MerchantWnd ItemList listselect %d", listPosition)
    mq.delay(50, function() return mq.TLO.Window("MerchantWnd").Child("MW_SelectedItemLabel").Text() == itemName end)

    -- XXX check that we have enough money for purchase
    -- XXX check for inventory full

    if have_cursor_item() then
        all_tellf("I have item on cursor, aborting!")
        return
    end

    while true do

        clear_cursor()
        if mq.TLO.Merchant() == "FALSE" then
            log.Debug("restockSupply: merchant lost, aborting")
            break
        end
        if mq.TLO.Me.FreeInventory() < 1 then
            all_tellf("restockSupply: OUT OF INVENTORY SPACE, aborting")
            break
        end

        local currentCount = inventory_item_count(itemName)
        local numToBuyRemaining = purchaseCap - currentCount

        if numToBuyRemaining <= 0 then
            log.Info("finished buying %s", itemName)
            break
        end

        local lastItemCount = inventory_item_count("="..itemName)
        log.Info("buying remaining %d, stack size %d", numToBuyRemaining, mq.TLO.Merchant.Item("="..itemName).StackSize() )

        log.Info("Buying %s (x %d)", itemName, numToBuyRemaining)
        mq.cmdf("/buyitem %d", numToBuyRemaining)
        mq.delay(300)

    end
end

-- try to restock food + drink from nearby merchant
local function restockFoodAndDrink()
    clear_cursor(true)

    local foodSupplyCap = 60
    local drinkSupplyCap = 120

    local nearestMerchant = merchant.FindMerchant()
    if not nearestMerchant then
        log.Debug("Unable to find any merchants nearby")
        return
    end

    local merchantName = nearestMerchant.CleanName()
    if not move_to(nearestMerchant.ID()) then
        log.Debug("Unable to reach merchant <%s>", merchantName)
        return
    end

    if merchant.OpenMerchant(nearestMerchant) then
        restockSupply("food", foods, foodSupplyCap)

        restockSupply("drink", drinks, drinkSupplyCap)

        merchant.CloseMerchant()
    end
end

bind("/food", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/food")
    end
    commandQueue.Enqueue(function() reportFoodAndDrink() end)
end)

bind("/restock", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/restock")
    end
    commandQueue.Enqueue(function() restockFoodAndDrink() end)
end)
