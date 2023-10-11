local commandQueue = require('app/commandQueue')
local assist  = require("efyran/e4_Assist")

local function execute()
    delay(5000) -- 5s
    commandQueue.Clear()
    assist.backoff()
    complete_zoned_event()
end

local function createCommand(text, zone)
    if zone == "an area where levitation effects do not function" then
        return
    end

    commandQueue.Enqueue(function() execute() end)
end

mq.event("zoned", "You have entered #1#.", createCommand)
