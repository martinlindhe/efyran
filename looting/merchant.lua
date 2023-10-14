--- @type Mq
local mq = require 'mq'
local log = require("knightlinc/Write")
local timer = require 'timer'

local function ensureTarget(targetId)
    if not targetId then
        log.Debug("Invalid <targetId>")
      return false
    end

    if mq.TLO.Target.ID() ~= targetId then
      if mq.TLO.SpawnCount("id "..targetId)() > 0 then
        mq.cmdf("/mqtarget id %s", targetId)
        mq.delay("3s", function() return mq.TLO.Target.ID() == targetId end)
      else
        log.Warn("EnsureTarget has no spawncount for target id <%d>", targetId)
      end
    end

    return mq.TLO.Target.ID() == targetId
  end

local function findMerchant()
  local merchantSpawn = mq.TLO.NearestSpawn("Merchant radius 100")
  local nav = mq.TLO.Navigation

  if not merchantSpawn() or not nav.PathExists("id "..merchantSpawn.ID()) then
    log.Warn("There are no merchants nearby!")
    return false
  end

  if ensureTarget(merchantSpawn.ID()) then
    return not mq.TLO.Target.Aggressive()
  end

  return false
end

---@param target spawn
---@return boolean
local function openMerchant(target)
  local merchantWindow = mq.TLO.Window("MerchantWnd")
  local openMerchantTimer = timer.new(10)

  if not merchantWindow.Open() then
    mq.cmd("/click right target")
    mq.delay("5s", function ()
      return merchantWindow.Open() or openMerchantTimer:expired()
    end)
  end

  if not merchantWindow.Open() then
    log.Warn("Failed to open trade with [%s].", target.CleanName())
    return false
  end

  mq.delay("5s", function ()
    return (merchantWindow.Child("ItemList") and merchantWindow.Child("ItemList").Items() > 0) or openMerchantTimer:expired()
  end)

  return merchantWindow.Child("ItemList").Items() > 0
end

---@param target spawn
---@return boolean
local function closeMerchant(target)
  local merchantWindow = mq.TLO.Window("MerchantWnd")
  local closeMerchantTimer = timer.new(5)
  while merchantWindow.Open() and not closeMerchantTimer:expired() do
    mq.cmd("/notify MerchantWnd MW_Done_Button leftmouseup")
    mq.delay(10)
  end

  if merchantWindow.Open() then
    log.Warn("Failed to close trade with [%s].", target.CleanName())
    return false
  end

  return true
end

local merchant = {
  FindMerchant = findMerchant,
  OpenMerchant = openMerchant,
  CloseMerchant = closeMerchant,
}

return merchant
