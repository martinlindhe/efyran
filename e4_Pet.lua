local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("e4_BotSettings")
local PetSpells = require("e4_PetSpells")

local Pet = {}

-- summon my pet, returns true if spell was cast
function Pet.Summon()
    if botSettings.settings.pet == nil or is_sitting() then
        --print("wont summon pet. no spell in settings")
        return false
    end

    if have_pet() then
        --all_tellf("wont summon pet. i already have one!", mq.TLO.Me.Pet.Name())
        return false
    end

    if botSettings.settings.pet.auto ~= nil and not botSettings.settings.pet.auto then
        --print("wont summon pet. pet.auto is false")
        return false
    end

    local spellName = find_pet_spell()
    if spellName == nil then
        all_tellf("ERROR: Can't summon pet. No spell found.")
        return false
    end

    local spellConfig = parseSpellLine(spellName)

    local spell = get_spell(spellConfig.Name)
    if spell == nil then
        all_tellf("ERROR: Failed to lookup spell "..spellConfig.Name)
        return false
    end

    log.Info("Summoning L", spell.Level(), " pet with \ay"..spellName.."\ax.")

    if mq.TLO.Me.CurrentMana() < spell.Mana() then
        log.Warn("SKIP PET SUMMON, my mana ", mq.TLO.Me.PctMana(), " vs required ", spell.Mana())
        return false
    end

    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if getItemCountExact(spellConfig.Reagent) == 0 then
            all_tellf("SKIP PET SUMMON "..spellConfig.Name..", out of reagent "..spellConfig.Reagent)
            return false
        end
    end

    castSpellRaw(spell.RankName(), mq.TLO.Me.ID(), "-maxtries|3")
    delay(spell.MyCastTime(), function() return have_pet() end)

    if not have_pet() then
        all_tellf("ERROR: Failed to summon pet.")
        cmd("/beep 1")
        return false
    end

    Pet.ConfigureTaunt()
    return true
end

-- return spell line (string) with best available pet
function find_pet_spell()
    local pets = PetSpells[class_shortname()]
    if pets == nil then
        all_tellf("ERROR: No pets defined for class %s", mq.TLO.Me.Class.Name())
        return nil
    end

    local level = 1
    local name = ""
    for i,v in ipairs(pets) do
        if is_spell_in_book(v) then
            local spell = get_spell(v)
            -- print("Considering L",spell.Level(), " ", spell.RankName())
            if spell ~= nil and spell.Level() > level then
                level = spell.Level()
                name = spell.RankName()
            end
        else
            log.Info("Pet spell not in book: ", v)
        end
    end

    local reagent = ""
    if class_shortname() == "ENC" then
        reagent = "/Reagent|Tiny Dagger"
    elseif class_shortname() == "NEC" and not have_alt_ability("Deathly Pact") then
        reagent = "/Reagent|Bone Chips"
    elseif class_shortname() == "SHD" and not have_alt_ability("Deathly Pact") then
        reagent = "/Reagent|Bone Chips"
    elseif class_shortname() == "MAG" and not have_alt_ability("Elemental Pact") then
        reagent = "/Reagent|Malachite"
    end

    return name..reagent
end

-- returns true if spell was cast
function Pet.BuffMyPet()
    if botSettings.settings.pet == nil or botSettings.settings.pet.buffs == nil or not have_pet() or is_sitting() then
        --print("SKIP PET BUFFING: no pet buffs or I don't have pet.")
        return false
    end

    for key, buff in pairs(botSettings.settings.pet.buffs) do

        doevents()

        local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
        local spell = getSpellFromBuff(spellConfig.Name) -- XXX parse this once on script startup too, dont evaluate all the time !
        if spell == nil then
            all_tellf("Pet.BuffMyPet: getSpellFromBuff %s FAILED", buff)
            cmd("/beep 1")
            return false
        end

        local skip = false

        if mq.TLO.Me.Pet.Buff(spellConfig.Name)() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spellConfig.Name)).Duration.Ticks() > 4 then
            log.Debug("SKIP PET BUFFING %s, duration is %d ticks", spellConfig.Name, mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spellConfig.Name)).Duration.Ticks())
            skip = true
        end

        if spellConfig.MinMana ~= nil and mq.TLO.Me.PctMana() < spellConfig.MinMana then
            log.Debug("SKIP PET BUFFING, my mana %d vs required %d", mq.TLO.Me.PctMana(), spellConfig.MinMana)
            skip = true
        end
        if spellConfig.CheckFor ~= nil and mq.TLO.Me.Pet.Buff(spellConfig.CheckFor)() ~= nil then
            -- if we got this buff on, then skip.
            log.Debug("SKIP PET BUFFING %s, Pet have buff %s on them", spellConfig.Name, spellConfig.CheckFor)
            skip = true
        end
        if spellConfig.Reagent ~= nil and getItemCountExact(spellConfig.Reagent) == 0 then
            -- if we lack this item, then skip.
            log.Info("SKIP PET BUFFING %s, out of reagent %s", spellConfig.Name,  spellConfig.Reagent)
            skip = true
        end


        if have_item(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            log.Debug("SKIP PET BUFFING %s, item clicky is not ready", spellConfig.Name)
            skip = true
        end

        -- XXX on eqemu pet max shrunk is 1.0xxxxxx, on live it is (nec pet) 1.3541...
        if spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Pet.Height() <= 1.36 then
            log.Debug("will not shrink pet with %s because pet height is already %f", spellConfig.Name, mq.TLO.Me.Pet.Height())
            skip = true
        end

        if not skip then
            log.Debug("Refreshing pet buff %s", spellConfig.Name)
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
        cmd("/pet taunt on")
    else
        cmd("/pet taunt off")
    end
    cmd("/pet ghold on")
end

return Pet