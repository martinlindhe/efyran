local mq = require("mq")
local log = require("knightlinc/Write")
local broadcast = require("broadcast/broadcast")
local repository = require("lib/looting/repository")
local loot = require("lib/looting/Loot")

---@param itemId integer
---@param itemName string
---@return boolean, LootItem
local function canDestroyItem(itemId, itemName)
    local itemToDestroy = repository:tryGet(itemId)
    if not itemToDestroy then
        itemToDestroy = { Id = itemId, Name = itemName, Sell = false, Destroy = false }
    end

    return itemToDestroy.Destroy, itemToDestroy
end

local function markItemForDestroying()
    local cursor = mq.TLO.Cursor
    if not cursor() then
        log.Error("No item to mark for destroying on cursor")
        return
    end

    local itemId = cursor.ID()
    local shouldDestroy, item = canDestroyItem(itemId, cursor.Name())
    if shouldDestroy then
        log.Debug("Item already marked for destroying")
    end

    item.Destroy = true
    repository:upsert(item)
    log.Info("Marked %s for destroying", cursor.ItemLink("CLICKABLE")())
    --broadcast.Success({}, "Marked %s for destroying", cursor.ItemLink("CLICKABLE")())

    loot.DestroyCursorItem()
end

mq.bind("/setdestroyitem", markItemForDestroying)
