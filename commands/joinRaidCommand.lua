local mq = require("mq")
local commandQueue = require("lib/CommandQueue")
local log          = require("knightlinc/Write")
local serverSettings = require("lib/settings/default/ServerSettings")

local function execute()
    wait_until_not_casting()
    log.Info("Accepting raid invite")
    cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
    cmd("/squelch /raidaccept")
end

local function createCommand(text, sender)
    if not is_peer(sender) then
        all_tellf("Got raid invite from %s", sender)
        if not serverSettings.allowStrangers then
            all_tellf("ERROR: Ignoring Raid invite from unknown player %s", sender)
            return
        end
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.event('joinraid', '#1# invites you to join a raid.#*#', createCommand)
