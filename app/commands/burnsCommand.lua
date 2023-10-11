local mq = require("mq")
local commandQueue = require('app/commandQueue')
local log          = require("efyran/knightlinc/Write")
local assist       = require("efyran/e4_Assist")

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
        cmd("/dgzexecute /quickburns")
    end

    commandQueue.Enqueue(function() execute({ Type = "quickburns" }) end)
end

local function createLongBurnsCommand(peer, filter)
    if is_orchestrator() then
        cmd("/dgzexecute /longburns")
    end

    commandQueue.Enqueue(function() execute({ Type = "longburns" }) end)
end

local function createFullBurnsCommand(peer, filter)
    if is_orchestrator() then
        cmd("/dgzexecute /fullburns")
    end

    commandQueue.Enqueue(function() execute({ Type = "fullburns" }) end)
end

mq.bind("/quickburns", createQuickBurnsCommand)
mq.bind("/longburns", createLongBurnsCommand)
mq.bind("/fullburns", createFullBurnsCommand)
