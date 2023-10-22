local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")
local botSettings = require("settings/BotSettings")

local bci = broadCastInterfaceFactory()

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

bind("/refreshillusion", createCommand)
bind("/refreshillusions", function()
    bci.ExecuteAllWithSelfCommand("/refreshillusion")
end)
