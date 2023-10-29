local mq = require 'mq'
local log = require("knightlinc/Write")
local repository = require("lib/looting/repository")

local function markItemForSelling()
    local cursor = mq.TLO.Cursor
    if not cursor() then
        log.Error("No item to mark for selling on cursor")
        return
    end

    local lootItem = repository:get(cursor)
    if lootItem ~= nil and lootItem.Sell then
        log.Debug("Item %s already marked for selling", cursor.ItemLink("CLICKABLE")())
    end

    if lootItem ~= nil then
        lootItem.Sell = true
        lootItem.Keep = false
        lootItem.Destroy = false
    else
        lootItem = { ID = cursor.ID(), Name = cursor.Name(), Sell = true, Destroy = false }
    end

    repository:set(lootItem)
    log.Info("Marked %s for selling", cursor.ItemLink("CLICKABLE")())
end

mq.bind("/setsellitem", markItemForSelling)
