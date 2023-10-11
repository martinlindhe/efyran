local commandQueue = require('app/commandQueue')
local follow  = require("efyran/e4_Follow")

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
