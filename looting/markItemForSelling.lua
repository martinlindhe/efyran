local mq = require 'mq'
local log = require("knightlinc/Write")
local broadcast = require 'broadcast/broadcast'
local repository = require 'looting/repository'

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


local function markItemForSelling()
    local cursor = mq.TLO.Cursor
    if not cursor() then
        log.Debug("No item to mark for selling on cursor")
      return
    end

    local itemId = cursor.ID()
    local shouldSell, sellItem = canSellItem(itemId, cursor.Name())
    if shouldSell then
        log.Debug("Item already marked for selling")
    end

    sellItem.DoSell = true
    repository:upsert(sellItem)
    log.info("Marked <%d:%s> for destroying", sellItem.Id, sellItem.Name)
    broadcast.Success({}, "Marked <%d:%s> for destroying", sellItem.Id, sellItem.Name)
  end

  local function createAliases()
    mq.unbind('/setsellitem')
    mq.bind("/setsellitem", markItemForSelling)
end

createAliases()
