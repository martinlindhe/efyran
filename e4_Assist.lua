local mq = require("mq")
local log = require("knightlinc/Write")
local timer = require("Timer")

local follow  = require("e4_Follow")
local botSettings = require("e4_BotSettings")
local heal    = require("e4_Heal")

local Assist = {
    target = nil, -- the current spawn I am attacking

    -- the current spell set
    spellSet = "main",

    -- current max melee distance
    meleeDistance = 0.,

    -- the debuffs/dots used on current target
    debuffsUsed = {},
    dotsUsed = {},

    quickburns = false,
    longburns = false,
    fullburns = false,

    ---@type integer
    lastFollowID = 0,
}

function Assist.Init()

    if botSettings.settings.assist ~= nil then
        if botSettings.settings.assist.melee_distance == nil then
            botSettings.settings.assist.melee_distance = "auto"
        end
        botSettings.settings.assist.melee_distance = tostring(botSettings.settings.assist.melee_distance):lower()
        if botSettings.settings.assist.melee_distance == "maxmelee" then
            botSettings.settings.assist.melee_distance = "auto"
        end

        if botSettings.settings.assist.type ~= nil then
            botSettings.settings.assist.type = botSettings.settings.assist.type:lower()
        end
    end

    -- Adjust Melee distance if too far away msg, because spawn.MaxDistanceTo() is not exact
    mq.event("melee-out-of-range", "Your target is too far away, get closer!", function()
        local t = Assist.meleeDistance - 1
        if t >= 9 then
            log.Info("Reducing max distance from %f to %f", Assist.meleeDistance, t)
            Assist.meleeDistance = t
        end
    end)

    Assist.prepareForNextFight()
end

-- Are we assisting on a target?
---@return boolean
function Assist.IsAssisting()
    return Assist.targetID ~= 0
end


function Assist.backoff()
    if Assist.targetID ~= nil then
        log.Info("Backing off target %d", Assist.targetID)
        Assist.EndFight()
    end
end

---@param spawn spawn
function Assist.handleAssistCall(spawn)
    if botSettings.settings == nil or botSettings.settings.assist == nil then
        all_tellf("WARNING: I have no assist settings")
        return
    end

    Assist.beginKillSpawnID(spawn.ID())
end

-- called at end of each /assist call
function Assist.prepareForNextFight()
    log.Debug("Assist.prepareForNextFight")
    Assist.summonNukeComponents()
end

-- Summons missing component for nukes. Only for magicians
-- eg: "Molten Orb/NoAggro/Summon|Summon: Molten Orb" (MAG)
function Assist.summonNukeComponents()
    if botSettings.settings.assist == nil or botSettings.settings.assist.nukes == nil or not is_mag() then
        return
    end

    if is_casting() then
        log.Info("WARNING: cannot summon nuke components. I am busy casting %s on target %s", mq.TLO.Me.Casting.Name(), mq.TLO.Target.Name())
        return
    end

    for idx, lines in pairs(botSettings.settings.assist.nukes) do
        if type(lines) == "string" then
            all_tellf("FATAL ERROR: settings.assist.nukes must be a map")
            cmd("/beep 1")
            delay(10000)
            return
        end
        for k, row in pairs(lines) do
            local spellConfig = parseSpellLine(row)
            if spellConfig.Summon ~= nil then
                if not known_spell_ability(spellConfig.Summon) then
                    all_tellf("I dont know spell/ability %s", spellConfig.Summon)
                    cmd("/beep 1")
                end

                log.Debug("Checking summon components for %s", spellConfig.Summon)

                if getItemCountExact(spellConfig.Name) == 0 then
                    log.Info("Summoning %s", spellConfig.Name)
                    castSpellRaw(spellConfig.Summon, nil)

                    -- wait and inventory
                    local spell = get_spell(spellConfig.Summon)
                    if spell ~= nil then
                        delay(2000 + spell.MyCastTime())
                        clear_cursor()
                    end
                    return true
                end
            end

        end
    end
end

-- Sets current assist target and initalizes combat.
---@param spawnID integer
function Assist.beginKillSpawnID(spawnID)

    Assist.backoff()

    Assist.targetID = spawnID

    if spawnID == 0 then
        return
    end

    log.Info("Assist.beginKillSpawnID %d", spawnID)

    if have_pet() then
        log.Debug("Attacking with my pet %s", mq.TLO.Me.Pet.CleanName())
        mq.cmdf("/pet attack %d", spawnID)
    end

    Assist.lastFollowID = follow.spawn.ID()
    follow.Stop()

    mq.cmdf("/target id %d", spawnID)

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "melee"

    if botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "ranged" then
        all_tellf("XXX TODO ADD RANGED ASSIST MODE")
        cmd("/beep 1")
        return
    end

    if melee then
        local spawn = spawn_from_id(Assist.targetID)
        if spawn == nil then
            return
        end

        if botSettings.settings.assist.melee_distance == "auto" then
            Assist.meleeDistance = spawn.MaxRangeTo() * 0.50 -- XXX too far in riftseekers with 0.75. XXX cant disarm in riftseekers with 0.60
            log.Info("Calculated auto melee distance %f", Assist.meleeDistance)
        else
            Assist.meleeDistance = tonumber(botSettings.settings.assist.melee_distance)
        end
        move_to(spawnID)
    end
end

