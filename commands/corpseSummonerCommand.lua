local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local log = require("knightlinc/Write")
local follow  = require("lib/following/Follow")

local bci = broadCastInterfaceFactory()


-- summon corpse using the corpse summoner in guild lobby
local function execute()

    if zone_shortname() ~= "guildlobby" then
        log.Error("Must be in guild lobby, west wing opening to use corpse summoner script")
        return
    end

    follow.Stop()

    if not is_naked() then
        log.Info("Not naked, ignoring corpse summoner")
        return
    end

    if have_corpse_in_zone() then
        log.Info("I have a corpse in zone, not summoning another !")
        return
    end

    if not is_within_distance_to_loc(412, 180, 2, 25) then
        all_tellf("ERROR: Not at correct spot in guild lobby. Go to west wing opening and try again!")
        return
    end

    unflood_delay()

    local soulstone, price = get_best_soulstone()

    if not have_item(soulstone) and mq.TLO.Me.Platinum() < price then
        -- pick up plat from banker
        if mq.TLO.Me.PlatinumBank() < price then
            all_tellf("ERROR: Not enough plat in bank for corpse summoner. Need %d, have %d", price, mq.TLO.Me.PlatinumBank())
            cmd("/beep 1")
            return
        end

        log.Info("Not enough cash, need to pick up from bank ...")

        move_to_loc(415, 250, 2)    -- middle point
        delay(1000)

        move_to_loc(477, 190, 2)    -- banker
        delay(1000)

        open_banker()

        if not window_open("BigBankWnd") then
            all_tellf("ERROR failed to open bank")
            return
        end

        -- withdraw plat
        --:ammountofplat
        if not window_open("QuantityWnd") then
            cmd("/notify BigBankWnd BIGB_Money0 leftmouseup")
        end

        delay(100)

        delay(5, function() window_open("QuantityWnd") end)

        for i = 1, 9 do
            cmd("/keypress backspace chat")
            delay(20)
        end

        local costString = string.format("%d", price)

        for c in costString:gmatch"." do
            cmdf("/keypress %s chat", c)
            delay(30)
        end

        cmd("/notify QuantityWnd QTYW_Accept_Button leftmouseup")
        delay(20)
        cmd("/autoinventory")

        close_window("BigBankWnd")

        move_to_loc(415, 250, 2)    -- middle point
        delay(1000)
    end

    if not have_item(soulstone) then
        log.Info("Purchasing soulstone \ag%s\ax, price %d platinum", soulstone, price)

        target_npc_name("A Disciple of Luclin")

        move_to_loc(350, 191, 2)    -- A Disciple of Luclin
        delay(1000)

        cmd("/click right target")
        delay(1000)
        if not window_open("MerchantWnd") then
            all_tellf("ERROR corpse summoning: Fail to open MerchantWnd")
            return
        end

        cmdf("/nomodkey /notify MerchantWnd ItemList listselect %d", mq.TLO.Window("MerchantWnd").Child("ItemList").List("="..soulstone, 2)())
        delay(60)
        cmd("/notify MerchantWnd MW_Buy_Button leftmouseup")
        delay(1000, function() return have_item(soulstone) end)

        if have_item(soulstone) then
            cmd("/nomodkey /notify MerchantWnd MW_Done_Button leftmouseup")
        else
            all_tellf("ERROR failed to purchase soulstone !")
            return
        end
    end


    local item = find_item(soulstone)
    if item == nil then
        all_tellf("ERROR: cant find soulstone %s", soulstone)
        return
    end

    -- move to summoner
    move_to_loc(321, 270, 2) -- corpse summoner
    delay(1000)

    target_npc_name("A Priest of Luclin")

    -- pick up soulstone
    cmdf("/nomodkey /ctrl /itemnotify in Pack%d %d leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
    delay(200)
    delay(1000, function() return has_cursor_item() end)

    -- give it
    cmd("/click left target")
    delay(200)

    delay(1000, function() return not has_cursor_item() end)
    cmd("/notify GiveWnd GVW_Give_Button leftmouseup")

    delay(1000)

    move_to_loc(320, 300, 2)    -- sw corner
end

local function createCommand(distance)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/usecorpsesummoner")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/usecorpsesummoner", createCommand)
