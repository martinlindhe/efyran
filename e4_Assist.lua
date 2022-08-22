follow = require('e4_Follow')

local Assist = {}

local assistTarget = nil -- the current assist target

local spellSet = "main" -- the current spell set. XXX impl switching it

-- return spawn or nil
function getSpawn(spawnID)
    local spawn = mq.TLO.Spawn("id " .. spawnID)
    if tostring(spawn) == "NULL" then
        return nil
    end
    return spawn
end


function Assist.Init()

    if botSettings.settings.assist ~= nil then
        if botSettings.settings.assist.melee_distance == nil then
            botSettings.settings.assist.melee_distance = "auto"
        end
        botSettings.settings.assist.melee_distance = string.lower(botSettings.settings.assist.melee_distance)
        if botSettings.settings.assist.melee_distance == "maxmelee" then
            botSettings.settings.assist.melee_distance = "auto"
        end

        if botSettings.settings.assist.type ~= nil then
            botSettings.settings.assist.type = string.lower(botSettings.settings.assist.type)
        end
    end

    -- assist on mob until dead
    mq.bind("/assiston", function(mobID)

        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

        local spawn
        if orchestrator then
            spawn = mq.TLO.Target
        else
            spawn = getSpawn(mobID)
        end

        if spawn.Type() ~= "PC" then
            if assistTarget ~= nil then
                print("backing off existing target before assisting new")
                Assist.backoff()
            end
            print("calling assist on spawn type ", spawn.Type)

            if orchestrator then
                -- tell everyone else to attack
                mq.cmd.dgze("/assiston", spawn.ID())
            else
                -- we dont auto attack with main driver. XXX impl "/assiston /not|WAR" filter
                Assist.handleAssistCall(spawn)
            end
        end

    end)

    -- ends assist call
    mq.bind("/backoff", function()
        local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
        if orchestrator then
            mq.cmd.dgzexecute("/backoff")
        end

        Assist.backoff()
    end)

end

function Assist.backoff()
    if assistTarget ~= nil then
        mq.cmd.dgtell("backing off target ", assistTarget.Name())
        assistTarget = nil
    else
        mq.cmd.dgtell("all XXX ignoring backoff, no spawn known!")
    end

    if mq.TLO.Me.Pet.ID() ~= 0 then
        mq.cmd.dgtell("all PET BACKING OFF")
        mq.cmd.pet("back off")
    end
end

function Assist.handleAssistCall(spawn)
    if botSettings.settings == nil or botSettings.settings.assist == nil then
        mq.cmd.dgtell("all WARNING: I have no assist settings")
        return
    end

    Assist.killSpawn(spawn)

    if mq.TLO.Me.Pet.ID() ~= 0 then
        mq.cmd.dgtell("all ATTACKING WITH MY PET", mq.TLO.Me.Pet.CleanName())
        mq.cmd.pet("attack", spawn.ID())
    end
end

-- return true if spell/ability was cast
function Assist.castSpellAbility(spawn, row)

    local spell = parseSpellLine(row)

   --print("Assist.castSpellAbility", row, ": ", spell.Name)

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

    --print("Assist.castSpellAbility preparing to cast ", spell.Name)

    if is_spell_ability_ready(spell.Name) then
        castSpell(spell.Name, spawn.ID())
        mq.delay(200)
        return true
    end
    return false
end

