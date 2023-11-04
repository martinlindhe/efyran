local mq            = require("mq")
local log           = require("knightlinc/Write")
local timer         = require("lib/Timer")
local follow        = require("lib/following/Follow")
local buffs         = require("lib/spells/Buffs")
local botSettings   = require("lib/settings/BotSettings")

local Assist = {
    targetID = 0, -- the current spawn I am attacking

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

    powerlevel = 0, -- if non-zero, powerlevel is active and we assist at given HP %

    PBAE = false, -- is PBAE active?
}

-- Summons missing component for nukes. Only for magicians
-- eg: "Molten Orb/NoAggro/Summon|Summon: Molten Orb" (MAG)
local function summonNukeComponents()
    if botSettings.settings.assist == nil or botSettings.settings.assist.nukes == nil or not is_mag() or is_naked() then
        return
    end

    for idx, lines in pairs(botSettings.settings.assist.nukes) do
        for k, row in pairs(lines) do
            local spellConfig = parseSpellLine(row)
            if spellConfig.Summon ~= nil then
                if not known_spell_ability(spellConfig.Summon) then
                    all_tellf("I dont know spell/ability %s", spellConfig.Summon)
                    cmd("/beep 1")
                end

                log.Debug("Checking summon components for %s", spellConfig.Summon)

                if inventory_item_count(spellConfig.Name) == 0 then
                    log.Info("Summoning %s", spellConfig.Name)
                    wait_until_not_casting()
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

-- called at end of each /assist call
local function prepareForNextFight()
    log.Debug("Assist.prepareForNextFight")
    summonNukeComponents()
end

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
        local t = Assist.meleeDistance - 2
        if t >= 9 and mq.TLO.Target() ~= nil and mq.TLO.Target.Distance() > Assist.meleeDistance then
            log.Info("Reducing max distance from %f to %f", Assist.meleeDistance, t)
            Assist.meleeDistance = t
        end
    end)

    -- Adjust Melee position if we cannot see target
    mq.event("melee-cannot-see-target", "You cannot see your target.", function()
        if mq.TLO.Target() == nil or not Assist.IsAssisting() then
            return
        end

        log.Debug("Cannot see target, facing them !")
        cmdf("/squelch /face fast id %d", mq.TLO.Target.ID())
        delay(100)
    end)

    prepareForNextFight()
end

-- Returns true if I am assisting on a target.
---@return boolean
function Assist.IsAssisting()
    return Assist.targetID ~= 0
end

-- Returns true if I am tanking (sticking to the front).
---@return boolean
function Assist.IsTanking()
    return botSettings.settings.assist.stick_point == "Front"
end

function Assist.backoff()
    if Assist.targetID ~= 0 then
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
    if spawn == nil or spawn() == nil then
        return
    end

    Assist.beginKillSpawnID(spawn.ID())
end

local function meleeStick()
    if Assist.targetID == 0 then
        return
    end
    if Assist.IsTanking() then
        cmdf("/stick hold front %d uw", Assist.meleeDistance)
    else
        cmd("/stick snaproll uw")
        mq.delay(2000, function()
            return mq.TLO.Stick.Behind() and mq.TLO.Stick.Stopped()
        end)
        cmdf("/stick hold moveback behind %d uw", Assist.meleeDistance)
    end
end

-- Returns true if buffs are populated
---@return boolean
local function waitForBuffsPopulated()
    if mq.TLO.Me.LAInspectBuffs() == 0 then
        -- wont work without the leader aa
        return true
    end

    local count = 0

    local wait = 50
    local limit = wait * 20 -- 1000ms

    local target = mq.TLO.Target

    while not target.BuffsPopulated()
    do
        if target() == nil then
            return false
        end
        delay(wait)
        count = count + wait
        if count >= limit then
            all_tellf("WARN: broke waitForBuffsPopulated after %d ms", limit)
            return false
        end
    end
    return true
end

-- Returns true when ready to engage mob.
---@return boolean
local function waitForEngage()

    if not waitForBuffsPopulated() then
        return false
    end

    local target = mq.TLO.Target
    if target() == nil then
        return false
    end

    local startPct = botSettings.settings.assist.engage_at
    if Assist.powerlevel ~= 0 and not in_group() then
        startPct = Assist.powerlevel
    end

    if not is_number(startPct) then
        return true
    end

    while true do
        mq.doevents()
        if target() == nil or target.PctHPs() <= startPct or not Assist.IsAssisting() then
            break
        end
    end
    if not Assist.IsAssisting() then
        return false
    end

    if target() == nil then
        log.Debug("Aborting assist before engage! mob is dead")
        return false
    end

    log.Debug("Target is at %s %% HPs (min %d), sticking!", target.PctHPs(), startPct)
    return true
end

-- Sets powerlevel mode (assist HP %). 0 disables PL
---@param value integer
function Assist.Powerlevel(value)
    Assist.powerlevel = value
    log.Info("Powerlevel set to %d %%", value)
end

