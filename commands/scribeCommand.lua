local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local commandQueue = require("lib/CommandQueue")
local timer = require("lib/Timer")

local bci = broadCastInterfaceFactory()

-- TODO LATER: accept args "/scribe minlevel maxlevel"   for auto-purchase



-- Scribe the scroll on cursor into book at the first free spot
local function doScribe()

    -- find first available open spellbook slot, minus 1 in case last scribe was an overwrite
    local freeSlot = nil
    for a = 1, 2000 do
        if mq.TLO.Me.Book(a).ID() == nil then
            freeSlot = a
            break
        end
    end
    if freeSlot == nil then
        all_tellf("UNLIKELY: /scribe: no free slot in spell book, giving up!")
        return
    end

    local bookPage = toint(math.ceil(freeSlot / 8))
    local bookSlot = toint(math.ceil(freeSlot % 8))

    -- XXX why this code? from scribe.mac ... some rounding stuff, can be simplified !
    if bookPage % 2 == 0 then
        if bookSlot == 0 then
            bookSlot = 16
        else
            bookSlot = bookSlot + 8
        end
    else
        if bookSlot == 0 then
            bookSlot = 8
        end
    end

    log.Info("Scribing L%d %s to page %d, slot %d", mq.TLO.Cursor.Spell.Level(), mq.TLO.Cursor.ItemLink("CLICKABLE")(), bookPage, bookSlot)

    local timeoutTimer = timer.new(5) -- 5s

    mq.cmdf("/book %d", bookPage)
    mq.delay(2)

    mq.cmdf("/notify SpellBookWnd SBW_Spell%d leftmouseup", bookSlot - 1)

    while true do
        if window_open("ConfirmationDialogBox") and string.find(mq.TLO.Window("ConfirmationDialogBox").Child("CD_TextOutput").Text(), "will replace") ~= nil then
            mq.cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
        end

        mq.delay(2)
        mq.doevents()

        if not mq.TLO.Cursor.ID() then
            --log.Info("doScribe: cursor empty, breaking")
            break
        end
        if timeoutTimer:expired() then
            log.Info("doScribe: timer ended, breaking")
            break
        end
    end

    clear_cursor(true)
end

---@param item item
---@param pack string
---@param slot integer|nil
local function scribeSpell(item, pack, slot)
    if item.Spell.Level() > mq.TLO.Me.Level() then
        log.Warn("Can't scribe %s: required L%d", item.ItemLink("CLICKABLE")(), item.Spell.Level())
    elseif mq.TLO.Me.Book(item.Spell.Name())() then
        log.Warn("Already have spell %s scribed. Scroll is in pack %s, slot %d", item.Name(), pack, slot)
    else
        --log.Info("Scribing spell %s", item.Name())

        -- pick up scroll
        if slot == nil then
            mq.cmdf("/nomodkey /ctrlkey /itemnotify %s leftmouseup", pack)
        else
            mq.cmdf("/nomodkey /ctrlkey /itemnotify in %s %d leftmouseup", pack, slot)
        end
        mq.delay(1000, function() return mq.TLO.Cursor.ID() ~= nil end)

        if mq.TLO.Cursor.ID() then
            doScribe()
        end
    end
end

local function scribeSpells()

    open_bags()
    clear_cursor(true)

    for bag = 1, mq.TLO.Me.NumBagSlots() do
        local pack = string.format("pack%d", bag)
        local topItem = mq.TLO.InvSlot(pack).Item
        if topItem() ~= nil and topItem.Container() > 0 then
            for slot = 1, topItem.Container() do
                local item = topItem.Item(slot)
                if item.Type() == "Scroll" then
                    scribeSpell(item, pack, slot)
                end
            end
        else
            if topItem.Type() == "Scroll" then
                scribeSpell(topItem, pack, nil)
            end
        end
    end

    if window_open("SpellBookWnd") then
        close_window("SpellBookWnd")
    end

    close_bags()
end


