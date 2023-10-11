local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local commandQueue = require('e4_commandQueue')

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
        cmd("/dgzexecute /no")
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/no", createCommand)
