local Pet = {}

-- summon my pet, returns true if spell was cast
function Pet.Summon()
    if botSettings.settings.pet == nil or botSettings.settings.pet.spell == nil then
        --print("cant summon pet. no spell in settings")
        return false
    end

    if mq.TLO.Me.Pet.ID() ~= 0 then
        --mq.cmd.dgtell("all cant summon pet. i already have one!", mq.TLO.Me.Pet.Name())
        return false
    end

    if botSettings.settings.pet.auto ~= nil and not botSettings.settings.pet.auto then
        --print("wont summon pet. pet.auto is false")
        return false
    end

    print("Summoning pet with spell ", botSettings.settings.pet.spell)

    local spellConfig = parseSpellLine(botSettings.settings.pet.spell) -- XXX parse this once on script startup. dont evaluate all the time !!!

    if spellConfig.MinMana ~= nil then
        if mq.TLO.Me.PctMana() < tonumber(spellConfig.MinMana) then
            print("SKIP PET SUMMON, my mana ", mq.TLO.Me.PctMana, " vs required ", spellConfig.MinMana)
            return false
        end
    end

    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if mq.TLO.FindItemCount("=" .. spellConfig.Reagent)() == 0 then
            mq.cmd.dgtell("SKIP PET SUMMON ", spellConfig.SpellName, ", I'm out of reagent ", spellConfig.Reagent)
            return false
        end
    end

    castSpellRaw(spellConfig.SpellName, mq.TLO.Me.ID(), "-maxtries|3")

    mq.delay(20000, function()
        return mq.TLO.Me.Pet.ID() ~= 0
    end)

    Pet.ConfigureTaunt()
    return true
end

-- returns true if spell was cast
function Pet.BuffMyPet()
    if botSettings.settings.pet == nil or botSettings.settings.pet.buffs == nil or mq.TLO.Me.Pet.ID() == 0 then
        return false
    end

    for key, buff in pairs(botSettings.settings.pet.buffs) do

        local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
        local spell = getSpellFromBuff(spellConfig.SpellName) -- XXX parse this once on script startup too, dont evaluate all the time !
        if spell == nil then
            mq.cmd.dgtell("Pet.BuffMyPet: getSpellFromBuff ", buff, " FAILED")
            mq.cmd.beep(1)
            return false
        end

        local skip = false

        if mq.TLO.Me.Pet.Buff(spell.Name)() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.Name)).Duration.Ticks() > 4 then
            --print("SKIP PET BUFFING ", spell.Name, ", duration is ", mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.Name)).Duration.Ticks(), " ticks")
            skip = true
        end

        if spellConfig.MinMana ~= nil then
            if mq.TLO.Me.PctMana() < tonumber(spellConfig.MinMana) then
                --print("SKIP PET BUFFING, my mana ", mq.TLO.Me.PctMana, " vs required ", spellConfig.MinMana)
                skip = true
            end
        end
        if spellConfig.CheckFor ~= nil then
            -- if we got this buff on, then skip.
            if mq.TLO.Me.Pet.Buff(spellConfig.CheckFor)() ~= nil then
                --print("SKIP PET BUFFING ", spellConfig.SpellName, ", Pet have buff ", spellConfig.CheckFor, " on them")
                skip = true
            end
        end
        if spellConfig.Reagent ~= nil then
            -- if we lack this item, then skip.
            if mq.TLO.FindItemCount("=" .. spellConfig.Reagent)() == 0 then
                mq.cmd.dgtell("SKIP PET BUFFING ", spellConfig.SpellName, ", I'm out of reagent ", spellConfig.Reagent)
                skip = true
            end
        end

        if spellConfig.Shrink ~= nil and mq.TLO.Me.Pet.Height() <= 1.0 then
            --print("will not shrink pet with ", spellConfig.SpellName, " because pet height is already ", mq.TLO.Me.Pet.Height())
            return false
        end

        if not skip then
            print("Buffing my pet with ", spellConfig.SpellName)
            castSpellRaw(spellConfig.SpellName, mq.TLO.Me.Pet.ID(), "-maxtries|3")
            return true
        end
    end
    return false
end

-- XXX also call each time we zone...
function Pet.ConfigureTaunt()
    if mq.TLO.Me.Pet.ID() == 0 then
        return
    end
    print("configuring pet")
    if botSettings.settings.pet.taunt ~= nil and botSettings.settings.pet.taunt then
        mq.cmd.pet("taunt on")
    else
        mq.cmd.pet("taunt off")
    end
    mq.cmd.pet("ghold on")
end

return Pet