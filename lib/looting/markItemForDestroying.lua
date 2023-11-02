local mq = require("mq")
local log = require("knightlinc/Write")
local repository = require("lib/looting/repository")

local function markItemForDestroying(force)
    local cursor = mq.TLO.Cursor
    if not cursor() then
        log.Error("No item to mark for destroying on cursor")
        return
    end

    local lootItem = repository:get(cursor)
    if lootItem ~= nil and lootItem.Destroy then
        log.Debug("Item %s already marked for destroying", cursor.ItemLink("CLICKABLE")())
    end

    if cursor.NoDrop() and force ~= "force" then
        all_tellf("ERROR: cant mark NO-DROP item for destroy. use '/setdestroyitem force' to force marking this item for deleting")
        cmd("/beep")
        return
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
