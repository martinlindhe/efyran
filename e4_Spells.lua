local mq = require("mq")
local log = require("knightlinc/Write")

local botSettings = require("e4_BotSettings")
local aliases = require("settings/Spell Aliases")
local groupBuffs = require("e4_GroupBuffs")

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
        use_combat_ability(name)
    elseif have_ability(name) then
        use_ability(name)
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
    local exe = string.format('/casting "%s"', name)
    if spawnId ~= nil then
        exe = exe .. string.format(" -targetid|%d", spawnId)
    end
    if extraArgs ~= nil then
        exe = exe .. " " .. extraArgs
    end
    log.Debug("-- castSpellRaw: %s", exe)
    cmdf(exe)
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
        log.Error("getSpellFromBuff: can't find %s", name)
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
        cmd("/beep 1")
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

---@param spellName string
function cast_mgb_spell(spellName)
    if not is_alt_ability_ready("Mass Group Buff") then
        all_tellf("\arMass Group Buff is not available...\ax Ready in %s", mq.TLO.Me.AltAbilityTimer("Mass Group Buff").TimeHMS())
        return
    end

    if not have_alt_ability(spellName) and not is_spell_in_book(spellName) then
        all_tellf("\ar%s is not available...", spellName)
        return
    end

    use_alt_ability("Mass Group Buff", nil)
    delay(1000)
    all_tellf("\agMGB %s inc\ax...", spellName)
    if have_alt_ability(spellName) then
        use_alt_ability(spellName)
    else
        castSpellRaw(spellName, nil, "gem5 -maxtries|3")
    end
end

-- XXX Can one ae bloodthirst, the other a cry of chaos and they stack?
local aeWarCryCombatAbilities = {
    "Bloodthirst",                  -- L70, slot 3: Add Defensive Proc: Bloodthirst Effect (30% dmg mod)
    "Ancient: Cry of Chaos",        -- L65, slot 2: Hundred Hands Effect, slot 11: 60 atk
    "Battle Cry of the Mastruq",    -- L65, slot 2: Hundred Hands Effect, slot 11: 50 atk
    "War Cry of Dravel",            -- L64, slot 2: Hundred Hands Effect, slot 11: 40 atk
    "Battle Cry of Dravel",         -- L57, slot 2: Hundred Hands Effect, slot 11: 30 atk
    "War Cry",                      -- L50, slot 2: Hundred Hands Effect, slot 11: 20 atk
    "Battle Cry",                   -- L30, slot 2: Hundred Hands Effect, slot 11: 10 atk
}

-- Use the best available AE berserker war cry combat ability
function cast_ae_cry()
    if not have_alt_ability("Cry of Battle") then
        all_tellf("\arCry of Battle is not available...\ax Need to purchase AA")
        return
    end
    if not is_alt_ability_ready("Cry of Battle") then
        all_tellf("\arCry of Battle is not available...\ax Ready in %s", mq.TLO.Me.AltAbilityTimer("Cry of Battle").TimeHMS())
        return
    end

    for idx, name in pairs(aeWarCryCombatAbilities) do
        if have_combat_ability(name) then
            use_alt_ability("Cry of Battle", nil)
            delay(1000)
            all_tellf("\agMGB %s inc\ax...", name)
            use_combat_ability(name)
            return
        end
    end

    all_tellf("\arNo war cry ability available...\ax Need to purchase discs")
end

function cast_evac_spell()
    -- DRU/WIZ L59 Exodus AA (instant cast)
    -- Hastened Exodus reduces recast time by 10% per rank
    -- Rank 0: recast time 72 min
    -- Rank 4: recast time XX min
    if is_ability_ready("Exodus") then
        use_alt_ability("Exodus")
        return
    end

    if class_shortname() == "DRU" then
        -- L57 Succor (9s cast, cost 100 mana)
        if is_spell_in_book("Succor") then
            castSpellRaw("Succor", nil, "gem5 -maxtries|3")
            return
        end

        -- L18 Lesser Succor (10.5s cast, cost 150 mana)
        if is_spell_in_book("Lesser Succor") then
            castSpellRaw("Lesser Succor", nil, "gem5 -maxtries|3")
            return
        end
        log.Error("I have no evac spell!")
    elseif class_shortname() == "WIZ" then
        -- L57 Evacuate (9s cast, cost 100 mana)
        if is_spell_in_book("Evacuate") then
            castSpellRaw("Evacuate", nil, "gem5 -maxtries|3")
            return
        end

        -- L18 Lesser Evacuate (10.5s cast, cost 150 mana)
        if is_spell_in_book("Lesser Evacuate") then
            castSpellRaw("Lesser Evacuate", nil, "gem5 -maxtries|3")
            return
        end
        log.Error("I have no evac spell!")
    end
end

function click_nearby_door()
    -- XXX check if door within X radius
    cmd("/doortarget")
    log.Info("CLICKING NEARBY DOOR %s, id %d", mq.TLO.DoorTarget.Name(), mq.TLO.DoorTarget.ID())

    unflood_delay()
    cmd("/click left door")
end

function cast_radiant_cure()
    if not have_alt_ability("Radiant Cure") then
        return
    end
    if is_alt_ability_ready("Radiant Cure") then
        all_tellf("Radiant Cure inc ...")
        use_alt_ability("Radiant Cure")
    else
        all_tellf("Radiant Cure is ready in %s", mq.TLO.Me.AltAbilityTimer("Radiant Cure").TimeHMS())
    end
