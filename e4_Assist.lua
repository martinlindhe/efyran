local mq = require("mq")
local log = require("knightlinc/Write")

local Assist = {}

local assistTarget = nil -- the current assist target

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

    -- assist on mob until dead
    ---@param mobID integer
    mq.bind("/assiston", function(mobID)
        local spawn
        if is_orchestrator() then
            spawn = mq.TLO.Target
        else
            spawn = spawn_from_id(mobID)
        end
        if spawn == nil then
            return
        end
        if spawn.Type() ~= "PC" then
            if assistTarget ~= nil then
                log.Debug("Backing off existing target before assisting new")
                Assist.backoff()
            end
            log.Debug("Calling assist on spawn type %s", spawn.Type())

            if is_orchestrator() then
                -- tell everyone else to attack
                cmdf("/dgzexecute /assiston %d", spawn.ID())
            else
                -- we dont auto attack with main driver. XXX impl "/assiston /not|WAR" filter
                Assist.handleAssistCall(spawn)
            end
        end

    end)

    -- ends assist call
    mq.bind("/backoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /backoff")
        end
        Assist.backoff()
    end)

    mq.bind("/pbaeon", function()
        if is_orchestrator() then
            cmd("/dgzexecute /pbaeon")
        end

        if botSettings.settings.assist.pbae == nil then
            return
        end

        local nearbyPBAEilter = "npc radius 50 zradius 50 los"

        if spawn_count(nearbyPBAEilter) == 0 then
            cmd("/dgtell all Ending PBAE. No nearby mobs.")
            return
        end

        memorizePBAESpells()

        cmd("/dgtell all PBAE ON")
        while true do
            -- TODO: break this loop with /pbaeoff
            if spawn_count(nearbyPBAEilter) == 0 then
                cmd("/dgtell all Ending PBAE. No nearby mobs.")
                break
            end

            if not is_casting() then
                for k, spellRow in pairs(botSettings.settings.assist.pbae) do
                    local spellConfig = parseSpellLine(spellRow)

                    if is_spell_ready(spellConfig.Name) then
                        log.Info("Casting PBAE spell %s", spellConfig.Name)
                        local spellName = spellConfig.Name
                        if is_spell_in_book(spellConfig.Name) then
                            local spell = get_spell(spellConfig.Name)
                            if spell ~= nil then
                                spellName = spell.RankName()
                            end
                        end
                        castSpell(spellName, mq.TLO.Me.ID())
                    end

                    doevents()
                    delay(50)
                end
            end
        end

    end)

end


function Assist.backoff()
    if assistTarget ~= nil then
        log.Debug("Backing off target %s", assistTarget.Name())
        assistTarget = nil
        if have_pet() then
            log.Debug("Asking pet to back off")
            cmd("/pet back off")
        end
    end
end

function Assist.handleAssistCall(spawn)
    if botSettings.settings == nil or botSettings.settings.assist == nil then
        cmd("/dgtell all WARNING: I have no assist settings")
        return
    end

    if have_pet() then
        log.Debug("Attacking with my pet %s", mq.TLO.Me.Pet.CleanName())
        cmd("/pet attack %d", spawn.ID())
    end

    Assist.killSpawn(spawn)
    Assist.prepareForNextFight()
end

-- called at end of each /assist call
function Assist.prepareForNextFight()
    log.Debug("Assist.prepareForNextFight")
    Assist.summonNukeComponents()
end

-- summons missing component for nukes
-- eg: "Molten Orb/NoAggro/Summon|Summon: Molten Orb" (MAG)
function Assist.summonNukeComponents()
    if botSettings.settings.assist == nil or botSettings.settings.assist.nukes == nil then
        return
    end

    for idx, lines in pairs(botSettings.settings.assist.nukes) do
        if type(lines) == "string" then
            cmd("/dgtell all FATAL ERROR: settings.assist.nukes must be a map")
            cmd("/beep 1")
            delay(10000)
            return
        end
        for k, row in pairs(lines) do
            local spellConfig = parseSpellLine(row)
            if spellConfig.Summon ~= nil then
                --print("Checking summon comonents for ", spellConfig.Summon) -- XXX name is "Molten Orb".
                if not known_spell_ability(spellConfig.Summon) then
                    cmdf("/dgtell all I dont know spell/ability %s", spellConfig.Summon)
                    cmd("/beep 1")
                end

                --print("summon prop", spell.Summon)

                if getItemCountExact(spellConfig.Name) == 0 and not is_casting() then
                    cmdf("/dgtell all Summoning %s", spellConfig.Name)
                    castSpell(spellConfig.Summon, mq.TLO.Me.ID())

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

