local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local log          = require("knightlinc/Write")
local assist       = require("e4_Assist")

local bci = broadCastInterfaceFactory()

---@class BurnsCommand
---@field Type string

---@param command BurnsCommand
local function execute(command)
    if not in_combat() then
        log.Info("Ignoring \ay%s\ax burns request (not in combat)", command.Type)
        return
    end
    log.Info("Enabling burns \ay%s\ax", command.Type)
    if command.Type == "quickburns" then
        assist.quickburns = true
    elseif command.Type == "longburns" then
        assist.longburns = true
    elseif command.Type == "fullburns" then
        assist.fullburns = true
    else
        log.Error("Unknown burns set '%s'", command.Type)
    end
end

local function createQuickBurnsCommand(peer, filter)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/quickburns")
    end

    commandQueue.Enqueue(function() execute({ Type = "quickburns" }) end)
end

local function createLongBurnsCommand(peer, filter)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/longburns")
    end

    commandQueue.Enqueue(function() execute({ Type = "longburns" }) end)
end

local function createFullBurnsCommand(peer, filter)
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/fullburns")
    end

    commandQueue.Enqueue(function() execute({ Type = "fullburns" }) end)
end

mq.bind("/quickburns", createQuickBurnsCommand)
mq.bind("/longburns", createLongBurnsCommand)
mq.bind("/fullburns", createFullBurnsCommand)
