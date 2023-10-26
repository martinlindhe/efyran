local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

local function execute()
    log.Debug("Execute /trade")

    if not window_open("tradewnd") then
        return
    end
    if have_cursor_item() then
        all_tellf("CANNOT ACCEPT TRADE: have item on cursor! %s", mq.TLO.Cursor.Name())
        return
    end
    if free_inventory_slots() == 0 then
        all_tellf("CANNOT ACCEPT TRADE: inventory is full!")
        return
    end

    log.Info("Accepting trade")
    cmd("/notify tradewnd TRDW_Trade_Button leftmouseup")
end

local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/trade")
    end
    commandQueue.Enqueue(function() execute() end)
end

-- tell all toons in zone to accept open trade windows
bind("/trade", createCommand)
