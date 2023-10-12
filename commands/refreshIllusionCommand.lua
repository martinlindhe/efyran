local mq = require("mq")
local commandQueue = require('e4_CommandQueue')
local botSettings = require("e4_BotSettings")

local function execute()
    local illusion = botSettings.GetCurrentIllusion()
    if illusion ~= nil then
        -- many model changes at once lags the client
        unflood_delay()
        castSpell(illusion, mq.TLO.Me.ID())
    end
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

mq.bind("/refreshillusion", createCommand)
mq.bind("/refreshillusions", function()
    cmd("/bcaa //refreshillusion")
end)
