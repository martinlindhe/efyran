--- @type Mq
local mq = require 'mq'
local logger = require("knightlinc/Write")
local timer = require("Timer")
local bard = require("lib/classes/Bard")
local merchant = require("lib/looting/merchant")
local repository = require("lib/looting/repository")
require("ezmq")

---@param itemId integer
---@param itemName string
---@return boolean, LootItem
local function canSellItem(itemId, itemName)
    local itemToSell = repository:tryGet(itemId)
    if not itemToSell then
        itemToSell = { Id = itemId, Name = itemName, DoSell = false, DoDestroy = false }
    end

    return itemToSell.DoSell, itemToSell
end

---@param itemToSell item
local function sellItem(itemToSell)
    if not itemToSell() then
        return
    end

    local shouldSell, _ =  canSellItem(itemToSell.ID(), itemToSell.Name())
    if not shouldSell then
        logger.Info("%s has not listed for selling, skipping.", itemToSell.Name())
        return
    end

    if itemToSell.Value() <= 0 then
        logger.Info("%s has no value, skipping.", itemToSell.Name())
        return
    end

    local retryTimer = timer.new(3)
    local merchantWindow = mq.TLO.Window("MerchantWnd")

    local packslot = itemToSell.ItemSlot() - 22
    while merchantWindow.Child("MW_SelectedItemLabel").Text() ~= itemToSell.Name() do
        if(itemToSell.ItemSlot2() >= 0) then
        mq.cmdf("/nomodkey /itemnotify in pack%d %d leftmouseup", packslot, itemToSell.ItemSlot2() + 1)
        else
        mq.cmdf("/nomodkey /itemnotify pack%d leftmouseup", packslot)
        end

        mq.delay(retryTimer:TimeRemaining(), function() return merchantWindow.Child("MW_SelectedItemLabel").Text() == itemToSell.Name() end)

        if retryTimer:expired() then
        logger.Error("Failed to select [%s], skipping.", itemToSell.Name())
        return
        end
    end

    mq.delay("1s", function() return merchantWindow.Child("MW_Sell_Button").Enabled() end)
    mq.cmd("/notify MerchantWnd MW_Sell_Button leftmouseup")

    local quantityWindow = mq.TLO.Window("QuantityWnd")
    mq.delay(30, function() return quantityWindow() and merchantWindow.Open() end)
    if(quantityWindow() and quantityWindow.Open()) then
        mq.cmd("/notify QuantityWnd QTYW_Accept_Button leftmouseup")
        mq.delay(30, function() return not quantityWindow() or not quantityWindow.Open() end)
    end

    if(itemToSell.ItemSlot2() >= 0 and mq.TLO.Me.Inventory("pack"..packslot).Item(itemToSell.ItemSlot).Item())
        or mq.TLO.Me.Inventory("pack"..packslot).Item() then
        logger.Error("Failed to sell [%s], skipping.", itemToSell.Name())
    end
end

local function sellItems()
    bard.pauseMelody()
    local startX = mq.TLO.Me.X()
    local startY = mq.TLO.Me.Y()
    local startZ = mq.TLO.Me.Z()

    local nearestMerchant = merchant.FindMerchant()
    if not nearestMerchant then
        logger.Debug("Unable to find any merchants nearby")
        return
    end

    local merchantName= nearestMerchant.CleanName()
    if not move_to(nearestMerchant.ID()) then
        logger.Debug("Unable to reach merchant <%s>", merchantName)
        return
    end

    if merchant.OpenMerchant(nearestMerchant --[[@as spawn]]) then
        local maxInventory = 23 + mq.TLO.Me.NumBagSlots() - 1
        for i=23,maxInventory,1 do
        local inventoryItem = mq.TLO.Me.Inventory(i)
        if inventoryItem() then
            if inventoryItem.Container() > 0 then
            for p=1,inventoryItem.Container() do
                sellItem(inventoryItem.Item(p))
            end
            else
            sellItem(inventoryItem --[[@as item]])
            end
        end
        end

        merchant.CloseMerchant(nearestMerchant --[[@as spawn]])
    end

    bard.resumeMelody()
    move_to_loc(startY, startX, startZ)
    logger.Info("Completed selling items to [%s].", merchantName)
end

return sellItems