end

-- Perform the "/portto <name>" command
---@param name string
function cast_port_to(name)
    local spellName
    if class_shortname() == "WIZ" then
        spellName = aliases.WIZ["port " .. name]
    elseif class_shortname() == "DRU" then
        spellName = aliases.DRU["port " .. name]
    else
        return
    end

    all_tellf("Porting to %s (%s)", name, spellName)
    unflood_delay()

    if spellName == nil then
        all_tellf("ERROR: no such port %s", name)
    end

    wait_until_not_casting()
    castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
    wait_until_not_casting()
end

function cast_group_heal()
    for idx, groupHeal in pairs(groupBuffs.GroupHealSpells) do
        if is_spell_ready(groupHeal) then
            all_tellf("Casting group heal \ag%s\ax ...", groupHeal)
            castSpellRaw(groupHeal, nil)
            return
        end
    end
end

function shrink_group()
    -- find the shrink clicky/spell if we got one
    local shrinkClicky = nil
    local spellConfig
    for key, buff in pairs(botSettings.settings.self_buffs) do
        spellConfig = parseSpellLine(buff)
        if spellConfig.Shrink ~= nil and spellConfig.Shrink then
            shrinkClicky = buff
            break
        end
    end

    if shrinkClicky == nil or not in_group() then
        log.Error("No Shrink clicky declared in self_buffs, giving up.")
        return
    end

    local item = find_item(spellConfig.Name)
    if item == nil then
        all_tellf("\arERROR\ax: Did not find Shrink clicky in inventory: %s", spellConfig.Name)
        return
    end
    log.Info("Shrinking group members with %s", item.ItemLink("CLICKABLE")())

    -- make sure shrink is targetable check buff type
    local spell = getSpellFromBuff(spellConfig.Name)
    if spell ~= nil and (spell.TargetType() == "Single" or spell.TargetType() == "Group v1") then
        -- loop over group, shrink one by one starting with yourself
        for n = 0, 5 do
            for i = 1, 3 do
                if mq.TLO.Group.Member(n)() ~= nil and not mq.TLO.Group.Member(n).OtherZone() and mq.TLO.Group.Member(n).Height() > 2.04 then
                    log.Info("Shrinking member %s from height %d", mq.TLO.Group.Member(n)(), mq.TLO.Group.Member(n).Height())
                    castSpell(spellConfig.Name, mq.TLO.Group.Member(n).ID())
                    -- sleep for the Duration
                    delay(item.Clicky.CastTime() + spell.RecastTime())
                end
            end
        end
    end
end

---@param spawnID integer
function rez_it(spawnID)
    local spawn = spawn_from_id(spawnID)
    if spawn == nil then
        -- unlikely
        all_tellf("ERROR: tried to rez spawnid %s which is not in zone %s", spawnID, zone_shortname())
        return
    end
    log.Info("Performing rez on %s, %d %s", spawn.Name(), spawnID, type(spawnID))

    -- try 3 times to get a rez spell before giving up (to wait for ability to become ready...)
    for i = 1, 3 do
        local rez = get_rez_spell_item_aa()
        if rez ~= nil then
            all_tellf("Rezzing \ag%s\ax with \ay%s\ax. %d/3", spawn.Name(), rez, i)
            castSpellAbility(spawn, rez)
            break
        else
            all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax. %d/3", spawn.Name(), i)
        end
        doevents()
        delay(2000) -- 2s delay
    end
end

function ae_rez()
    local spawnQuery = 'pccorpse radius 100'
    local corpses = spawn_count(spawnQuery)

    all_tellf("AERez started in %s (%d corpses) ...", zone_shortname(), corpses)
    wait_until_not_casting()

    for i = 1, corpses do
        ---@type spawn
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn ~= nil and spawn ~= "NULL" then
            log.Info("Trying to rez %s", spawn.Name())
            target_id(spawn.ID())

            local rez = get_rez_spell_item_aa()
            if rez ~= nil then
                if spawn ~= nil then
                    all_tellf("Rezzing %s with %s", spawn.Name(), rez)
                    castSpellRaw(rez, spawn.ID())
                    delay(3000)
                    wait_until_not_casting()
                end
            else
                all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax.", spawn.Name())
            end
        end
        doevents()
        delay(12000)
    end
    log.Info("AEREZ ENDING")
end

function pbae_loop()

    local nearbyPBAEilter = "npc radius 50 zradius 50 los"

    if spawn_count(nearbyPBAEilter) == 0 then
        all_tellf("Ending PBAE. No nearby mobs.")
        return
    end

    memorizePBAESpells()

    all_tellf("PBAE ON")
    while true do
        -- TODO: break this loop with /pbaeoff
        if spawn_count(nearbyPBAEilter) == 0 then
            all_tellf("Ending PBAE. No nearby mobs.")
            break
        end

        if not is_casting() then
            for k, spellRow in pairs(botSettings.settings.assist.pbae) do
                local spellConfig = parseSpellLine(spellRow)
                if is_spell_ready(spellConfig.Name) then
                    log.Info("Casting PBAE spell %s", spellConfig.Name)
                    castSpellAbility(mq.TLO.Me, spellRow)
                end

                doevents()
                delay(50)
            end
        end
    end
end