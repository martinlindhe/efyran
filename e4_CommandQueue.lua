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
        if spawn == nil or (spawn.Type() == "PC" or spawn.Type() == "Pet") then
            return
        end

        log.Debug("Killing %s, type %s", spawn.DisplayName(), spawn.Type())
        assist.handleAssistCall(spawn)

    elseif v.Name == "pbaeon" then
        pbae_loop()
    elseif v.Name == "evacuate" then
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
        move_to(toint(v.Arg))
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
        cast_ae_cry()
    elseif v.Name == "aebloodthirst" then
        cast_ae_bloodthirst()
    elseif v.Name == "lootcorpse" then
        loot_my_corpse()
    elseif v.Name == "consentme" then
        consent_me()
    elseif v.Name == "gathercorpses" then
        gather_corpses()
    elseif v.Name == "finditem" then
        report_find_item(v.Arg)
    elseif v.Name == "findmissingitem" then
        report_find_missing_item(v.Arg)
    elseif v.Name == "reportclickies" then
        report_clickies()
    elseif v.Name == "summonbanker" then
        local aaName = "Summon Clockwork Banker"
        if is_alt_ability_ready(aaName) then
            use_alt_ability(aaName, nil)
            return
        end

        log.Warn(aaName.." is not ready. Ready in "..mq.TLO.Me.AltAbilityTimer(aaName).TimeHMS())

        if not is_orchestrator() then
            return
        end

        ask_nearby_peer_to_activate_aa(aaName)
    elseif v.Name == "reportwornaugs" then
        report_worn_augs()
    elseif v.Name == "open-nearby-corpse" then
        open_nearby_corpse()
    elseif v.Name == "use-veteran-aa" then
        use_veteran_aa(v.Arg)
    elseif v.Name == "dropbuff" then
        drop_buff(v.Arg)
    elseif v.Name == "mount-on" then
        mount_on()
    else
        all_tellf("ERROR unknown command in queue: %s", v.Name)
    end
end

return CommandQueue
