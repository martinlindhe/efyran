local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("e4_BotSettings")

local MIN_BUFF_DURATION = 6 * 6000 -- 6 ticks, each tick is 6s

function queryBot(peer, q)
    local fullQuery = peer .. ' -q ' .. q
    cmdf("/dquery %s", fullQuery)
    delay(1000, function()
        local state = mq.TLO.DanNet(peer).Query(q).Received()
        --print("delay ", peer, " q", q, state)
        if state == nil then
            return false
        end
        return state > 0
    end)

    local res = mq.TLO.DanNet.Q()
    --print("  bot query ",q, " == ", res)
    return res
end

-- refreshes buff on self or another bot, returns true if buff was cast
function refreshBuff(buffItem, spawn)

    --print("refreshBuff ", buffItem, ", target Name:", spawn.CleanName())

    if spawn.Type() ~= "PC" and spawn.Type() ~= "Pet" then
        log.Info("Will not buff %s %s: %s ", spawn.Type(), spawn.Name(), spawn.CleanName())
        if spawn.Type() ~= "Corpse" then
            all_tellf("WILL NOT BUFF %s: %s", spawn.Type(), spawn.CleanName())
            cmd("/beep 1")
        end
        return false
    end

    local spawnID = spawn.ID()

    if not spellConfigAllowsCasting(buffItem, spawn) then
        --print("wont allow casting ", buffItem)
        return false
    end

    local spellConfig = parseSpellLine(buffItem) -- XXX parse this once on script startup. dont evaluate all the time !!!

    local spell = getSpellFromBuff(spellConfig.Name) -- XXX parse this once on script startup too, dont evaluate all the time !
    if spell == nil then
        all_tellf("refreshBuff: getSpellFromBuff %s FAILED", buffItem)
        cmd("/beep 1")
        return false
    end

    local spellName = spellConfig.Name
    if is_spell_in_book(spellConfig.Name) then
        spellName = spell.RankName()
    end

    -- only refresh fading & missing buffs
    if mq.TLO.Me.ID() == spawn.ID() then
        -- IMPORTANT: on live, f2p restricts all spells to rank 1, so we need to look for both forms
        if have_buff(spell.RankName()) and mq.TLO.Me.Buff(spell.RankName()).Duration() >= MIN_BUFF_DURATION then
            --print("target have ranked buff with remaining ticks:", mq.TLO.Me.Buff(spell.RankName()).Duration.Ticks())
            return false
        end
        if have_buff(spell.Name()) and mq.TLO.Me.Buff(spell.Name()).Duration() >= MIN_BUFF_DURATION then
            --print("target have buff with remaining ticks:", mq.TLO.Me.Buff(spell.Name()).Duration.Ticks())
            return false
        end

        if is_spell_in_book(spellName) and not spell.Stacks() then
            all_tellf("ERROR cannot selfbuff with %s (dont stack with current buffs)", spellName)
            return false
        end
    elseif spawn.Type() == "Pet" and spawn.ID() == mq.TLO.Me.Pet.ID() then
        -- IMPORTANT: on live, f2p restricts all spells to rank 1, so we need to look for both forms

        if mq.TLO.Me.Pet.Buff(spell.RankName())() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.RankName())).Duration() >= MIN_BUFF_DURATION then
            print("refreshBuff: SKIP PET BUFFING ", spell.RankName(), ", duration is ", mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.RankName())).Duration() / 1000, " sec")
            return false
        end

        if mq.TLO.Me.Pet.Buff(spell.Name())() ~= nil and mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.Name())).Duration() >= MIN_BUFF_DURATION then
            print("refreshBuff: SKIP PET BUFFING ", spell.Name(), ", duration is ", mq.TLO.Me.Pet.Buff(mq.TLO.Me.Pet.Buff(spell.Name())).Duration() / 1000, " sec")
            return false
        end
        if is_spell_in_book(spellName) and spell.StacksPet() then
            --all_tellf("ERROR cannot buff pet with %s (dont stack with current buffs)", spellName)
            return false
        end
    else
        all_tellf("FATAL ERROR refreshBuff called with invalid spawn %s", spawn.Name())
        return
    end

    if not is_spell_ability_ready(spellName) and is_spell_in_book(spellName) and not is_memorized(spellName) then
        local gem = 5
        if spellConfig.Gem ~= nil then
            gem = spellConfig.Gem
        end
        --print("attempting to memorize ", spellName .. " ... GEM ", gem)
        cmdf('/memorize "%s" %d', spellName, gem)
        delay(3000) -- XXX 3s
    end

    if not have_item(spellConfig.Name) and mq.TLO.Me.CurrentMana() < spell.Mana() then
        log.Info("SKIPPING BUFF, not enough mana. Have %d, need %d", mq.TLO.Me.CurrentMana(), spell.Mana())
        return false
    end

    if have_alt_ability(spellName) and not is_alt_ability_ready(spellName) then
        --print("SKIPPING BUFF, AA ", spellName, " is not ready")
        return false
    end

    local pretty = spellName
    if have_item(spellConfig.Name) then
        local item = find_item(spellConfig.Name)
        if item ~= nil then
            pretty = item.ItemLink("CLICKABLE")()
        end
    end

    if spawn.Type() == "Pet" then
        log.Debug("Buffing \agmy pet %s\ax with \ay%s\ax.", spawn.CleanName(), pretty)
    else
        log.Debug("Buffing \agmyself\ax with \ay%s\ax.", pretty)
        if spell.TargetType() == "Self" then
            -- don't target myself on self-buffs
            spawnID = nil
        end
    end

    castSpell(spellName, spawnID)
    return true