-- Returns true if we should buy this spell/tome
---@param item item
---@param maxLevel integer max spell level to purchase
---@return boolean
local function shouldBuySpell(item, maxLevel)

    -- TODO LATER: handle spell ranks in shouldBuySpell(), see scribe.mac

    if item() == nil or item.Type() ~= "Scroll" or have_item(item.Name()) or have_spell(item.Spell.Name()) or have_combat_ability(item.Spell.Name()) then
        return false
    end

    if have_spell(item.Spell.Name()) then
        all_tellf("XXXX I HAVE SPELL in book %s", item.Name())
    end

    if item.Spell.Level() >= 255 then
        log.Error("Skipping %s with level %d", item.ItemLink("CLICKABLE")(), item.Spell.Level())
        return false
    end

    if item.BuyPrice() > mq.TLO.Me.Cash() then
        log.Error("CANNOT AFFORD L%d %s, price %d", item.Spell.Level(), item.ItemLink("CLICKABLE")(), item.BuyPrice())
        return false
    end

    if item.Spell.Level() > maxLevel then
        log.Error("Skipping L%d %s, tpo high level", item.Spell.Level(), item.ItemLink("CLICKABLE")())
        return false
    end

    if not item.CanUse() then
        log.Error("Cannot use %s", item.ItemLink("CLICKABLE")())
        return false
    end

    if item.Deity(1).ID() then
        --    /if (${Merchant.Item[${a}].Deities} && ${MyDeity.NotEqual[${Merchant.Item[${a}].Deity[1]}]}) {
        -- XXX:         if item.Diety(1) == mq.TLO.Me.Deity.ID()
        all_tellf("XXX ERROR item deity %d, my deity %s for %s", item.Deity(1).ID() or 0, mq.TLO.Me.Deity.ID(), item.ItemLink("CLICKABLE")())
        cmd("/beep")
        return false
    end

    return true
end

-- Buy all the spells that I can use and lack from the open merchant
---@param maxLevel integer
local function buySpells(maxLevel)

    mq.delay("5s", function () return mq.TLO.Merchant.ItemsReceived() or not mq.TLO.Merchant.Open() end)

    local purchased = false

    for i = 1, mq.TLO.Merchant.Items() do
        if mq.TLO.Me.FreeInventory() == 0 then
            log.Error("Out of inventory space, giving up")
            return
        end
        if not mq.TLO.Merchant.Open() then
            log.Error("Merchant window closed, giving up")
            return
        end
        local item = mq.TLO.Merchant.Item(i)

        if shouldBuySpell(item, maxLevel) then
            --log.Debug("I should buy %s, price %d", item.ItemLink("CLICKABLE")(), item.BuyPrice())

            -- this loop is needed because the merchant item number doesn't match up to the interface line number when filter/sort order has changed
            local c = 0
            for b = 1, mq.TLO.Merchant.Items() do
                if mq.TLO.Window("MerchantWnd").Child("MW_ItemList").List(b, 2)() == mq.TLO.Merchant.Item(i).Name() then
                    c = b
                end
            end

            -- merchant line number matches what we are looking to buy, buy 1 copy of it
            if c then
                purchased = true
                log.Info("Buying L%d %s", item.Spell.Level(), item.ItemLink("CLICKABLE")())

                cmdf("/notify MerchantWnd MW_ItemList listselect %d", c)
                mq.delay(5)
                cmdf("/nomodkey /ctrlkey /notify MerchantWnd MW_Buy_Button leftmouseup")
                mq.delay("1s")
            else
                all_tellf("UNLIKELY: failed to find %s on merchant", item.ItemLink("CLICKABLE")())
            end
        end
    end

    if purchased then
        -- wait for inventory to be updated from server
        mq.delay("1s")
    end
end


---@class ScribeCommand
---@field MaxLevel integer

---@param command ScribeCommand
local function execute(command)

    local maxLevel = command.MaxLevel
    if maxLevel == 0 then
        maxLevel = mq.TLO.Me.Level()
    end

    if mq.TLO.Merchant.Open() then
        local merchantName = mq.TLO.Window("MerchantWnd").Child("MW_MerchantName").Text()
        log.Info("Auto buying spells up to level %d from \ay%s\ax ...", maxLevel, merchantName)
        buySpells(maxLevel)

        if mq.TLO.Merchant.Open() then
            mq.cmd("/notify MerchantWnd MW_Done_Button leftmouseup")
            mq.delay(10)
        end
    end

    if is_melee() or is_hybrid() then
        log.Error("TODO scribe tomes!!!")
        --/call ScribeTomes
    end

    if is_caster() or is_priest() or is_hybrid() or is_brd() then
        log.Info("Scribing spells in inventory ...")
        scribeSpells()
    end

end

local function createCommand(maxLevel)
    commandQueue.Enqueue(function() execute({MaxLevel = toint(maxLevel)}) end)
end

bind("/scribe", createCommand)
