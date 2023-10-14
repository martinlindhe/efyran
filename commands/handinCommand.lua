local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local follow  = require("e4_Follow")
local auto_hand_in_items = require("e4_Handin")

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
