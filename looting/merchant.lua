--- @type Mq
local mq = require 'mq'
local log = require("knightlinc/Write")
local timer = require 'Timer'

local function findMerchant()
    local merchantSpawn = mq.TLO.NearestSpawn("Merchant radius 100")
    local nav = mq.TLO.Navigation

    if not merchantSpawn() or not nav.PathExists("id "..merchantSpawn.ID()) then
        log.Warn("There are no merchants nearby!")
        return false
    end

    if merchantSpawn.Aggressive() then
        return nil
    end

    return merchantSpawn
end

---@param merchant spawn
---@return boolean
local function openMerchant(merchant)
    local merchantWindow = mq.TLO.Window("MerchantWnd")
    local openMerchantTimer = timer.new(10)

    if EnsureTarget(merchant.ID()) and not merchantWindow.Open() then
        mq.cmd("/click right target")
        mq.delay("5s", function ()
        return merchantWindow.Open() or openMerchantTimer:expired()
        end)
    end

    if not merchantWindow.Open() then
        log.Warn("Failed to open trade with [%s].", merchant.CleanName())
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
