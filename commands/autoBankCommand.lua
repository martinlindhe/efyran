local mq = require("mq")
local log = require("knightlinc/Write")

local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

local commandQueue = require("lib/CommandQueue")
local serverSettings = require("lib/settings/default/ServerSettings")

local tradeskillsIni = efyranConfigDir() .. "\\" .. current_server() .. "__Tradeskills.ini"

local bankFull = false

mq.event("bank-full", "You have no room left in the bank.", function()
    bankFull = true
end)

local function changeCurrenciesAtBanker()
    if serverSettings.bigBank then
        cmd("/notify BigBankWnd BIGB_ChangeButton leftmouseup")
    else
        cmd("/notify BankWnd BW_ChangeButton leftmouseup")
    end
end

-- Returns the number of free slots in the bank,
-- taking no consideration to item size.
local function freeBankSlots()
    return mq.TLO.Inventory.Bank.FreeSlots("Tiny")
end

-- Auto-banks all the stuff you should have according to config/efyran/SERVER_tradeskills.ini
local function autobank()
    bankFull = false
    if not open_banker() then
        return
    end

    clear_cursor()

    -- auto-change currencies while banker is open
    changeCurrenciesAtBanker()

    local depositCount = 0

    local maxInventory = 23 + mq.TLO.Me.NumBagSlots() - 1
    for i = 23, maxInventory do

        if mq.TLO.Me.Inventory(i).ID() then
            local inv = mq.TLO.Me.Inventory(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item() ~= nil and not item.NoDrop() then
                        -- skip sorting some common droppable class reagents
                        if not ((item.Name() == "Peridot" and is_enc()) or (item.Name() == "Emerald" and is_clr())) then
                            --log.Info("container %s item %s", inventory_slot_name(i), item.ItemLink("CLICKABLE")())

                            local itemType = mq.TLO.Ini(tradeskillsIni, "Items", item.Name(), "-")()
                            if itemType ~= "-" then
                                -- make sure I'm not the toon to handle item type
                                local receiver = mq.TLO.Ini(tradeskillsIni, "Roles", itemType,"-")()

                                if mq.TLO.Me.Name() == receiver then
                                    if freeBankSlots() == 0 then
                                        all_tellf("ERROR: Bank is full, cannot auto-bank!")
                                        break
                                    end

                                    depositCount = depositCount + 1
                                    all_tellf("Banking #%d %s: %s", depositCount, itemType, item.ItemLink("CLICKABLE")())

                                    cmdf("/nomodkey /shiftkey /itemnotify in pack%d %d leftmouseup", item.ItemSlot()-22, item.ItemSlot2() + 1)

                                    delay("1s", function ()
                                        if have_cursor_item() then
                                            return true
                                        end
                                    end)
                                    delay(20)

                                    if not have_cursor_item() then
                                        all_tellf("ERROR cursor is empty")
                                        return
                                    end

                                    -- click auto inventory button in bank window
                                    repeat
                                        if serverSettings.bigBank then
                                            cmd("/notify BigBankWnd BIGB_AutoButton leftmouseup")
                                        else
                                            cmd("/notify BankWnd BW_AutoButton leftmouseup")
                                        end
                                        delay(1)

                                        doevents()
                                        if bankFull then
                                            all_tellf("/autobank: Bank is full, aborting !")
                                            close_bank_window()
                                            return
                                        end

                                        if have_cursor_item() then
                                            all_tellf("Failed to auto bank %s, retrying ...", item.Name())
                                            delay("1s")
                                        end
                                    until not have_cursor_item()

                                end
                            end

                        end
                    end
                end
            else
                -- TODO check if we should autobank top-level inventory item
            end
        end
    end

    close_bank_window()
end


-- auto-change currencies
local function autochange()
    if not open_banker() then
        return
    end

    changeCurrenciesAtBanker()

    close_bank_window()
end


bind("/autobank", function()
    commandQueue.Enqueue(function() autobank() end)
end)

mq.bind("/bankall", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/autobank")
    end
    cmd("/autobank")
end)

bind("/autochange", function()
    commandQueue.Enqueue(function() autochange() end)
end)

mq.bind("/changeall", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/autochange")
    end
    cmd("/autochange")
end)
