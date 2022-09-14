local mq = require("mq")

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
                print("backing off existing target before assisting new")
                Assist.backoff()
            end
            --print("calling assist on spawn type ", spawn.Type)

            if is_orchestrator() then
                -- tell everyone else to attack
                cmd("/dgzexecute /assiston "..spawn.ID())
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
            -- XXX loop until /pbaeoff
            if spawn_count(nearbyPBAEilter) == 0 then
                cmd("/dgtell all Ending PBAE. No nearby mobs.")
                break
            end

            if not is_casting() then
                for k, spellRow in pairs(botSettings.settings.assist.pbae) do
                    local spellConfig = parseSpellLine(spellRow)

                    if is_spell_ready(spellConfig.Name) then
                        print("Casting PBAE spell ", spellConfig.Name)
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
        --cmd("/dgtell all backing off target ", assistTarget.Name())
        assistTarget = nil

        if have_pet() then
            print("Asking pet to back off")
            cmd("/pet back off")
        end
    else
        cmd("/dgtell all XXX ignoring backoff, no spawn known!")
    end
end

function Assist.handleAssistCall(spawn)
    if botSettings.settings == nil or botSettings.settings.assist == nil then
        cmd("/dgtell all WARNING: I have no assist settings")
        return
    end

    if have_pet() then
        print("Attacking with my pet ", mq.TLO.Me.Pet.CleanName())
        cmd("/pet attack "..spawn.ID())
    end

    Assist.killSpawn(spawn)

    Assist.prepareForNextFight()
end

-- called at end of each /assist call
function Assist.prepareForNextFight()

    print("Assist.prepareForNextFight")

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
                    cmd("/dgtell all I dont know spell/ability "..spellConfig.Summon)
                    cmd("/beep 1")
                end

                --print("summon prop", spell.Summon)

                if getItemCountExact(spellConfig.Name) == 0 and not is_casting() then
                    cmd("/dgtell all Summoning "..spellConfig.Name)
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

   --print("Assist.castSpellAbility ", row, ": ", spell.Name)

    if spell.PctAggro ~= nil then
        -- PctAggro skips cast if your aggro % is above threshold
        --print("evaluating pctaggro castSpellability", spell.Name)
        if mq.TLO.Me.PctAggro() < tonumber(spell.PctAggro) then
            print("SKIP PctAggro ", spell.Name, " aggro ", mq.TLO.Me.PctAggro(), " vs required ", spell.PctAggro)
            return false
        end
    end
    if spell.NoAggro ~= nil and spell.NoAggro then
        -- NoAggro skips cast if you are on top of aggro
        --print("evaluating noaggro castSpellability", spell.Name)
        if mq.TLO.Me.TargetOfTarget.ID() == mq.TLO.Me.ID() then
            --print("SKIP NoAggro ", spell.Name, " i have aggro")
            return false
        end
    end

    if spell.GoM ~= nil and spell.GoM then
        if have_song("Gift of Mana") then
            --cmd("/dgtell all SKIP GoM ", spell.Name, " i don't have GoM up")
            return false
        end
    end

    if spell.MinMana ~= nil and mq.TLO.Me.PctMana() < tonumber(spell.MinMana) then
        --cmd("/dgtell all SKIP MinMana ", spell.Name, ", ", mq.TLO.Me.PctMana(), " vs required " , spell.MinMana)
        return false
    end

    if spell.Summon ~= nil and getItemCountExact(spell.Name) == 0 then
        cmd("/dgtell all SKIP Summon "..spell.Name..", missing summoned item mid fight")
        return false
    end

    if spell.NoPet ~= nil and spell.NoPet and have_pet() then
        cmd("/dgtell all SKIP NoPet, i have a pet up")
        return false
    end

    --print("Assist.castSpellAbility preparing to cast ", spell.Name)

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

    print("Assist.killSpawn ", spawn.Name)
    if spawn == nil then
        cmd("/dgtell all ERROR: killSpawn called with nil")
        return
    end

    cmd("/target id "..spawn.ID())
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
            print("calculated auto melee distance", meleeDistance)
        end

        local stickArg

        if botSettings.settings.assist.stick_point == "Front" then
            stickArg = "hold front " .. meleeDistance .. " uw"
            print("STICKING IN FRONT TO ",spawn.Name, " ", stickArg)
            cmd("/stick "..stickArg)
        else
            cmd("/stick snaproll uw")
            delay(200, function()
                return mq.TLO.Stick.Behind() and mq.TLO.Stick.Stopped()
            end)
            stickArg = "hold moveback behind " .. meleeDistance .. " uw"
            print("STICKING IN BACK TO ",spawn.Name, " ", stickArg)
            cmd("/stick "..stickArg)
        end
    end


    while true do
        if assistTarget == nil then
            -- break outer loop if /backoff was called
            print("killSpawn: i got called off, breaking outer loop")
            break
        end
        if assistTarget.ID() ~= currentID then
            print("killSpawn: assist called on another mob, returning!")
            return
        end
        if spawn == nil or spawn.ID() == 0 or spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
            break
        end

        --print(spawn.Type, " assist spawn ", assistTarget)

        if not is_casting() and (not has_target() or mq.TLO.Target.ID() ~= spawn.ID()) then
            -- XXX will happen for healers
            cmd("/dgtell all killSpawn WARN: i lost target, restoring to "..spawn.ID().." "..spawn.Name())
            cmd("/target id "..spawn.ID())
        end

        local used = false
        if melee and botSettings.settings.assist.abilities ~= nil
        and spawn.Distance() < spawn.MaxRangeTo() and spawn.LineOfSight() then
            -- use melee abilities
            for v, abilityRow in pairs(botSettings.settings.assist.abilities) do
                if assistTarget == nil then
                    -- break inner loop if /backoff was called
                    print("killSpawn melee: i got called off, breaking inner loop")
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
                        print("killSpawn nukes: i got called off, breaking inner loop")
                        break
                    end

                    if Assist.castSpellAbility(spawn, nukeRow) then
                        break
                    end
                end
            else
                cmd("/dgtell all ERROR cannot nuke, have no spell set "..spellSet)
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
