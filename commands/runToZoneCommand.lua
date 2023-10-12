local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local follow  = require("e4_Follow")

local bci = broadCastInterfaceFactory()

---@class RunToZoneCommand
---@field Peer string

---@param command RunToZoneCommand
local function execute(command)
    follow.RunToZone(command.Peer)
end

-- run through zone based on the position of startingPeer
-- stand near a zoneline and face in the direction of the zoneline, run command for bots to move forward to the other zone
local function createCommand(startingPeerName)
    if is_orchestrator() then
        -- tell the others to cross zone line
        bci.ExecuteZoneCommand(string.format("/rtz %s", mq.TLO.Me.Name()))
        return
    end

    commandQueue.Enqueue(function() execute({Peer = startingPeerName}) end)
end

mq.bind("/rtz", createCommand)
