local mq = require("mq")
local log = require("efyran/knightlinc/Write")
require("efyran/ezmq")

local inventorySlots = 10
local bankerQuery = "npc radius 100 banker"

local tradeskillsIni = mq.TLO.Lua.Dir() .. "/efyran/settings/tradeskills.ini"

-- reads tradeskills.ini and auto banks all the stuff you should have
function autobank()

    if not window_open("BigBankWnd") then
        if spawn_count(bankerQuery) == 0 then
            -- TODO 2: request random bot to spawn a banker, using efyran "summonbanker"
            log.Error("no banker nearby! Giving up!")
        end
        log.Info("Opening nearby banker ...")

        cmdf("/target id %d", mq.TLO.Spawn(bankerQuery).ID())
        move_to(mq.TLO.Spawn(bankerQuery).ID())
        delay(250)

        cmd("/click right target")
        delay(250)
    end

    if not window_open("BigBankWnd") then
        log.Error("Banker not open! Giving up!")
        return
    end


    clear_cursor()


    local depositCount = 0

    --- loop thru inventory items, see if item is listed in tradeskills.ini
    for i = 23, 32 do -- equipment: 23-32 is inventory top level (10 slots)
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
                                local reciever = mq.TLO.Ini(tradeskillsIni, "Roles", itemType,"-")()

                                if mq.TLO.Me.Name() == reciever then

                                    -- TODO: check free bank slots and give up when bank is full

                                    depositCount = depositCount + 1
                                    all_tellf("Banking #%d %s: %s", depositCount, itemType, item.ItemLink("CLICKABLE")())

                                    cmdf("/nomodkey /shiftkey /itemnotify in pack%d %d leftmouseup", item.ItemSlot()-22, item.ItemSlot2() + 1)

                                    delay("1s", function ()
                                        if has_cursor_item() then
                                            return true
                                        end
                                    end)
                                    delay(3)

                                    if not has_cursor_item() then
                                        all_tellf("ERROR cursor is empty")
                                        return
                                    end

                                    -- click auto inventory button in bank window
                                    repeat
                                        cmd("/notify BigBankWnd BIGB_AutoButton leftmouseup")
                                        delay(1)
                                        if has_cursor_item() then
                                            all_tellf("Failed to auto bank %s, retrying ...", item.Name())
                                            delay("1s")
                                        end
                                    until not has_cursor_item()

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

    close_window("BigBankWnd", "DoneButton")

end