local mq = require("mq")
local log = require("knightlinc/Write")

local follow  = require("e4_Follow")
local botSettings = require("e4_BotSettings")
local heal    = require("e4_Heal")

local Assist = {
    target = nil, -- the current spawn I am attacking
}

local spellSet = "main" -- the current spell set. XXX impl switching it

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

    Assist.prepareForNextFight()

end


function Assist.backoff()
    if Assist.target ~= nil then
        log.Debug("Backing off target %s", Assist.target.Name())
        Assist.target = nil
        if have_pet() then
            log.Debug("Asking pet to back off")
            cmd("/pet back off")
        end
    end
end

---@param spawn spawn
function Assist.handleAssistCall(spawn)
    if botSettings.settings == nil or botSettings.settings.assist == nil then
        all_tellf("WARNING: I have no assist settings")
        return
    end

    Assist.killSpawn(spawn)
    Assist.prepareForNextFight()
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
                    all_tellf("Summoning %s", spellConfig.Name)
                    --delay(100)
                    castSpell(spellConfig.Summon, mq.TLO.Me.ID())
                    all_tellf("DBG Summoned %s", spellConfig.Name)

                    -- wait and inventory
                    local spell = get_spell(spellConfig.Summon)
                    if spell ~= nil then
                        all_tellf("DBG Summoned %s - waiting", spellConfig.Name)
                        delay(2000 + spell.MyCastTime())
                        all_tellf("DBG Summoned %s - clearing", spellConfig.Name)
                        clear_cursor()
                        all_tellf("DBG Summoned %s - cleared", spellConfig.Name)
                    end
                    return true
                end
            end

        end
    end
end

-- return true if spell/ability was cast
---@param spawn spawn
---@param row string
---@param callback? fun(): boolean
function castSpellAbility(spawn, row, callback)

    local spell = parseSpellLine(row)

   log.Debug("castSpellAbility %s: %s", row, spell.Name)

    if spell.PctAggro ~= nil and mq.TLO.Me.PctAggro() < spell.PctAggro then
        -- PctAggro skips cast if your aggro % is above threshold
        log.Debug("SKIP PctAggro %s aggro %d vs required %d", spell.Name, mq.TLO.Me.PctAggro(), spell.PctAggro)
        return false
    end
    if spell.NoAggro ~= nil and spell.NoAggro and mq.TLO.Me.TargetOfTarget.ID() == mq.TLO.Me.ID() then
        -- NoAggro skips cast if you are on top of aggro
        --print("SKIP NoAggro ", spell.Name, " i have aggro")
        return false
    end

    if spell.GoM ~= nil and spell.GoM and have_song("Gift of Mana") then
        return false
    end

    if spell.MinMana ~= nil and mq.TLO.Me.PctMana() < spell.MinMana then
        log.Info("SKIP MinMana %s, %d vs required %d", spell.Name,  mq.TLO.Me.PctMana(), spell.MinMana)
        return false
    end

    if spell.Summon ~= nil and getItemCountExact(spell.Name) == 0 then
        log.Info("SKIP Summon %s, missing summoned item mid-fight", spell.Name)
        return false
    end

    if spell.NoPet ~= nil and spell.NoPet and have_pet() then
        all_tellf("SKIP NoPet, i have a pet up")
        return false
    end

    local cb = function()
        if spawn == nil then
            all_tellf("castSpellAbility: target died. ducking spell cast %s", mq.TLO.Me.Casting.Name())
            cmdf("/interrupt")
            return true
        end
        if not is_casting() then
            return true
        end
    end
    if callback ~= nil then
        cb = callback
    end

    if not is_spell_ability_ready(spell.Name) then
        return false
    end

    log.Info("castSpellAbility Casting %s", spell.Name)
    castSpell(spell.Name, spawn.ID())
    delay(200)
    -- delay until done casting, and abort cast if target dies
    delay(10000, cb)
    log.Info("Done waiting after cast.")
    return true
end

