local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local assist         = require("e4_Assist")
local botSettings    = require("e4_BotSettings")

local bci = broadCastInterfaceFactory()

---@class PBAEBindCommand
---@field Peer string
---@field Filter string

---@param command PBAEBindCommand
local function execute(command)
    local peer = command.Peer
    local filter = command.Filter

    if filter ~= nil and not matches_filter(filter, peer) then
        log.Debug("NOT DOING PBAE, NOT MATCHING FILTER %s", filter)
        return
    end

    memorizePBAESpells()
    if not assist.PBAE then
        all_tellf("PBAE ON")
        assist.PBAE = true
    end
end

local function createPBAEOnCommand(...)
    local filter = args_string(...)

    if is_orchestrator() then
        local exe = string.format("/pbaestart %s", mq.TLO.Me.Name())
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        bci.ExecuteZoneCommand(exe)
    end
    if botSettings.settings.assist.pbae == nil then
        return
    end
    commandQueue.Enqueue(function() execute({ Peer = mq.TLO.Me.Name(), Filter = filter }) end)
end

local function createPBAEStartCommand(peer, ...)
    local filter = args_string(...)
    if botSettings.settings.assist.pbae == nil then
        return
    end

    commandQueue.Enqueue(function() execute({ Peer = peer, Filter = filter }) end)
end


-- Used by orchestrator to start pbae
bind("/pbaeon", createPBAEOnCommand)
bind("/pbaestart", createPBAEStartCommand)
bind("/pbaeoff", function()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/pbaeoff")
    end
    if assist.PBAE == true then
        assist.PBAE = false
        all_tellf("PBAE OFF")
    end
end)
