local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')

local bci = broadCastInterfaceFactory()

local function execute()
    log.Info("click no")
    if window_open("ConfirmationDialogBox") then
        cmd("/notify ConfirmationDialogBox No_Button leftmouseup")
    elseif window_open("LargeDialogWindow") then
        cmd("/notify LargeDialogWindow LDW_NoButton leftmouseup")
    end
end

-- tell all peers to click no on dialog (aetl, rez, etc)
local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/no")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/no", createCommand)
