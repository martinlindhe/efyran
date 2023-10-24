local mq = require 'mq'
local log = require("knightlinc/Write")
local broadcast = require("broadcast/broadcast")
local repository = require("lib/looting/repository")

---@param itemId integer
---@param itemName string
---@return boolean, LootItem
local function canSellItem(itemId, itemName)
    local itemToSell = repository:tryGet(itemId)
    if not itemToSell then
        itemToSell = { Id = itemId, Name = itemName, Sell = false, Destroy = false }
    end

    return itemToSell.Sell, itemToSell
end

local function markItemForSelling()
    local cursor = mq.TLO.Cursor
    if not cursor() then
        log.Error("No item to mark for selling on cursor")
        return
    end

    local itemId = cursor.ID()
    local shouldSell, sellItem = canSellItem(itemId, cursor.Name())
    if shouldSell then
        log.Debug("Item %s already marked for selling", cursor.ItemLink("CLICKABLE")())
    end

    sellItem.Sell = true
    repository:upsert(sellItem)
    log.Info("Marked %s for selling", cursor.ItemLink("CLICKABLE")())
    --broadcast.Success({}, "Marked %s for selling", cursor.ItemLink("CLICKABLE")())
end

mq.bind("/setsellitem", markItemForSelling)
