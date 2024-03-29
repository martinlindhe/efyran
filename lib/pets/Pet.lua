local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("lib/settings/BotSettings")
local PetSpells = require("lib/pets/PetSpells")

local Pet = {}

-- summon my pet, returns true if spell was cast
function Pet.Summon()
    if is_sitting() or is_moving() then
        --print("wont summon pet. no spell in settings")
        return false
    end
    if not is_mag() and not is_nec() and not is_bst() then
        return
    end

    if have_pet() then
        --all_tellf("wont summon pet. i already have one!", mq.TLO.Me.Pet.Name())
        return false
    end

    if botSettings.settings.pet ~= nil and botSettings.settings.pet.auto ~= nil and not botSettings.settings.pet.auto then
        --print("wont summon pet. pet.auto is false")
        return false
    end

    local spellName = find_pet_spell()
    if spellName == nil then
        log.Error("Can't summon pet. No spell found.")
        return false
    end

    local spellConfig = parseSpellLine(spellName)

    local spell = get_spell(spellConfig.Name)
    if spell == nil then
        all_tellf("ERROR: Failed to lookup spell "..spellConfig.Name)
        return false
    end

    log.Info("Summoning L%d pet with \ay%s\ax.", spell.Level(), spellName)

    if mq.TLO.Me.CurrentMana() < spell.Mana() then
        log.Warn("SKIP PET SUMMON, my mana ", mq.TLO.Me.PctMana(), " vs required ", spell.Mana())
        return false
    end

    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if inventory_item_count(spellConfig.Reagent) == 0 then
            all_tellf("SKIP PET SUMMON "..spellConfig.Name..", out of reagent "..spellConfig.Reagent)
            return false
        end
    end

    castSpellRaw(spell.RankName(), mq.TLO.Me.ID(), "-maxtries|3")
    delay(spell.CastTime(), function() return have_pet() end)

    if not have_pet() then
        all_tellf("ERROR: Failed to summon pet.")
        return false
    end

    Pet.ConfigureAfterZone()
    return true
end

-- return spell line (string) with best available pet
---@return string|nil
function find_pet_spell()
    local pets = PetSpells[class_shortname()]
    if pets == nil then
        all_tellf("ERROR: No pets defined for class %s", mq.TLO.Me.Class.Name())
        return nil
    end

    local level = 1
    local name = ""
    for i,v in ipairs(pets) do
        if have_spell(v) then
            local spell = get_spell(v)
            -- print("Considering L",spell.Level(), " ", spell.RankName())
            if spell ~= nil and spell.Level() > level then
                level = spell.Level()
                name = spell.RankName()
            end
        else
            log.Debug("Pet spell not in book: %s", v)
        end
    end
    if name == "" then
        return nil
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

local MIN_PET_BUFF_DURATION = 5 * 6000 -- 5 ticks, each tick is 6s, so 30s

-- returns true if spell was cast
function Pet.BuffMyPet()
    if botSettings.settings.pet == nil or botSettings.settings.pet.buffs == nil or not have_pet() or is_sitting() or is_moving() then
        --print("SKIP PET BUFFING: no pet buffs or I don't have pet.")
        return false
    end

    for key, buff in pairs(botSettings.settings.pet.buffs) do

        doevents()

        local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
        local spell = getSpellFromBuff(spellConfig.Name)
        if spell == nil then
            all_tellf("\arERROR Pet.BuffMyPet: getSpellFromBuff %s FAILED", buff)
            return false
        end

        local skip = false

        local spellName = spell.RankName()
        if spellName == nil then
            -- This is true for AA buffs, example MAG "Elemental Fury" AA
            spellName = spellConfig.Name
        end

        if mq.TLO.Me.Pet.Buff(spellName)() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spellName)).Duration.Ticks() > 4 then
            --log.Debug("SKIP PET BUFFING %s, duration is %d ticks", spellConfig.Name, mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spellConfig.Name)).Duration.Ticks())
            skip = true
        elseif spellConfig.MinMana ~= nil and mq.TLO.Me.PctMana() < spellConfig.MinMana then
            log.Debug("SKIP PET BUFFING, my mana %d vs required %d", mq.TLO.Me.PctMana(), spellConfig.MinMana)
            skip = true
        elseif spellConfig.CheckFor ~= nil and mq.TLO.Me.Pet.Buff(spellConfig.CheckFor)() ~= nil then
            -- if we got this buff on, then skip.
            --log.Debug("SKIP PET BUFFING %s, Pet have buff %s on them", spellConfig.Name, spellConfig.CheckFor)
            skip = true
        elseif spellConfig.Reagent ~= nil and inventory_item_count(spellConfig.Reagent) == 0 then
            -- if we lack this item, then skip.
            log.Info("SKIP PET BUFFING %s, out of reagent %s", spellConfig.Name,  spellConfig.Reagent)
            skip = true
        elseif have_item_inventory(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            -- XXX must also skip if pet has said buff ... clicky item is not the spell name !!!
            log.Debug("SKIP PET BUFFING %s, item clicky is not ready", spellConfig.Name)
            skip = true
        elseif spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Pet.Height() <= 1.36 then
            -- NOTE: 1.36 is a guestimate, seems to work on live & emu: on eqemu pet max shrunk is 0.625, on live it is (nec pet) 1.3541...
            --log.Debug("will not shrink pet with %s because pet height is already %f", spellConfig.Name, mq.TLO.Me.Pet.Height())
            skip = true
        end

        if not skip then
            log.Debug("Refreshing pet buff %s", spellConfig.Name)
            castSpellAbility(mq.TLO.Me.Pet.ID(), spellConfig.Name)
            return true
        end
    end
    return false
end

function Pet.ConfigureAfterZone()
    if not have_pet() or botSettings.settings.pet == nil then
        return
    end
    if botSettings.settings.pet.taunt ~= nil and botSettings.settings.pet.taunt then
        all_tellf("[+y+]PET TAUNT IS ON[+x+]")
        cmd("/squelch /pet taunt on")
    else
        cmd("/squelch /pet taunt off")
    end
    if have_alt_ability("Pet Discipline") then
        cmd("/squelch /pet ghold on")
    else
        cmd("/squelch /pet hold")
    end

    cmd("/squelch /pet follow")
end

return Pet