end

-- XXX refactor more. need to be usable with pet buffs too (should take a spawn id instead of bot name, and then derive if its a bot in zone or a pet)
---@param spawn spawn
---@return boolean
function spellConfigAllowsCasting(buffItem, spawn)

    if spawn == nil then
        all_tellf("ERROR: spellConfigAllowsCasting called with nil spawn for %s", buffItem)
        cmd("/beep 1")
        return false
    end

    local spellConfig = parseSpellLine(buffItem)

    local spell = getSpellFromBuff(spellConfig.Name)
    if spell == nil then
        --eg missing clicky while naked
        --cmd("/dgtell all spellConfigAllowsCasting: getSpellFromBuff ", buffItem, " FAILED. Query = '"..spellConfig.Name.."'")
        return false
    end

    --print("spellConfigAllowsCasting ", buffItem, " ", spawn.Name(), ", spell ", spell.Name())

    -- AERange is used for group spells
    if spell.TargetType() == "Group v2" then
        if spawn.Distance() >= spell.AERange() then
            print("cant rebuff (",spell.TargetType(),"), toon too far away: ", buffItem, " ", spawn.CleanName(), " spell range = ", spell.Range(), ", spawn distance = ", spawn.Distance())
            return false
        end
    else
        if spell.TargetType() ~= "Self" and spawn.Distance() >= spell.Range() then
            print("cant rebuff (",spell.TargetType(),"), toon too far away: ", buffItem, " ", spawn.CleanName(), " spell range = ", spell.Range(), ", spawn distance = ", spawn.Distance())
            return false
        end
    end

    if spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Height() <= 2.04 then
        --print("will not shrink myself with ", spellConfig.Name, " because my height is already ", mq.TLO.Me.Height())
        return false
    end

    if spellConfig.MinMana ~= nil then
        if mq.TLO.Me.PctMana() < spellConfig.MinMana then
            print("SKIP BUFFING, my mana ", mq.TLO.Me.PctMana, " vs required ", spellConfig.MinMana)
            return false
        end
    end
    if spellConfig.CheckFor ~= nil then
        -- if we got this buff on, then skip.
        if mq.TLO.Me() ~= spawn.CleanName() then
            -- XXX LATER: rework to use /dobserve
            local res = queryBot(spawn.CleanName(), 'Me.Buff["' .. spellConfig.CheckFor .. '"].ID')

            if res ~= "NULL" then
                print("SKIP BUFFING of ", spellConfig.Name, ", target bot ", spawn.CleanName(), " has ", spellConfig.CheckFor)
                return false
            end
        else
            if have_buff(spellConfig.CheckFor) or have_song(spellConfig.CheckFor) then
                --print("SKIP BUFFING ", spellConfig.Name, ", I have buff ", spellConfig.CheckFor, " on me")
                return false
            end
        end
    end
    if spellConfig.Reagent ~= nil then
        -- if we lack this item, then skip.
        if getItemCountExact(spellConfig.Reagent) == 0 then
            all_tellf("SKIP BUFFING %s , out of reagent %s", spellConfig.Name, spellConfig.Reagent)
            return false
        end
    end

    return true
end

