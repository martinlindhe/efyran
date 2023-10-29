local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local assist         = require("lib/assisting/Assist")
local botSettings    = require("lib/settings/BotSettings")

local bci = broadCastInterfaceFactory()

local function distributePetWeapons()
    log.Info("XXX TODO IMPL distribute pet weapons")
end

bind("/dpw", function()
    commandQueue.Enqueue(function() distributePetWeapons() end)
end)