-- Sets current assist target and initalizes combat.
---@param spawnID integer
function Assist.beginKillSpawnID(spawnID)

    if spawnID == 0 then
        return
    end
    local spawn = spawn_from_id(spawnID)
    if spawn == nil or spawn() == nil then
        return
    end

    if spawn.Distance() > 200 then
        log.Debug("beginKillSpawnID: too far away %d, aborting", spawn.Distance())
        return
    end

    local timeStarted = mq.gettime()

    Assist.backoff()

    Assist.targetID = spawnID

    log.Info("Assist: Killing \ay%d\ax", spawnID)

    follow.PauseForKill()

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type:lower() == "melee"

    if botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type:lower() == "ranged" then
        all_tellf("XXX TODO ADD RANGED ASSIST MODE")
        cmd("/beep 1")
        return
    end

    if melee then
        if botSettings.settings.assist.melee_distance == "auto" then
            local mult = 0.5  -- XXX too far in riftseekers with 0.75. XXX cant disarm in riftseekers with 0.60
            if is_tank() then
                mult = 0.3
            end
            -- several mobs report too high MaxRangeTo so cant calc reliably
            local dist = math.ceil(spawn.MaxRangeTo() * mult)
            if dist > 30 then
                log.Error("MaxRangeTo ERROR: too far %d, going for 30", dist)
                dist = 30
            end

            Assist.meleeDistance = dist
            log.Debug("Calculated auto melee distance %f", Assist.meleeDistance)
        else
            Assist.meleeDistance = tonumber(botSettings.settings.assist.melee_distance)
        end

        if mq.TLO.Target.ID() ~= Assist.targetID then
            mq.cmdf("/target id %d", Assist.targetID)
            mq.delay(1)
        end

        if waitForEngage() then
            local timeSticking = mq.gettime() - timeStarted
            log.Debug("Engaging after %d ms", timeSticking)

            if not mq.TLO.Me.Combat() then
                cmd("/attack on")
                mq.delay(1)
            end

            meleeStick()
        end
    end
end

function Assist.EndFight()
    Assist.targetID = 0
    Assist.debuffsUsed = {}
    Assist.dotsUsed = {}
    Assist.quickburns = false
    Assist.longburns = false
    Assist.fullburns = false

    resetCastSpellAbilityTimers()

    buffs.resumeTimer:restart()

    if not is_brd() and is_casting() then
        cmd("/stopcast")
    end

    if have_pet() then
        log.Debug("Asking pet to back off")
        cmd("/pet back off")
    end

    if mq.TLO.Me.Combat() then
        cmd("/attack off")
    end

    -- abort all current follow commands
    follow.Pause()

    prepareForNextFight()

    -- resume following orchestrator
    follow.Resume()
end

-- Returns true if spell/ability was used
---@param targetID integer
---@param abilityRows string[]
---@param category string purely descriptive in log messages
---@param used? array optionally keep track of used abilites
---@return boolean
function performSpellAbility(targetID, abilityRows, category, used)
    if abilityRows == nil then
        return false
    end
    if targetID == 0 then
        -- signal ability was used, in order to leave Assist.Tick() quickly when target is nil
        return true
    end

    for v, row in ipairs(abilityRows) do
        local skip = false
        local spellConfig = parseSpellLine(row)
        if spellConfig.Name == "Bash" and not has_shield_equipped() then
            skip = true
        end
        -- log.Debug("Evaluating %s %s", category, spellConfig.Name)
        if not skip
        and (used == nil or used[row] == nil)
        and is_spell_ability_ready(spellConfig.Name)
        and not is_moving()
        and not is_stunned()
        and not obstructive_window_open()
        and (is_brd() or not is_casting()) then
            local spawn = spawn_from_id(targetID)
            if spawn == nil or spawn() == nil then
                -- signal ability was used, in order to leave Assist.Tick() quickly when target is nil
                return true
            end
            if is_standing() then
                cmdf("/squelch /face fast id %d", targetID)
            end
            --log.Debug("Trying to %s on %s with %s", category, spawn.Name(), spellConfig.Name)
            local spawnName = spawn.Name()
            if castSpellAbility(targetID, row) then
                log.Debug("Did \ay%s\ax on %s with %s", category, spawnName, spellConfig.Name)
                if used ~= nil then
                    used[row] = true
                end
                return true
            end
        end
    end
    return false
end

local assistTauntTimer = timer.new_expired(1 * 1) -- 1s

