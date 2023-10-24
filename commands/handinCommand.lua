local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local follow  = require("lib/following/Follow")
local auto_hand_in_items = require("lib/quality/Handin")

local bci = broadCastInterfaceFactory()

local function execute()
    follow.Pause()
    auto_hand_in_items()
    follow.Resume()
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

bind("/handin", createCommand)
bind("/handinall", function()
    bci.ExecuteAllWithSelfCommand("/handin")
end)
