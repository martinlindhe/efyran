local mq = require 'mq'
local log = require("knightlinc/Write")
local broadcast = require 'broadcast/broadcast'
local repository = require 'looting/repository'

---@param itemId integer
---@param itemName string
---@return boolean, LootItem
local function canDestroyItem(itemId, itemName)
    local itemToDestroy = repository:tryGet(itemId)
    if not itemToDestroy then
      itemToDestroy = { Id = itemId, Name = itemName, DoSell = false, DoDestroy = false }
    end

    return itemToDestroy.DoDestroy, itemToDestroy
  end

local function markItemForDestroying()
    local cursor = mq.TLO.Cursor
    if not cursor() then
      log.Debug("No item to mark for destroying on cursor")
      return
    end

    local itemId = cursor.ID()
    local shouldDestroy, item = canDestroyItem(itemId, cursor.Name())
    if shouldDestroy then
      log.Debug("Item already marked for destroying")
    end

    item.DoDestroy = true
    repository:upsert(item)
    log.Info("Marked <%d:%s> for destroying", item.Id, item.Name)
    broadcast.Success({}, "Marked <%d:%s> for destroying", item.Id, item.Name)
  end

  local function createAliases()
    mq.unbind('/setdestroyitem')
    mq.bind("/setdestroyitem", markItemForDestroying)
  end

  createAliases()