-- helper for casting spell, clicky, AA, combat ability
-- XXX dont use directly, use castSpellAbility() instead.
---@param name string spell name
---@param spawnId integer|nil
function castSpell(name, spawnId)

    if have_combat_ability(name) then
        --log.Debug("castSpell DISC: %s", name)
        cmdf("/disc %s", name)          -- NOTE: /disc argument must NOT use quotes
    elseif have_ability(name) then
        --log.Debug("castSpell ABILITY: %s", name)
        cmdf('/doability "%s"', name)   -- NOTE: /doability argument must use quotes
    else
        --log.Debug("castSpell ITEM/SPELL/AA: %s", name)

        if is_brd() and is_casting() then
            cmd("/twist stop")
            delay(100)
        end

        if not is_spell_in_book(name) and have_item(name) then
            -- Item and spell examples: Molten Orb (MAG)
            if not is_item_clicky_ready(name) then
                all_tellf("ERROR: castSpell was called with item clicky not ready to cast (unlikely): %s", name)
                return
            end
            name = name.."|item"
        end

        castSpellRaw(name, spawnId, "-maxtries|3")

        if is_brd() then
            if have_item(name) then
                -- item click
                local item = find_item(name)
                if item ~= nil then
                    log.Info("Item click sleep, %d + %d", item.Clicky.CastTime(), item.Clicky.Spell.RecastTime())
                    delay(item.Clicky.CastTime() + item.Clicky.Spell.RecastTime() + 1500)
                end
            else
                -- spell / AA
                local spell = get_spell(name)
                if spell ~= nil and spell.Name() ~= nil then
                    local mycast = 0
                    if spell.MyCastTime() ~= nil then
                        mycast = spell.MyCastTime()
                    end
                    local recast = 0
                    if spell.RecastTime() ~= nil then
                        recast = spell.RecastTime()
                    end
                    log.Info("Spell sleep for '%s', my cast time: %d, recast time %d", spell.Name(), mycast, recast)
                    local sleepTime = mycast + recast
                    delay(sleepTime)
                end
            end
            log.Debug("BARD in castSpell %s .- SO I RESUME TWIST!", name)
            cmd("/twist start")
        end

    end
end

---@param name string spell name
---@param spawnId integer|nil
function castSpellRaw(name, spawnId, extraArgs)
    if extraArgs == nil then
        extraArgs = ""
    end
    if spawnId == nil then
        --log.Debug("-- castSpellRaw %s, extraArgs %s", name, extraArgs)
        cmdf('/casting "%s"%s', name, extraArgs)
    else
        --log.Debug("-- castSpellRaw %s, spawnId %d, extraArgs %s", name, spawnId, extraArgs)
        cmdf('/casting "%s" -targetid|%d%s', name, spawnId, extraArgs)
    end
end

-- returns datatype spell or nil if not found
function getSpellFromBuff(name)

    if have_item(name) then
        return mq.TLO.FindItem(name).Clicky.Spell
    elseif is_spell_in_book(name) then
        return get_spell(name)
    elseif have_alt_ability(name) then
        return mq.TLO.Me.AltAbility(name).Spell
    elseif have_combat_ability(name) then
        return mq.TLO.Me.CombatAbility(mq.TLO.Me.CombatAbility(name))
    else
        all_tellf("getSpellFromBuff ERROR: can't find buff %s", name)
        return nil
    end
end

-- Memorizes all spells listed in character settings.gems in their correct position.
function memorizeListedSpells()
    if botSettings.settings.gems == nil then
        return
    end
    for spellRow, gem in pairs(botSettings.settings.gems) do
        memorize_spell(spellRow, gem)
    end
end

-- Memorizes all spells listed in character settings.assist.pbae in their correct position.
function memorizePBAESpells()
    if botSettings.settings.assist.pbae == nil then
        log.Debug("no settings.assist.pbae configured")
        return
    end
    for k, spellRow in pairs(botSettings.settings.assist.pbae) do
        memorize_spell(spellRow)
    end
end

-- Returns nil on error
---@param spellRow string Example: "War March of Muram/Gem|4"
---@param defaultGem integer|nil Use nil for the default gem 5
--@return integer|nil
function memorize_spell(spellRow, defaultGem)
    local o = parseSpellLine(spellRow) -- XXX parse this once on script startup. dont evaluate all the time !!!

    if not is_spell_in_book(o.Name) then
        all_tellf("ERROR don't know spell/song %s", o.Name)
        mq.cmd("/beep 1")
        return nil
    end

    local gem = defaultGem
    if o["Gem"] ~= nil then
        gem = o["Gem"]
    elseif botSettings.settings.gems[o.Name] ~= nil then
        gem = botSettings.settings.gems[o.Name]
    elseif gem == nil then
        all_tellf("\arWARN\ax: Spell/song lacks gems default slot or Gem|n argument: %s", spellRow)
        gem = 5
    end

    -- make sure that spell is memorized the required gem, else scribe it
    local nameWithRank = mq.TLO.Spell(o.Name).RankName()
    if mq.TLO.Me.Gem(gem).Name() ~= nameWithRank then
        log.Info("Memorizing spell/song in gem %d. Want %s, have %s", gem, nameWithRank, mq.TLO.Me.Gem(gem).Name())
        mq.cmdf('/memorize "%s" %d', nameWithRank, gem)
        mq.delay(200)
        mq.delay(5000, function()
            return not window_open("SpellBookWnd")
        end)
        mq.delay(200)
    end

    return gem
end
