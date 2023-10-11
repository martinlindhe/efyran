local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local commandQueue = require('e4_commandQueue')
local assist         = require("efyran/e4_Assist")
local botSettings    = require("efyran/e4_BotSettings")

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
        local exe = string.format("/dgzexecute /pbaestart %s", mq.TLO.Me.Name())
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        mq.cmdf(exe)
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
mq.bind("/pbaeon", createPBAEOnCommand)
mq.bind("/pbaestart", createPBAEStartCommand)
mq.bind("/pbaeoff", function()
    if is_orchestrator() then
        cmd("/dgzexecute /pbaeoff")
    end
    if assist.PBAE == true then
        assist.PBAE = false
        all_tellf("PBAE OFF")
    end
end)
