local mq = require("mq")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require('e4_CommandQueue')
local log          = require("knightlinc/Write")

local bci = broadCastInterfaceFactory()

---@class RezItCommand
---@field SpawnId number

---@param command RezItCommand
local function execute(command)
    rez_corpse(command.SpawnId)
end

local function createCommand()
    if is_orchestrator() then
        if not has_target() then
            log.Error("/rezit: No corpse targeted.")
            return
        end
        local spawn = get_target()
        if spawn == nil then
            log.Error("/rezit: No target to rez.")
            return
        end

        if spawn.Type() ~= "Corpse" then
            log.Error("/rezit: Target is not a corpse. Type %s",  spawn.Type())
            return
        end

        -- non-cleric orchestrator asks nearby CLR to rez spawnID
        if not is_priest() and not is_pal() then
            local clrName = nearest_peer_by_class("CLR")
            if clrName == nil then
                all_tellf("\arERROR\ax: Cannot request rez, no cleric nearby.")
                return
            end
            log.Info("Requesting rez for \ay%s\ax from \ag%s\ax.", spawn.Name(), clrName)
            bci.ExecuteCommand(string.format("/rezit %d", spawn.ID()), {clrName})
            return
        end
    end

    commandQueue.Enqueue(function() execute({SpawnId = mq.TLO.Target.ID()}) end)
end

-- Perform rez on target (CLR,DRU,SHM,PAL will auto use >= 90% rez spells) or delegate it to nearby cleric
bind("/rezit", createCommand)
