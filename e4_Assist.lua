follow = require('e4_Follow')

local Assist = {}

local assistTarget = nil -- the current assist target

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
    end)

end

function Assist.handleAssistCall(spawn)
    if botSettings.settings.assist.type == "Melee" then
        Assist.meleeLoop(spawn)
    else
        -- TODO ranged & caster assist ...
    end

    if mq.TLO.Me.Pet.ID() ~= 0 then
        mq.cmd.dgtell("all ATTACKING WITH MY PET", mq.TLO.Me.Pet.CleanName())
        mq.cmd.pet("attack", spawn.ID())
    end
end

-- stick and perform melee attacks
-- spawn is "userdata" type spawn
function Assist.meleeLoop(spawn)

    assistTarget = spawn

    print("meleeAssist ", spawn.Name)
    if spawn == nil then
        mq.cmd.dgtell("ERROR ASSSIST ON ",spawn.Name)
        return
    end

    mq.cmd.target("id", spawn.ID())
    mq.cmd.attack("on")

    follow.Pause()

    local meleeDistance = botSettings.settings.assist.melee_distance
    if meleeDistance == "auto" then
        meleeDistance = spawn.MaxRangeTo() * 0.75
        mq.cmd.dgtell("all calculated auto melee distance", meleeDistance)
    end

    --tprint(botSettings.settings.assist) -- XXX respect settings

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
        mq.cmd.dgtell("STICKING IN BACK TO ",spawn.Name, " ", stickArg)
        mq.cmd.stick(stickArg)
    end

    while true do
        if assistTarget == nil then
            -- break loop if /backoff was called
            print("meleeLoop: i got called off, breaking")
            break
        end
        if spawn.Type() == "Corpse" or spawn.Type() == "NULL" then
            break
        end

        print(spawn.Type, " assist spawn ", assistTarget)


        if mq.TLO.Target() == nil or mq.TLO.Target.ID() ~= spawn.ID() then
            mq.cmd.dgtell("all WARN: i lost target, breaking")
            break
        end

        if botSettings.settings.assist ~= nil and spawn.Distance() < spawn.MaxRangeTo() and spawn.LineOfSight() then
            -- use melee abilities
            print("evaluating assist.abilities")
            for v, abilityRow in pairs(botSettings.settings.assist.abilities) do
                local ability = parseSpellLine(abilityRow)
                --print("ability", abilityRow, ": ", ability.SpellName)

                local skip = false
                if ability.PctAggro ~= nil then
                    print("evaluating pctaggro ability", ability.SpellName)
                    if mq.TLO.Me.PctAggro() < tonumber(ability.PctAggro) then
                        --print("SKIP PctAggro ABILITY", ability.SpellName, "aggro", mq.TLO.Me.PctAggro(), "vs required", ability.PctAggro)
                        skip = true
                    end
                end

                if not skip and is_spell_ability_ready(ability.SpellName) then
                    castSpell(ability.SpellName, spawn.ID())
                    mq.delay(200)
                    break
                end
            end
        end

        mq.doevents()
        mq.delay(1)
    end

    assistTarget = nil

    mq.cmd.attack("off")
    mq.cmd.stick("off")
    follow.Resume()

end

-- returns true if name is ready to use (spell, aa, ability or combat ability)
function is_spell_ability_ready(name)

    if mq.TLO.Me.Class.ShortName() ~= "BRD" and mq.TLO.Me.Casting() then
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

    print("is_spell_ability_ready FALSE", name)
    return false
end

return Assist