local function TankTick()
    if not Assist.IsTanking() or is_stunned() then
        return
    end

    local useDumbTaunt = true -- XXX put in settings

    if useDumbTaunt and assistTauntTimer:expired() and is_ability_ready("Taunt") then
        all_tellf("Taunting [+r+]%s", mq.TLO.Target.CleanName())
        use_ability("Taunt")
        assistTauntTimer:restart()
        return
    end

    -- requires Target of Target (server feature)
    local n = mq.TLO.Me.TargetOfTarget.Class.ShortName()
    local tot = mq.TLO.Me.TargetOfTarget.Name()
    if tot ~= nil and n ~= "WAR" and n ~= "PAL" and n ~= "SHD" then
        if assistTauntTimer:expired() then
            if is_ability_ready("Taunt") then
                all_tellf("Taunting \ar%s\ax (\ag%s\ax has aggro)", mq.TLO.Target.CleanName(), tot)
                use_ability("Taunt")
                assistTauntTimer:restart()
                return
            end
            -- look for "taunt" abilities, like PAL stuns
            for idx, tauntRow in pairs(botSettings.settings.assist.taunts) do
                local taunt = parseSpellLine(tauntRow)
                if is_spell_ability_ready(taunt.Name) then
                    if castSpellAbility(nil, tauntRow) then
                        all_tellf("Taunted \ar%s\ax [%s] (\ag%s\ax has aggro)", mq.TLO.Target.CleanName(), taunt.Name, tot)
                        assistTauntTimer:restart()
                        return
                    end
                end
            end
        end
    end
end

-- updates current fight progress
function Assist.Tick()

    -- progress PBAE
    if Assist.PBAE then
        local nearbyPBAEilter = "npc radius 60 zradius 50 los"
        if spawn_count(nearbyPBAEilter) == 0 then
            all_tellf("Ending PBAE. No nearby mobs.")
            Assist.PBAE = false
            return
        end

        if not is_casting() and not is_stunned() then
            for k, spellRow in pairs(botSettings.settings.assist.pbae) do
                local spellConfig = parseSpellLine(spellRow)
                if is_spell_ready(spellConfig.Name) or is_combat_ability_ready(spellConfig.Name) or is_item_clicky_ready(spellConfig.Name) then
                    if castSpellAbility(mq.TLO.Me.ID(), spellRow) then
                        log.Info("Used PBAE \ay%s\ax", spellConfig.Name)
                        return
                    end
                end
                doevents()
                delay(50)
            end
        end
    end

    if Assist.targetID == 0 then
        return
    end

    if is_feigning() then
        all_tellf("Feigned, standing up")
        mq.cmd("/stand")
    end

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type:lower() == "melee"
    local spawn = spawn_from_id(Assist.targetID)

    if spawn == nil or spawn() == nil then
        Assist.EndFight()
        return
    end

    if spawn == nil or spawn() == nil or spawn.ID() == 0 or spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
        Assist.EndFight()
        return
    end

    if have_pet() and not mq.TLO.Me.Pet.Combat() then
        log.Debug("Attacking with my pet %s", mq.TLO.Me.Pet.CleanName())
        mq.cmdf("/pet attack %d", Assist.targetID)
        delay(1)
    end

    if not is_stunned() then
        if mq.TLO.Target.ID() ~= Assist.targetID then
            cmdf("/target id %d", Assist.targetID)
            mq.delay(1)
        end
        if melee and not mq.TLO.Me.Combat() then
            cmd("/attack on")
        end
    end

    TankTick()

    if Assist.quickburns and performSpellAbility(Assist.targetID, botSettings.settings.assist.quickburns, "quickburn") then
        return
    end

    if Assist.longburns and performSpellAbility(Assist.targetID, botSettings.settings.assist.longburns, "longburn") then
        return
    end

    if Assist.fullburns and performSpellAbility(Assist.targetID, botSettings.settings.assist.fullburns, "fullburn") then
        return
    end

    -- perform debuffs ONE TIME EACH on assist before starting nukes
    if botSettings.settings.assist.debuffs ~= nil and (not is_casting() or is_brd()) and spawn ~= nil
    and performSpellAbility(Assist.targetID, botSettings.settings.assist.debuffs, "debuff", Assist.debuffsUsed) then
        return
    end

    -- perform dots ONE TIME EACH on assist before staring nukes
    if botSettings.settings.assist.dots ~= nil and (not is_casting() or is_brd()) and spawn ~= nil
    and performSpellAbility(Assist.targetID, botSettings.settings.assist.dots, "dot", Assist.dotsUsed) then
        return
    end

    -- use melee abilities
    if melee and botSettings.settings.assist.abilities ~= nil
    and spawn ~= nil and spawn.Distance() and spawn.Distance() ~= nil and spawn.Distance() < Assist.meleeDistance and spawn.LineOfSight()
    and performSpellAbility(Assist.targetID, botSettings.settings.assist.abilities, "ability") then
        return
    end

    -- caster/hybrid assist.nukes
    if botSettings.settings.assist.nukes ~= nil and (not is_casting() or is_brd()) and spawn ~= nil then
        if botSettings.settings.assist.nukes[Assist.spellSet] == nil then
            all_tellf("\arERROR I have no spell set '%s'\ax, reverting to spell set 'main'", Assist.spellSet)
            Assist.spellSet = "main"
        end
        if botSettings.settings.assist.nukes[Assist.spellSet] ~= nil then
            if performSpellAbility(Assist.targetID, botSettings.settings.assist.nukes[Assist.spellSet], "nuke") then
                return
            end
        else
            all_tellf("ERROR cannot nuke, have no spell set %s", Assist.spellSet)
        end
    end
end

return Assist
