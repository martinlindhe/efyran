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

-- reads settings/tradeskills.ini and auto banks all the stuff you should have
local function autobank()
    bankFull = false
    if not open_banker() then
        return
    end

    clear_cursor()

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

                                    -- TODO: check free bank slots and give up when bank is full

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

local function execute()
    autobank()
end

-- auto banks items from tradeskills.ini
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/autobank", createCommand)

mq.bind("/bankall", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/autobank")
    end
    cmd("/autobank")
end)