function Assist.meleeStick()
    local stickArg

    if botSettings.settings.assist.stick_point == "Front" then
        stickArg = "hold front " .. Assist.meleeDistance .. " uw"
        log.Debug("STICKING IN FRONT TO %d: %s", Assist.targetID, stickArg)
        mq.cmdf("/stick %s", stickArg)
    else
        mq.cmd("/stick snaproll uw")
        mq.delay(200, function()
            return mq.TLO.Stick.Behind() and mq.TLO.Stick.Stopped()
        end)
        stickArg = "hold moveback behind " .. Assist.meleeDistance .. " uw"
        log.Debug("STICKING IN BACK TO %d: %s", Assist.targetID, stickArg)
        mq.cmdf("/stick %s", stickArg)
    end
end

function Assist.EndFight()
    Assist.targetID = 0
    Assist.debuffsUsed = {}
    Assist.dotsUsed = {}
    Assist.quickburns = false
    Assist.longburns = false
    Assist.fullburns = false

    if not is_brd() and is_casting() then
        cmd("/stopcast")
    end

    if have_pet() then
        log.Debug("Asking pet to back off")
        cmd("/pet back off")
    end

    cmd("/attack off")
    cmd("/stick off")

    Assist.prepareForNextFight()

    if Assist.lastFollowID ~= 0 then
        follow.Start(Assist.lastFollowID)
    end
end

-- Returns true if spell/ability was used
---@param abilityRows string[]
---@param category string purely descriptive in log messages
---@param used? array optionally keep track of used abilites
---@return boolean
function Assist.performSpellAbility(abilityRows, category, used)
    if abilityRows == nil then
        return false
    end
    if Assist.targetID == 0 then
        -- signal ability was used, in order to leave Assist.Tick() quickly when target is nil
        return true
    end
    for v, row in ipairs(abilityRows) do
        local spellConfig = parseSpellLine(row)
        log.Info("Evaluating %s %s", category, spellConfig.Name)
        if (used == nil or used[row] == nil)
        and is_spell_ability_ready(spellConfig.Name)
        and (is_brd() or not is_casting()) then
            local spawn = spawn_from_id(Assist.targetID)
            if not spawn then
                -- signal ability was used, in order to leave Assist.Tick() quickly when target is nil
                return true
            end
            log.Info("Trying to %s on %s with %s", category, spawn.Name(), spellConfig.Name)
            if castSpellAbility(spawn, row) then
                log.Info("Did \ay%s\ax on %s with %s", category, spawn.Name(), spellConfig.Name)
                if used ~= nil then
                    used[row] = true
                end
                return true
            end
        end
    end
    return false
end

local assistStickTimer = timer.new_expired(3 * 1) -- 3s

-- updates current fight progress
function Assist.Tick()
    if Assist.targetID == 0 then
        return
    end

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "melee"
    local spawn = spawn_from_id(Assist.targetID)

    if spawn == nil then
        Assist.EndFight()
        return
    end

    log.Info("Assist.Tick()")

    if melee and spawn.MaxRangeTo() > Assist.meleeDistance and assistStickTimer:expired() then
        log.Info("stick update meleeDistance %f!", Assist.meleeDistance)
        Assist.meleeStick()
        assistStickTimer:restart()
    end

    if spawn == nil or spawn.ID() == 0 or spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
        Assist.EndFight()
        return
    end

    if melee and not mq.TLO.Me.Combat() then
        cmd("/attack on")
    end

    if not is_casting() and (not has_target() or mq.TLO.Target.ID() ~= spawn.ID()) then
        -- XXX
        all_tellf("killSpawn WARN: i lost target, restoring to %s (%s). Previous target was %s", spawn.Name(), spawn.Type(), mq.TLO.Target.Name())
        cmdf("/target id %d", spawn.ID())
    end

    if Assist.quickburns and Assist.performSpellAbility(botSettings.settings.assist.quickburns, "quickburn") then
        return
    end

    if Assist.longburns and Assist.performSpellAbility(botSettings.settings.assist.longburns, "longburn") then
        return
    end

    if Assist.fullburns and Assist.performSpellAbility(botSettings.settings.assist.fullburns, "fullburn") then
        return
    end

    -- perform debuffs ONE TIME EACH on assist before starting nukes
    if botSettings.settings.assist.debuffs ~= nil and not is_casting() and spawn ~= nil
    and Assist.performSpellAbility(botSettings.settings.assist.debuffs, "debuff", Assist.debuffsUsed) then
        return
    end

    -- perform dots ONE TIME EACH on assist before staring nukes
    if botSettings.settings.assist.dots ~= nil and not is_casting() and spawn ~= nil
    and Assist.performSpellAbility(botSettings.settings.assist.dots, "dot", Assist.dotsUsed) then
        return
    end

    -- use melee abilities
    if melee and botSettings.settings.assist.abilities ~= nil
    and spawn ~= nil and spawn.Distance() < Assist.meleeDistance and spawn.LineOfSight()
    and Assist.performSpellAbility(botSettings.settings.assist.abilities, "ability") then
        return
    end

    -- caster/hybrid assist.nukes
    if botSettings.settings.assist.nukes ~= nil and not is_casting() and spawn ~= nil then
        if botSettings.settings.assist.nukes[Assist.spellSet] == nil then
            all_tellf("\arERROR I have no spell set '%s'\ax, reverting to spell set 'main'", Assist.spellSet)
            Assist.spellSet = "main"
        end
        if botSettings.settings.assist.nukes[Assist.spellSet] ~= nil then
            if Assist.performSpellAbility(botSettings.settings.assist.nukes[Assist.spellSet], "nuke") then
                return
            end
        else
            all_tellf("ERROR cannot nuke, have no spell set %s", Assist.spellSet)
        end
    end

end

return Assist
