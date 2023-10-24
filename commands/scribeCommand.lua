local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local commandQueue = require("lib/CommandQueue")
local timer = require("lib/Timer")

local bci = broadCastInterfaceFactory()

-- TODO LATER: auto purchase from open spell vendor like scribe.mac did
-- TODO LATER: accept args "/scribe minlevel maxlevel"   for auto-purchase

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

    -- XXX why this code? from scribe.mac ...
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

local function scribeSpells()

    open_bags()
    clear_cursor(true)

    for bag = 1, mq.TLO.Me.NumBagSlots() do
        local pack = string.format("pack%d", bag)
        if mq.TLO.InvSlot(pack).Item() ~= nil and mq.TLO.InvSlot(pack).Item.Container() > 0 then
            --log.Debug("scribeSpells: inventory slot %s is a container", pack)
            for slot = 1, mq.TLO.InvSlot(pack).Item.Container() do
                if mq.TLO.InvSlot(pack).Item.Item(slot).Type() == "Scroll" then
                    if mq.TLO.InvSlot(pack).Item.Item(slot).Spell.Level() > mq.TLO.Me.Level() then
                        log.Warn("Can't scribe %s: required L%d", mq.TLO.InvSlot(pack).Item.Item(slot).ItemLink("CLICKABLE")(), mq.TLO.InvSlot(pack).Item.Item(slot).Spell.Level())
                    elseif mq.TLO.Me.Book(mq.TLO.InvSlot(pack).Item.Item(slot).Spell.Name())() then
                        log.Warn("Already have spell %s scribed. Scroll is in pack %s, slot %d", mq.TLO.InvSlot(pack).Item.Item(slot).Name(), pack, slot)
                    else
                        --log.Info("Scribing spell %s", mq.TLO.InvSlot(pack).Item.Item(slot).Name())

                        -- pick up scroll and scribe it in book
                        mq.cmdf("/nomodkey /ctrlkey /itemnotify in %s %d leftmouseup", pack, slot)
                        mq.delay(1000, function() return mq.TLO.Cursor.ID() ~= nil end)

                        if mq.TLO.Cursor.ID() then
                            doScribe()
                        end
                    end
                end
            end
        else
            --log.Debug("scribeSpells: inventory slot %s is top level", pack)
            if mq.TLO.InvSlot(pack).Item.Type() == "Scroll" then
                if mq.TLO.InvSlot(pack).Item.Spell.Level() > mq.TLO.Me.Level() then
                    log.Warn("Can't scribe %s: required L%d", mq.TLO.InvSlot(pack).ItemLink("CLICKABLE")(), mq.TLO.InvSlot(pack).Item.Spell.Level())
                elseif mq.TLO.Me.Book(mq.TLO.InvSlot(pack).Item.Spell.Name())() then
                    log.Warn("Already have spell %s scribed. Scroll is in top level %s", mq.TLO.InvSlot(pack).Item.Name(), pack)
                else
                    log.Info("Scribing TOP LEVEL spell %s", mq.TLO.InvSlot(pack).Item.Name())

                    -- pick up scroll and scribe it in book
                    mq.cmdf("/nomodkey /ctrlkey /itemnotify %s leftmouseup", pack)
                    mq.delay(1000, function() return mq.TLO.Cursor.ID() ~= nil end)

                    if mq.TLO.Cursor.ID() then
                        doScribe()
                    end
                end
            end
        end
    end

    if window_open("SpellBookWnd") then
        close_window("SpellBookWnd")
    end

    close_bags()
end

local function execute()

    if is_melee() or is_hybrid() then
        log.Info("TODO scribe tomes!!!")
        --/call ScribeTomes
    end

    if is_caster() or is_priest() or is_hybrid() then
        log.Info("Scribing spells !")
        scribeSpells()
    end

    -- TODO 1: list all spells in inventory, see if they are DUPES or TOO HIGH LEVEL
end

local function createCommand(distance)
    commandQueue.Enqueue(function() execute() end)
end

bind("/scribe", createCommand)