-- stick and perform melee attacks
-- spawn is "userdata" type spawn
function Assist.killSpawn(spawn)

    assistTarget = spawn

    print("Assist.killSpawn ", spawn.Name)
    if spawn == nil then
        mq.cmd.dgtell("ERROR ASSSIST ON ",spawn.Name)
        return
    end

    mq.cmd.target("id", spawn.ID())
    follow.Pause()

    local melee = botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "melee"

    if botSettings.settings.assist ~= nil and botSettings.settings.assist.type ~= nil and botSettings.settings.assist.type == "ranged" then
        mq.cmd.dgtell("all XXX TODO ADD RANGED ASSIST MODE")
        mq.cmd.beep(1)
        return
    end

    if melee then
        mq.cmd.attack("on")

        local meleeDistance = botSettings.settings.assist.melee_distance
        if meleeDistance == "auto" then
            meleeDistance = spawn.MaxRangeTo() * 0.75
            print("calculated auto melee distance", meleeDistance)
        end

        local stickArg

        if botSettings.settings.assist.stick_point == "Front" then
            stickArg = "hold front " .. meleeDistance .. " uw"
            mq.cmd.dgtell("STICKING IN FRONT TO ",spawn.Name, " ", stickArg)
            mq.cmd.stick(stickArg)
        else
            mq.cmd.stick("snaproll uw")
            mq.delay(20, function()
                return mq.TLO.Stick.Behind and mq.TLO.Stick.Stopped
            end)
            stickArg = "hold moveback behind " .. meleeDistance .. " uw"
            print("STICKING IN BACK TO ",spawn.Name, " ", stickArg)
            mq.cmd.stick(stickArg)
        end
    end


    while true do
        mq.doevents()
        if assistTarget == nil then
            -- break outer loop if /backoff was called
            print("meleeLoop: i got called off, breaking outer loop")
            break
        end
        if spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
            break
        end

        --print(spawn.Type, " assist spawn ", assistTarget)

        if mq.TLO.Target() == nil or mq.TLO.Target.ID() ~= spawn.ID() then
            -- XXX will happen for healer+nuker setups (DRU,RNG,SHM)
            mq.cmd.dgtell("all WARN: i lost target, breaking")
            break
        end

        if melee and spawn.Distance() < spawn.MaxRangeTo() and spawn.LineOfSight() then
            -- use melee abilities
            for v, abilityRow in pairs(botSettings.settings.assist.abilities) do
                mq.doevents()
                if assistTarget == nil then
                    -- break inner loop if /backoff was called
                    print("melee: i got called off, breaking inner loop")
                    break
                end

                if Assist.castSpellAbility(spawn, abilityRow) then
                    break
                end
            end
        end

        -- caster/hybrid assist.nukes
        if botSettings.settings.assist.nukes ~= nil and mq.TLO.Me.Casting() == nil then
            local nukes = botSettings.settings.assist.nukes[spellSet]
            --print("evaluating nukes ...", nukes)
            if nukes ~= nil then
                for v, nukeRow in pairs(nukes) do
                    mq.doevents()
                    if assistTarget == nil then
                        -- break inner loop if /backoff was called
                        print("nukes: i got called off, breaking inner loop")
                        break
                    end

                    if Assist.castSpellAbility(spawn, nukeRow) then
                        break
                    end
                end
            else
                mq.cmd.dgtell("all ERROR cannot nuke, have no spell set", spellSet)
            end
        end

        mq.delay(1)
    end

    if mq.TLO.Me.Class.ShortName() ~= "BRD" and mq.TLO.Me.Casting() ~= nil then
        mq.cmd.dgtell("all DEBUG abort cast mob dead ", mq.TLO.Me.Casting.Name)
        mq.cmd.stopcast()
    end

    assistTarget = nil

    mq.cmd.attack("off")
    mq.cmd.stick("off")
    follow.Resume()
end

-- returns true if name is ready to use (spell, aa, ability or combat ability)
function is_spell_ability_ready(name)

    if mq.TLO.Me.Class.ShortName() ~= "BRD" and mq.TLO.Me.Casting() ~= nil then
        return false
    end

    if mq.TLO.Me.AltAbilityReady(name)()  then
        --print("is_spell_ability_ready aa TRUE", name)
        return true
    end

    -- spell: is spell scribed, is cooldown 0, and not currently casting?
    if mq.TLO.Me.Gem(name)() ~= nil and mq.TLO.Me.SpellReady(name)() then
        --print("is_spell_ability_ready spell TRUE", name)
        return true
    end

    -- combat ability
    if mq.TLO.Me.CombatAbilityReady(name)() then
        --print("is_spell_ability_ready combat ability TRUE", name)
        return true
    end

    -- ability (Kick)
    if mq.TLO.Me.AbilityReady(name)() then
        --print("is_spell_ability_ready ability TRUE", name)
        return true
    end

    -- item clicky
    if mq.TLO.FindItem(name).Clicky() ~= nil and mq.TLO.FindItem(name).Timer.Ticks() == 0 then
        --print("is_spell_ability_ready item TRUE", name)
        return true
    end

    return false
end

return Assist
