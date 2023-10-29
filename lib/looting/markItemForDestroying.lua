local mq = require("mq")
local log = require("knightlinc/Write")
local repository = require("lib/looting/repository")

local function markItemForDestroying()
    local cursor = mq.TLO.Cursor
    if not cursor() then
        log.Error("No item to mark for destroying on cursor")
        return
    end

    local lootItem = repository:get(cursor)
    if lootItem ~= nil and lootItem.Destroy then
        log.Debug("Item %s already marked for destroying", cursor.ItemLink("CLICKABLE")())
    end

    if lootItem ~= nil then
        lootItem.Keep = false
        lootItem.Sell = false
        lootItem.Destroy = true
    else
        lootItem = { ID = cursor.ID(), Name = cursor.Name(), Sell = false, Destroy = true }
    end

    repository:set(lootItem)
    log.Info("Marked %s for destroying", cursor.ItemLink("CLICKABLE")())

    --loot.DestroyCursorItem()
end

mq.bind("/setdestroyitem", markItemForDestroying)
