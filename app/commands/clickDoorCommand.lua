local commandQueue = require('app/commandQueue')

---@class ClickDoorCommand
---@field Peer string
---@field Filter string

---@param command ClickDoorCommand
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

local function createCommand(peer, filter)
  if not peer then
    all_tellf("<peer> param is not set.")
    return nil
  end

  if not filter then
    all_tellf("<filter> param is not set.")
    return nil
  end

  commandQueue.Add(function() execute({Peer = peer, Filter = filter }) end)
end

mq.bind("/clickit", createCommand)
