local mq = require("mq")
local commandQueue = require('e4_commandQueue')
local log          = require("efyran/knightlinc/Write")
local groupBuffs = require("efyran/e4_GroupBuffs")

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
        if not me_priest() and not is_pal() then
            local clrName = nearest_peer_by_class("CLR")
            if clrName == nil then
                all_tellf("\arERROR\ax: Cannot request rez, no cleric nearby.")
                return
            end
            log.Info("Requesting rez for \ay%s\ax from \ag%s\ax.", spawn.Name(), clrName)
            cmdf("/dexecute %s /rezit %d", clrName, spawn.ID())
            return
        end
    end

    commandQueue.Enqueue(function() execute({SpawnId = mq.TLO.Target.ID()}) end)
end

-- Perform rez on target (CLR,DRU,SHM,PAL will auto use >= 90% rez spells) or delegate it to nearby cleric
mq.bind("/rezit", createCommand)
