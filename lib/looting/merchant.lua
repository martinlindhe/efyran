--- @type Mq
local mq = require("mq")
local log = require("knightlinc/Write")
local timer = require("lib/Timer")

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

-- Opens merchant window and waits for it to populate.
-- Returns true on success.
---@param merchant spawn
---@return boolean
local function openMerchant(merchant)
    local openMerchantTimer = timer.new(10)

    if EnsureTarget(merchant.ID()) and not mq.TLO.Merchant.Open() then
        mq.cmd("/click right target")
        mq.delay("5s", function ()
        return mq.TLO.Merchant.Open() or openMerchantTimer:expired() end)
    end

    if not mq.TLO.Merchant.Open() then
        log.Warn("Failed to open trade with [%s].", merchant.CleanName())
        return false
    end

    mq.delay("5s", function ()
        return mq.TLO.Merchant.ItemsReceived() or openMerchantTimer:expired()
    end)
    return mq.TLO.Merchant.Open()
end

---@return boolean
local function closeMerchant()
    local closeMerchantTimer = timer.new(5)
    while mq.TLO.Merchant.Open() and not closeMerchantTimer:expired() do
        mq.cmd("/notify MerchantWnd MW_Done_Button leftmouseup")
        mq.delay(10)
    end

    if mq.TLO.Merchant.Open() then
        log.Warn("Failed to close mechant window.")
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
