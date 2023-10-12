local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local follow  = require("e4_Follow")
local auto_hand_in_items = require("e4_Handin")

local function execute()
    follow.Pause()
    auto_hand_in_items()
    follow.Resume()
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/handin", createCommand)
mq.bind("/handinall", function()
    cmd("/bcaa //handin")
end)
