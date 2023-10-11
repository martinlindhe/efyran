local mq = require("mq")
local log          = require("efyran/knightlinc/Write")
local commandQueue = require('e4_commandQueue')

local function execute()
    wait_until_not_casting()
    cmd("/squelch /target clear")
    delay(100)
    cmd("/squelch /invite")
end

local function createCommand(sender)
    if is_peer(sender) then
        commandQueue.Enqueue(function() execute() end)
    end
end

mq.event('joingroup', '#1# invites you to join a group.', function(text, sender) createCommand(sender) end)
