local mq = require("mq")
local log = require("knightlinc/Write")
local broadcast = require("broadcast/broadcast")
local timer = require("lib/Timer")
local repository = require("lib/looting/repository")
local bard = require("lib/classes/Bard")
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
        itemToDestroy = { Id = itemId, Name = itemName, Sell = false, Destroy = false }
    end

    return itemToDestroy.Destroy, itemToDestroy
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
    if item() == nil or item == nil then
        all_tellf("UNLIKELY: canLootItem item poofed")
        return false
    end
    if item.NoDrop() then
        all_tellf("%s is [NO DROP], skipping.", item.ItemLink("CLICKABLE")())
        mq.cmd("/beep 1")
        return false
    end

    if alreadyHaveLoreItem(item) then
        all_tellf("%s is [LORE] and I already have one.", item.ItemLink("CLICKABLE")())
        return false
    end

    if mq.TLO.Me.FreeInventory() < 1 then
        if item.Stackable() and item.FreeStack() > 0 then
            return true
        end
        return false
    end

    return true
end

local function destroyCursorItem()
    local cursor = mq.TLO.Cursor
    if cursor() == nil then
        return
    end
    local id = cursor.ID()
    local itemLink = cursor.ItemLink("CLICKABLE")()

    while cursor() ~= nil do
        if cursor.ID() ~= id then
            local newID = cursor.ID()
            all_tellf("WARNING: destroyCursorItem aborted. item id to destroy changed from %d to %s", id, tostring(newID))
            break
        end
        if cursor.NoDrop() then
            all_tellf("ERROR: cant mark NO-DROP item for destroy. TODO add a 'force' argument")
            cmd("/beep")
            return
        end
        mq.cmdf("/destroy")
        mq.delay(200, function() return cursor() == nil end)
        if cursor() == nil then
            broadcast.Success({}, "Destroyed %s", itemLink)
        else
            broadcast.Fail({}, "Destroying %s", itemLink)
        end
    end
end

-- Loot item from currently opened corpse and autodestroy or autoinventory
local function lootItem(slotNum)
    local lootTimer = timer.new(3)
    local cursor = mq.TLO.Cursor

    while not cursor() and not cursor.ID() and not lootTimer:expired() do
        mq.cmdf("/nomodkey /itemnotify loot%d leftmouseup", slotNum)
        mq.delay("1s", function() return cursor() ~= nil end)
    end

    mq.delay(50)

    if window_open("ConfirmationDialogBox") then
        mq.cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
    elseif window_open("QuantityWnd") then
        mq.cmd("/notify QuantityWnd QTYW_Accept_Button leftmouseup")
    end

    mq.delay(50)

    if not cursor() then
        log.Debug("Unable to loot item in slotnumber %d", slotNum)
        return
    end

    local itemLink = cursor.ItemLink("CLICKABLE")()

    local shouldDestroy, item = canDestroyItem(cursor.ID(), cursor.Name())
    if shouldDestroy then
        log.Debug("Destroying item %s ...", cursor.Name())
        destroyCursorItem()
    else
        log.Info("Looted %s", itemLink)
    end
    clear_cursor(true)
end

-- Returns true on successful loot
---@return boolean
local function lootCorpse()
    local target = mq.TLO.Target
    if not target() or target.Type() ~= "Corpse" then
        broadcast.Fail({}, "No corpse on target.")
        return false
    end
    local name = target.Name()

    clear_cursor()
    mq.cmd("/loot")
    local corpse = mq.TLO.Corpse
    if corpse() == nil or corpse == nil then
        all_tellf("UNLIKELY: corpse poofed while looting (1)")
        return false
    end
    mq.delay("1s", function() return corpse.Open() and corpse.Items() > 0 end)
    if corpse() == nil or corpse == nil then
        all_tellf("UNLIKELY: corpse poofed while looting (2)")
        return false
    end
    if not corpse.Open() then
        log.Debug("Unable to open corpse %d for looting.", corpse.ID())
        return false
    end

    if corpse.Items() > 0 then
        local itemCount = corpse.Items()
        log.Debug("Looting \ay%s\ax with \ay%d\ax items", name, itemCount)
        for i = 1, itemCount do
            if corpse() == nil or corpse == nil then
                all_tellf("UNLIKELY: corpse poofed while looting item %d", i)
                break
            end
            if mq.TLO.Me.FreeInventory() < 1 then
                all_tellf("Cannot loot! No free inventory slots")
                break
            end

            local item = corpse.Item(i) --[[@as item]]
            --log.Debug("Checking corpse item %s (%d/%d)", item.Name(), i, itemCount)

            if (mq.TLO.Me.FreeInventory() < 1 and not item.Stackable())
                or (mq.TLO.Me.FreeInventory() == 0 and item.Stackable() and item.FreeStack() == 0) then
                all_tellf("ERROR: Inventory full! Cannot loot %s", item.ItemLink("CLICKABLE")())
                break
            end

            if canLootItem(item) then
                log.Debug("Looting %s (%d/%d)", item.ItemLink("CLICKABLE")(), i, itemCount)
                lootItem(i)
            end
            --log.Debug("Done looting slot %d", i)
        end
    end

    if corpse() ~= nil and corpse.Items() ~= nil and corpse.Items() > 0 then
        mq.cmd("/keypress /")
        mq.delay(10)
        typeChrs("say %d ", mq.TLO.Target.ID())
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

    local left = corpse.Items() or 0
    if left > 0 then
        broadcast.Success({}, "Ending loot on \ay%s\ax, %d items left", name, corpse.Items() or 0)
    end
    return true
end

-- Returns true if successfully looted a corpse
---@param seekRadius integer
---@return boolean
local function lootNearestCorpse(seekRadius)

    bard.pauseMelody()

    wait_until_not_casting()

    local startX = mq.TLO.Me.X()
    local startY = mq.TLO.Me.Y()
    local startZ = mq.TLO.Me.Z()
    local searchCorpseString = string.format("npccorpse zradius 50 radius %d", seekRadius)
    local corpse = mq.TLO.NearestSpawn(1, searchCorpseString)

    local ok = true
    if corpse() ~= nil then
        if EnsureTarget(corpse.ID()) then
            if corpse.Distance() >= 15 and corpse.DistanceZ() < 80 then
                move_to(corpse.ID())
            end

            if corpse() == nil then
                log.Debug("lootNearestCorpse: giving up, corpse poofed")
                return false
            end
            if corpse.Distance() < 15 and corpse.DistanceZ() < 40 and EnsureTarget(corpse.ID()) then
                if not lootCorpse() then
                    ok = false
                end
            else
                all_tellf("WARN: Corpse %s is %d|%d distance, skipping", corpse.Name(), corpse.Distance(), corpse.DistanceZ())
            end
        else
            all_tellf("WARN: Unable to locate or target corpse id <%s>", corpse.ID())
        end

        bard.resumeMelody(true)
        move_to_loc(startY, startX, startZ)
    end
    return ok
end

return {
    LootNearestCorpse = lootNearestCorpse,
    DestroyCursorItem = destroyCursorItem,
}
