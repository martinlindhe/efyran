local mq = require 'mq'
local log = require("knightlinc/Write")
local broadcast = require 'broadcast/broadcast'
local timer = require 'Timer'
local repository = require 'looting/repository'
local bard = require 'Class_Bard'
local target = require 'target'
require("ezmq")

local function typeChrs(message, ...)
  -- https://stackoverflow.com/questions/829063/how-to-iterate-individual-characters-in-lua-string
  local str = string.format(message, ...)
  for c in str:gmatch"." do
    if c == " " then
      mq.cmd("/nomodkey /keypress space chat")
    else
      mq.cmdf("/nomodkey /keypress %s chat", c)
    end
  end
end

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

local function alreadyHaveLoreItem(item)
  if not item.Lore() then
    return false
  end

  local findQuery = "="..item.Name()
  return mq.TLO.FindItemCount(findQuery)() > 0 or mq.TLO.FindItemBankCount(findQuery)() > 0
end

---@param item item
---@return boolean
local function canLootItem(item)
  if item.NoDrop() then
    log.Debug("<%s> is [NO DROP], skipping.", item.Name())
    mq.cmd("/beep")
    return false
  end

  if alreadyHaveLoreItem(item) then
    log.Debug("<%s> is [Lore] and I already have one.", item.Name())
    mq.cmd("/beep")
    return false
  end

  if  mq.TLO.Me.FreeInventory() < 1 then
    if item.Stackable() and item.FreeStack() > 0 then
      return true
    end

    log.Debug("My inventory is full!", item.Name())
    mq.cmd("/beep")
    return false
  end

  return true
end

local function lootItem(slotNum)
  if mq.TLO.Me.FreeInventory() <= 0 then
    all_tellf("Cannot loot! No free inventory slots")
    return
  end
  local lootTimer = timer.new(3)
  local cursor = mq.TLO.Cursor

  while not cursor() and not cursor.ID() and not lootTimer:expired() do
    mq.cmdf("/nomodkey /itemnotify loot%d leftmouseup", slotNum)
    mq.delay("1s", function() return cursor() ~= nil end)
  end

  if mq.TLO.Window("ConfirmationDialogBox").Open() then
    mq.cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
  elseif mq.TLO.Window("QuantityWnd").Open() then
    mq.cmd("/notify QuantityWnd QTYW_Accept_Button leftmouseup")
  end

  local itemId = cursor.ID()
  if not itemId then
    log.Debug("Unable to loot item in slotnumber <%d>", slotNum)
    return
  end

  local shouldDestroy, item = canDestroyItem(itemId, cursor.Name())
  if shouldDestroy then
    while cursor() ~= nil and not lootTimer:expired() do
      mq.cmdf("/destroy")
      mq.delay(100, function() return cursor() == nil end)
      if cursor() == nil then
        broadcast.Success("Destroyed %s from slot# %s", item.Name, slotNum)
      else
        broadcast.Fail("Destroying %s from slot# %s", item.Name, slotNum)
      end
    end
  else
    clear_cursor()
    broadcast.Success("Looted %s from slot# %s", item.Name, slotNum)
  end
end

local function lootCorpse()
  local target = mq.TLO.Target
  if not target() or target.Type() ~= "Corpse" then
    broadcast.Fail({}, "No corpse on target.")
    return
  end

  clear_cursor()
  mq.cmd("/loot")
  local corpse = mq.TLO.Corpse
  mq.delay("1s", function() return corpse.Open() and corpse.Items() > 0 end)
  if not corpse.Open() then
    broadcast.Fail({}, "Unable to open corpse for looting.")
    return
  end

  if corpse.Items() > 0 then
    log.Debug("Looting <%s> with # of items: %d", mq.TLO.Target.Name(), corpse.Items())
    for i=1,corpse.Items() do
      local itemToLoot = corpse.Item(i) --[[@as item]]
      log.Debug("Looting %s from slot %d of %d", itemToLoot.Name(), i, corpse.Items())

      if canLootItem(itemToLoot) then
        lootItem(i)
        mq.delay(10)
      end
      log.Debug("Done looting slot <%d>", i)
    end
  end

  if corpse.Items() > 0 then
    mq.cmd("/keypress /")
    mq.delay(10)
    typeChrs("say %s %d", mq.TLO.Target.Name(), mq.TLO.Target.ID())
    mq.delay(10)
    mq.cmd("/notify LootWnd BroadcastButton leftmouseup")
    mq.delay(10)
    mq.cmd("/keypress enter chat")
    mq.delay(10)
  end

  if mq.TLO.Corpse.Open() then
    mq.cmd("/notify LootWnd DoneButton leftmouseup")
    mq.delay("1s", function() return not mq.TLO.Window("LootWnd").Open() end)
  end

  broadcast.Success({}, "Ending loot on <%s>, # of items left: %d", mq.TLO.Target.Name(), corpse.Items() or 0)
end

local function lootNearestCorpse()
  local startX = mq.TLO.Me.X()
  local startY = mq.TLO.Me.Y()
  local startZ = mq.TLO.Me.Z()
  bard.pauseMelody()

  if not mq.TLO.Me.Casting.ID() then
    local seekRadius = 100
    local searchCorpseString = string.format("npc corpse zradius 50 radius %s", seekRadius)
    local closestCorpse = mq.TLO.NearestSpawn(1, searchCorpseString)
    if closestCorpse() and target.EnsureTarget(closestCorpse.ID()) then
      if closestCorpse.Distance() > 16 and closestCorpse.DistanceZ() < 80 then
        move_to(closestCorpse.ID())
      end

      if closestCorpse() and closestCorpse.Distance() <= 20 and closestCorpse.DistanceZ() < 40 and target.EnsureTarget(closestCorpse.ID()) then
        lootCorpse()
      else
        log.Info("Corpse %s is %d|%d distance, skipping", closestCorpse.Name(), closestCorpse.Distance(), closestCorpse.DistanceZ())
      end
    else
      log.Info("Unable to locate or target corpse id <%s>", closestCorpse.ID())
    end

  else
    log.Info("Unable to loot corpse, currently casting.")
  end

  bard.resumeMelody()
  move_to_loc(startY, startX, startZ)
end

return lootNearestCorpse
