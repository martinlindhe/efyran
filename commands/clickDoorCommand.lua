local mq = require("mq")
local commandQueue = require('e4_commandQueue')
local log          = require("efyran/knightlinc/Write")

---@class ClickDoorBindCommand
---@field Peer string
---@field Filter string

local function click_nearby_door()
    -- TODO: dont know how to access /doors list from lua/macroquest

    cmd("/doortarget")
    delay(10)
    if mq.TLO.DoorTarget.ID() == nil then
        all_tellf("failed to find a door to click!")
        return
    end

    log.Info("CLICKING NEARBY DOOR %s, id %d, distance %d", mq.TLO.DoorTarget.Name(), mq.TLO.DoorTarget.ID(), mq.TLO.DoorTarget.Distance())

    unflood_delay()
    cmd("/click left door")
end

---@param command ClickDoorBindCommand
local function execute(command)
    local sender = spawn_from_peer_name(command.Peer)
    if sender ~= nil and not is_within_distance(sender, 60) then
        all_tellf("TOO FAR AWAY FROM %s (%.2f), CANT CLICK", command.Peer, sender.Distance())
        return
    end

    if command.Filter ~= nil and not matches_filter(command.Filter, command.Peer) then
        return
    end

    click_nearby_door()
end

local function createClickItCommand(...)
    local filter = args_string(...)

    if is_orchestrator() then
        mq.cmdf("/dgzexecute /clickdoor %s %s", mq.TLO.Me.Name(), filter)
    end

    commandQueue.Enqueue(function() execute({ Peer = mq.TLO.Me.Name(), Filter = filter }) end)
end

local function createClickDoorCommand(sender, ...)
    local filter = args_string(...)
    commandQueue.Enqueue(function() execute({ Peer = sender, Filter = filter }) end)
end

mq.bind("/clickit", createClickItCommand)
mq.bind("/clickdoor", createClickDoorCommand)
