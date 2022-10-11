local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("e4_BotSettings")
local hail = require("e4_Hail")
local buffs   = require("e4_Buffs")
local bard = require("Class_Bard")
local follow  = require("e4_Follow")
local assist  = require("e4_Assist")
local pet     = require("e4_Pet")
local group   = require("e4_Group")

---@class CommandQueueValue
---@field public Name string Name
---@field public Arg string Argument
---@field public Arg2 string Second argument

local CommandQueue = {
    ---@type CommandQueueValue[]
    queue = {},
}

---@param name string
---@param arg? string optional argument
---@param arg2? string optional argument
function CommandQueue.Add(name, arg, arg2)
    table.insert(CommandQueue.queue, {
        ["Name"] = name,
        ["Arg"] = arg,
        ["Arg2"] = arg2,
    })
end

function CommandQueue.Remove(name)
    local idx = -1

    for k, v in pairs(CommandQueue.queue) do
        if v.Name == name then
            idx = k
        end
    end

    if idx ~= -1 then
        table.remove(CommandQueue.queue, idx)
    end
end

---@return CommandQueueValue|nil
function CommandQueue.PeekFirst()
    for k, v in pairs(CommandQueue.queue) do
        return v
    end
    return nil
end

-- Clears the command queue
function CommandQueue.Clear()
    CommandQueue.queue = {}
end

function CommandQueue.Process()
    --log.Debug("CommandQueue.Process()")

    local v = CommandQueue.PeekFirst()
    if v == nil then
        return
    end

    log.Info("Performing command \ay%s\ax (%s, %s)", v.Name, v.Arg, v.Arg2)

    CommandQueue.Remove(v.Name)

    if v.Name == "joingroup" then
        wait_until_not_casting()
        cmd("/squelch /target clear")
        delay(100)
        cmd("/squelch /invite")
    elseif v.Name == "joinraid" then
        wait_until_not_casting()
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
        cmd("/squelch /raidaccept")
    elseif v.Name == "zoned" then
        log.Debug("I zoned into ", zone_shortname())
        pet.ConfigureTaunt()

        joinCurrentHealChannel()
        memorizeListedSpells()
    elseif v.Name == "dropinvis" then
        drop_invis()
    elseif v.Name == "playmelody" then
        bard.PlayMelody(v.Arg)
    elseif v.Name == "radiantcure" then
        cast_radiant_cure()
    elseif v.Name == "buffit" then
        buffs.BuffIt(toint(v.Arg))
    elseif v.Name == "killit" then
        local filter = v.Arg2
        if filter ~= nil then
            if not matches_filter(filter) then
                log.Info("Not matching filter, giving up: %s", filter)
                return
            end
        end
        local spawn = spawn_from_id(toint(v.Arg))
        if spawn == nil then
            return
        end
        if spawn.Type() ~= "PC" then
            if assist.target ~= nil then
                log.Debug("Backing off existing target before assisting new")
                assist.backoff()
            end
            log.Debug("Killing %s, type %s", spawn.DisplayName(), spawn.Type())
            assist.handleAssistCall(spawn)
        end
    elseif v.Name == "pbaeon" then
        pbae_loop()
    elseif v.Name == "evac" then
        cast_evac_spell()
    elseif v.Name == "groupheal" then
        cast_group_heal()
    elseif v.Name == "shrinkgroup" then
        shrink_group()
    elseif v.Name == "clickit" then
        if v.Arg ~= nil and matches_filter(v.Arg) then
            click_nearby_door()
        end
    elseif v.Name == "portto" then
        cast_port_to(v.Name)
    elseif v.Name == "movetoid" then
        local spawnID = toint(v.Arg)
        local spawn = spawn_from_id(spawnID)
        if spawn ~= nil then
            move_to(spawn)
        end
    elseif v.Name == "rtz" then
        follow.RunToZone(v.Arg)
    elseif v.Name == "hailit" then
        hail.PerformHail()
    elseif v.Name == "recallgroup" then
        group.RecallGroup(v.Arg, v.Arg2)
    elseif v.Name == "rezit" then
        rez_it(toint(v.Arg))
    elseif v.Name == "aerez" then
        ae_rez()
    elseif v.Name == "mgb" then
        if not is_spell_in_book(v.Arg) and not have_alt_ability(v.Arg) then
            all_tellf("FATAL: I cannot mgb this, dont have it: %s", v.Arg)
            return
        end
        cast_mgb_spell(v.Arg)
    elseif v.Name == "aecry" then
        cast_ae_cry(v.Arg)
    else
        all_tellf("ERROR unknown command in queue: %s", v.Name)
    end
end

return CommandQueue