-- Stick and perform melee attacks.
---@param spawn spawn
function Assist.killSpawn(spawn)

    Assist.target = spawn
    local currentID = spawn.ID()

    if spawn == nil then
        all_tellf("ERROR: killSpawn called with nil")
        return
    end

    log.Debug("Assist.killSpawn %s", spawn.Name())

    if have_pet() then
        log.Debug("Attacking with my pet %s", mq.TLO.Me.Pet.CleanName())
        cmdf("/pet attack %d", spawn.ID())
    end

    cmdf("/target id %d", spawn.ID())
    follow.Pause()
    delay(1)

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "melee"

    if botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "ranged" then
        all_tellf("XXX TODO ADD RANGED ASSIST MODE")
        cmd("/beep 1")
        return
    end

    if melee then

        local meleeDistance = botSettings.settings.assist.melee_distance
        if meleeDistance == "auto" then
            meleeDistance = spawn.MaxRangeTo() * 0.75
            log.Info("Calculated auto melee distance %f", meleeDistance)
        end

        if not mq.TLO.Navigation.MeshLoaded() then
            all_tellf("MISSING NAVMESH FOR %s", zone_shortname())
            return
        end

        -- use mq2nav to navigate close to the mob, THEN use stick
        move_to(spawn)

        cmd("/attack on")

        local stickArg

        if botSettings.settings.assist.stick_point == "Front" then
            stickArg = "hold front " .. meleeDistance .. " uw"
            log.Debug("STICKING IN FRONT TO %s: %s", spawn.Name, stickArg)
            cmdf("/stick %s", stickArg)
        else
            cmd("/stick snaproll uw")
            delay(200, function()
                return mq.TLO.Stick.Behind() and mq.TLO.Stick.Stopped()
            end)
            stickArg = "hold moveback behind " .. meleeDistance .. " uw"
            log.Debug("STICKING IN BACK TO %s: %s", spawn.Name, stickArg)
            cmdf("/stick %s", stickArg)
        end
    end


    while true do
        --log.Debug("killSpawn %s loop start, melee = %s", spawn.Name(), bools(melee))
        if Assist.target == nil then
            -- break outer loop if /backoff was called
            log.Debug("killSpawn: i got called off, breaking outer loop")
            break
        end
        if Assist.target.ID() ~= currentID then
            log.Debug("killSpawn: assist called on another mob, returning!")
            return
        end
        if spawn == nil or spawn.ID() == 0 or spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
            break
        end

        if not is_casting() and (not has_target() or mq.TLO.Target.ID() ~= spawn.ID()) then
            -- XXX will happen for healers
            all_tellf("killSpawn WARN: i lost target, restoring to %d %s. Previous target was %s", spawn.ID(), spawn.Name(), mq.TLO.Target.Name())
            cmdf("/target id %d", spawn.ID())
        end

        doevents("dannet_chat")
        delay(1)

        local used = false
        if melee and botSettings.settings.assist.abilities ~= nil
        and spawn.Distance() < spawn.MaxRangeTo() and spawn.LineOfSight() then
            -- use melee abilities
            for v, abilityRow in pairs(botSettings.settings.assist.abilities) do
                if Assist.target == nil then
                    -- break inner loop if /backoff was called
                    log.Debug("killSpawn melee: i got called off, breaking inner loop")
                    break
                end

                if castSpellAbility(spawn, abilityRow) then
                    used = true
                    break
                end
            end
        end

        doevents("dannet_chat")
        delay(1)

        -- caster/hybrid assist.nukes
        if not used and botSettings.settings.assist.nukes ~= nil and not is_casting() then
            if botSettings.settings.assist.nukes[spellSet] ~= nil then
                for v, nukeRow in pairs(botSettings.settings.assist.nukes[spellSet]) do
                    log.Debug("Evaluating nuke %s", nukeRow)
                    if Assist.target == nil then
                        -- break inner loop if /backoff was called
                        log.Debug("killSpawn nukes: i got called off, breaking inner loop")
                        break
                    end

                    if castSpellAbility(spawn, nukeRow) then
                        break
                    end
                end
            else
                all_tellf("ERROR cannot nuke, have no spell set %s", spellSet)
            end
        end

        doevents("dannet_chat")
        delay(1)

        heal.processQueue()
    end

    if not is_brd() and is_casting() then
        cmd("/stopcast")
    end

    if Assist.target ~= nil then
        -- did not get called off during fight
        Assist.prepareForNextFight()
    end

    Assist.target = nil

    cmd("/attack off")
    cmd("/stick off")
end

return Assist
