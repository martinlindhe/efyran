local mq = require("mq")
local commandQueue = require("lib/CommandQueue")
local log = require("knightlinc/Write")

local tradeskillsIni = efyranConfigDir() .. "\\" .. current_server() .. "__Tradeskills.ini"


-- Identifies a tradeskill category from inventory that we want to trade
---@return string|nil itemType
---@return string|nil reciever
local function findItemType()
    for bag = 1, mq.TLO.Me.NumBagSlots() do
        local pack = string.format("pack%d", bag)
        if mq.TLO.InvSlot(pack).Item.Container() then
            if not window_open(pack) then
                cmdf("/nomodkey /ctrlkey /itemnotify %s rightmouseup", pack)
            end
            mq.delay(1000, function() return mq.TLO.Window(pack).Open() end)

            for Slot = 1, mq.TLO.InvSlot(pack).Item.Container() do
                local item = mq.TLO.InvSlot(pack).Item.Item(Slot)
                if item.ID() and not item.NoDrop() then
                    local skip = false
                    if (is_enc() and item.Name() == "Peridot") or (is_clr() and item.Name() == "Peridot") then
                        skip = true
                    end
                    if not skip then
                        local itemType = mq.TLO.Ini(tradeskillsIni, "Items", item.Name(), "-")()
                        local reciever = mq.TLO.Ini(tradeskillsIni, "Roles", itemType, "-")()
                        --log.Debug("itemType %s to reciever %s", itemType, reciever)
                        if itemType ~= "-" and mq.TLO.Me.Name() ~= reciever then
                            if spawn_count("pc "..reciever.." radius 100") == 0 then
                                log.Error("Reciever %s not in zone: %s", reciever, itemType)
                                return nil
                            end
                            return itemType, reciever
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function handOverComponents(itemType, reciever)

    log.Info("Handing over all %s components to %s ...", itemType, reciever)

    local recvSpawn = spawn_from_query("pc ="..reciever)
    if recvSpawn == nil or recvSpawn() == nil or recvSpawn.Distance() > 25 then
        all_tellf("ERROR: reciever %s is out of range", reciever)
        cmd("/beep 1")
        return
    end

    local count = 0
    for bag = 1, mq.TLO.Me.NumBagSlots() do
        local pack = string.format("pack%d", bag)
        if mq.TLO.InvSlot(pack).Item.Container() then
            if not window_open(pack) then
                cmdf("/nomodkey /ctrlkey /itemnotify %s rightmouseup", pack)
                mq.delay(1000, function() return window_open(pack) end)
            end

            for slot = 1, mq.TLO.InvSlot(pack).Item.Container() do
                local item = mq.TLO.InvSlot(pack).Item.Item(slot)

                if item.ID() and not item.NoDrop() then
                    local currentItemType = mq.TLO.Ini(tradeskillsIni, "Items", item.Name(), "-")()
                    if currentItemType == itemType then

                        local skip = false
                        if (is_enc() and item.Name() == "Peridot") or (is_clr() and item.Name() == "Peridot") then
                            skip = true
                        end
                        if not skip then
                            count = count + 1
                            log.Info("Handing over #%d %s: %s", count, currentItemType, item.Name())

                            cmdf("/nomodkey /shiftkey /itemnotify in %s %d leftmouseup", pack, slot)
                            delay(2000, function() return mq.TLO.Cursor.ID() ~= nil end)

                            while true do
                                target_id(recvSpawn.ID())
                                cmd("/click left target")
                                mq.delay(2000, function() return window_open("TradeWnd") end)

                                if window_open("TradeWnd") then
                                    break
                                end
                                log.Error("Failed to open trade with %s, retrying ...", reciever)
                                delay(2000)
                            end

                            if count >= 8 then
                                log.Info("Handing over full set of %d items", count)
                                cmd("/notify TradeWnd TRDW_Trade_Button leftmouseup")
                                delay(10)
                                cmdf("/bct %s //notify TradeWnd TRDW_Trade_Button leftmouseup", reciever)
                                count = 0
                                mq.delay(5000, function() return not window_open("TradeWnd") end)
                                delay(2000)
                            end
                        end
                    end
                end
            end
        end
    end

    if count > 0 then
        log.Info("Handing over final %d items", count)
        cmd("/notify TradeWnd TRDW_Trade_Button leftmouseup")
        mq.delay(5)
        cmdf("/bct %s //notify TradeWnd TRDW_Trade_Button leftmouseup", reciever)
        mq.delay(5000, function() return not window_open("TradeWnd") end)
    end
    if window_open("TradeWnd") then
        cmd("/beep")
        all_tellf("ERROR: trade window still open with %s", reciever)
    end
end

local function execute()
    log.Info("Autosorting loot ...")

    local itemKind, reciever = findItemType()
    if itemKind == nil then
        log.Info("No item kind found!")
        return
    end

    move_to_peer(reciever)
    handOverComponents(itemKind, reciever)
end

-- auto banks items from SERVER__Tradeskills.ini
local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/autosort", createCommand)
