local PetSpells = require("e4_PetSpells")

local Pet = {}

-- summon my pet, returns true if spell was cast
function Pet.Summon()
    if botSettings.settings.pet == nil then
        --print("wont summon pet. no spell in settings")
        return false
    end

    if have_pet() then
        --mq.cmd.dgtell("all wont summon pet. i already have one!", mq.TLO.Me.Pet.Name())
        return false
    end

    if botSettings.settings.pet.auto ~= nil and not botSettings.settings.pet.auto then
        --print("wont summon pet. pet.auto is false")
        return false
    end

    local spellName = find_pet_spell()
    if spellName == nil then
        mq.cmd.dgtell("all ERROR: Can't summon pet. No spell found.")
        return false
    end

    local spellConfig = parseSpellLine(spellName)

    local spell = get_spell(spellConfig.Name)
    if spell == nil then
        mq.cmd.dgtell("all ERROR: Failed to lookup spell ", spellConfig.Name)
        return false
    end

    print("Summoning L", spell.Level(), " pet with \ay"..spellName.."\ax.")

    if mq.TLO.Me.CurrentMana() < spell.Mana() then
        print("SKIP PET SUMMON, my mana ", mq.TLO.Me.PctMana(), " vs required ", spell.Mana())
        return false
    end

    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if mq.TLO.FindItemCount("=" .. spellConfig.Reagent)() == 0 then
            mq.cmd.dgtell("SKIP PET SUMMON ", spellConfig.Name, ", I'm out of reagent ", spellConfig.Reagent)
            return false
        end
    end

    castSpellRaw(spell.RankName(), mq.TLO.Me.ID(), "-maxtries|3")

    mq.delay(20000, function() return have_pet() end)

    if not have_pet() then
        mq.cmd.dgtell("all ERROR: Failed to summon pet.")
        mq.cmd.beep(1)
        return false
    end

    Pet.ConfigureTaunt()
    return true
end

-- return spell line (string) with best available pet
function find_pet_spell()
    local pets = PetSpells[mq.TLO.Me.Class.ShortName()]
    if pets == nil then
        mq.cmd.dgtell("all ERROR: No pets defined for class", mq.TLO.Me.Class.Name())
        return nil
    end

    local level = 1
    local name = ""
    for i,v in ipairs(pets) do
        if is_spell_in_book(v) then
            local spell = get_spell(v)
            -- print("Considering L",spell.Level(), " ", spell.RankName())
            if spell.Level() > level then
                level = spell.Level()
                name = spell.RankName()
            end
        else
            print("Pet spell not in book: ", v)
        end
    end

    reagent = ""
    if mq.TLO.Me.Class.ShortName() == "ENC" then
        reagent = "/Reagent|Tiny Dagger"
    elseif mq.TLO.Me.Class.ShortName() == "NEC" and not is_alt_ability("Deathly Pact") then
        -- NOTE: skip reagent with Deathly Pact AA
        reagent = "/Reagent|Bone Chips"
    elseif mq.TLO.Me.Class.ShortName() == "SHD" and not is_alt_ability("Deathly Pact") then
        -- NOTE: skip reagent with Deathly Pact AA
        reagent = "/Reagent|Bone Chips"
    elseif mq.TLO.Me.Class.ShortName() == "MAG" and not is_alt_ability("Elemental Pact") then
         -- NOTE: skip reagent with Elemental Pact AA
        reagent = "/Reagent|Malachite"
    end

    return name..reagent
end

-- returns true if spell was cast
function Pet.BuffMyPet()
    if botSettings.settings.pet == nil or botSettings.settings.pet.buffs == nil or not have_pet() then
        --print("SKIP PET BUFFING: no pet buffs or I don't have pet.")
        return false
    end

    for key, buff in pairs(botSettings.settings.pet.buffs) do

        mq.doevents()

        local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
        local spell = getSpellFromBuff(spellConfig.Name) -- XXX parse this once on script startup too, dont evaluate all the time !
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
                --print("SKIP PET BUFFING ", spellConfig.Name, ", Pet have buff ", spellConfig.CheckFor, " on them")
                skip = true
            end
        end
        if spellConfig.Reagent ~= nil then
            -- if we lack this item, then skip.
            if mq.TLO.FindItemCount("=" .. spellConfig.Reagent)() == 0 then
                --mq.cmd.dgtell("SKIP PET BUFFING ", spellConfig.Name, ", I'm out of reagent ", spellConfig.Reagent)
                skip = true
            end
        end

        -- XXX on eqemu pet max shrunk is 1.0xxxxxx, on live it is (nec pet) 1.3541...
        if spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Pet.Height() <= 1.36 then
            --print("will not shrink pet with ", spellConfig.Name, " because pet height is already ", mq.TLO.Me.Pet.Height())
            return false
        end

        if not skip then
            --print("refreshing pet buff ", spellConfig.Name)
            castSpell(spellConfig.Name, mq.TLO.Me.Pet.ID())
            return true
        end
    end
    return false
end

function Pet.ConfigureTaunt()
    if not have_pet() then
        return
    end
    --print("Configuring pet")
    if botSettings.settings.pet.taunt ~= nil and botSettings.settings.pet.taunt then
        mq.cmd.pet("taunt on")
    else
        mq.cmd.pet("taunt off")
    end
    mq.cmd.pet("ghold on")
end

return Pet