-- return true if spell/ability was cast
function Assist.castSpellAbility(spawn, row)

    local spell = parseSpellLine(row)

   log.Debug("Assist.castSpellAbility %s: %s", row, spell.Name)

    if spell.PctAggro ~= nil then
        -- PctAggro skips cast if your aggro % is above threshold
        if mq.TLO.Me.PctAggro() < spell.PctAggro then
            log.Info("SKIP PctAggro %s aggro %d vs required %d", spell.Name, mq.TLO.Me.PctAggro(), spell.PctAggro)
            return false
        end
    end
    if spell.NoAggro ~= nil and spell.NoAggro then
        -- NoAggro skips cast if you are on top of aggro
        if mq.TLO.Me.TargetOfTarget.ID() == mq.TLO.Me.ID() then
            --print("SKIP NoAggro ", spell.Name, " i have aggro")
            return false
        end
    end

    if spell.GoM ~= nil and spell.GoM and have_song("Gift of Mana") then
        return false
    end

    if spell.MinMana ~= nil and mq.TLO.Me.PctMana() < spell.MinMana then
        --cmd("/dgtell all SKIP MinMana ", spell.Name, ", ", mq.TLO.Me.PctMana(), " vs required " , spell.MinMana)
        return false
    end

    if spell.Summon ~= nil and getItemCountExact(spell.Name) == 0 then
        cmdf("/dgtell all SKIP Summon %s, missing summoned item mid-fight", spell.Name)
        return false
    end

    if spell.NoPet ~= nil and spell.NoPet and have_pet() then
        cmd("/dgtell all SKIP NoPet, i have a pet up")
        return false
    end

    log.Debug("Assist.castSpellAbility preparing to cast %s", spell.Name)

    if is_spell_ability_ready(spell.Name) then
        castSpell(spell.Name, spawn.ID())
        delay(200)
        return true
    end
    return false
end

-- stick and perform melee attacks
-- spawn is "userdata" type spawn
function Assist.killSpawn(spawn)

    assistTarget = spawn
    local currentID = spawn.ID()

    log.Debug("Assist.killSpawn %s", spawn.Name())
    if spawn == nil then
        cmd("/dgtell all ERROR: killSpawn called with nil")
        return
    end

    cmdf("/target id %d", spawn.ID())
    follow.Pause()

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "melee"

    if botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "ranged" then
        cmd("/dgtell all XXX TODO ADD RANGED ASSIST MODE")
        cmd("/beep 1")
        return
    end

    if melee then
        cmd("/attack on")

        local meleeDistance = botSettings.settings.assist.melee_distance
        if meleeDistance == "auto" then
            meleeDistance = spawn.MaxRangeTo() * 0.75
            log.Debug("Calculated auto melee distance %f", meleeDistance)
        end

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
        if assistTarget == nil then
            -- break outer loop if /backoff was called
            log.Debug("killSpawn: i got called off, breaking outer loop")
            break
        end
        if assistTarget.ID() ~= currentID then
            log.Debug("killSpawn: assist called on another mob, returning!")
            return
        end
        if spawn == nil or spawn.ID() == 0 or spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
            break
        end

        --print(spawn.Type, " assist spawn ", assistTarget)

        if not is_casting() and (not has_target() or mq.TLO.Target.ID() ~= spawn.ID()) then
            -- XXX will happen for healers
            cmdf("/dgtell all killSpawn WARN: i lost target, restoring to %d %s", spawn.ID(), spawn.Name())
            cmdf("/target id %d", spawn.ID())
        end

        local used = false
        if melee and botSettings.settings.assist.abilities ~= nil
        and spawn.Distance() < spawn.MaxRangeTo() and spawn.LineOfSight() then
            -- use melee abilities
            for v, abilityRow in pairs(botSettings.settings.assist.abilities) do
                if assistTarget == nil then
                    -- break inner loop if /backoff was called
                    log.Debug("killSpawn melee: i got called off, breaking inner loop")
                    break
                end

                if Assist.castSpellAbility(spawn, abilityRow) then
                    used = true
                    break
                end
            end
        end
        delay(1)

        -- caster/hybrid assist.nukes
        if not used and botSettings.settings.assist.nukes ~= nil and not is_casting() then
            if botSettings.settings.assist.nukes[spellSet] ~= nil then
                for v, nukeRow in pairs(botSettings.settings.assist.nukes[spellSet]) do
                    --print("evaluating nuke ", nukeRow)
                    if assistTarget == nil then
                        -- break inner loop if /backoff was called
                        log.Debug("killSpawn nukes: i got called off, breaking inner loop")
                        break
                    end

                    if Assist.castSpellAbility(spawn, nukeRow) then
                        break
                    end
                end
            else
                cmdf("/dgtell all ERROR cannot nuke, have no spell set %s", spellSet)
            end
        end

        doevents()
        delay(1)

        heal.processQueue()
    end

    if not is_brd() and is_casting() then
        cmd("/stopcast")
    end

    if assistTarget ~= nil then
        -- did not get called off during fight
        Assist.prepareForNextFight()
    end

    assistTarget = nil

    cmd("/attack off")
    cmd("/stick off")
    follow.Resume()
end

return Assist
