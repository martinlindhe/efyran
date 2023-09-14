local mq = require("mq")
local log = require("efyran/knightlinc/Write")

local botSettings = require("efyran/e4_BotSettings")
local aliases = require("efyran/settings/Spell Aliases")
local groupBuffs = require("efyran/e4_GroupBuffs")

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
-- only refreshes fading & missing buffs
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

    local spellConfig = parseSpellLine(buffItem)

    local spell = getSpellFromBuff(spellConfig.Name)
    if spell == nil then
        all_tellf("refreshBuff: getSpellFromBuff %s FAILED", buffItem)
        cmd("/beep 1")
        return false
    end

    local spellName = spellConfig.Name
    if have_spell(spellConfig.Name) then
        spellName = spell.RankName()
    end

    if spellConfig.Zone ~= nil and zone_shortname() ~= spellConfig.Zone then
        -- TODO: allow multiple zones listed as comma separated shortnames
        log.Info("refreshBuff skip. we are in zone %s, vs required %s", zone_shortname(), spellConfig.Zone)
        return false
    end

    if mq.TLO.Me.ID() == spawn.ID() then
        -- IMPORTANT: on live, f2p restricts all spells to rank 1, so we need to look for both forms
        if have_buff(spell.RankName()) and mq.TLO.Me.Buff(spell.RankName()).Duration() ~= nil and mq.TLO.Me.Buff(spell.RankName()).Duration() >= MIN_BUFF_DURATION then
            --print("target have ranked buff with remaining ticks:", mq.TLO.Me.Buff(spell.RankName()).Duration.Ticks())
            return false
        end
        if have_buff(spell.Name()) and mq.TLO.Me.Buff(spell.Name()).Duration() ~= nil and mq.TLO.Me.Buff(spell.Name()).Duration() >= MIN_BUFF_DURATION then
            --print("target have buff with remaining ticks:", mq.TLO.Me.Buff(spell.Name()).Duration.Ticks())
            return false
        end

        if have_spell(spellName) and not spell.Stacks() then
            if free_buff_slots() <= 0 then
                all_tellf("\arWARN\ax: Cannot selfbuff with %s (only have %d free buff slots)", spellName, free_buff_slots())
            else
                all_tellf("ERROR cannot selfbuff with %s (dont stack with current buffs)", spellName)
            end
            return false
        end
        if free_buff_slots() == 0 and not (spellConfig.Shrink ~= nil and spellConfig.Shrink) then
            log.Debug("refreshBuff. SKIP SELF BUFF (out of slots): %s", spellName)
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
        if have_spell(spellName) and spell.StacksPet() then
            --all_tellf("ERROR cannot buff pet with %s (dont stack with current buffs)", spellName)
            return false
        end
    else
        all_tellf("FATAL ERROR refreshBuff called with invalid spawn %s", spawn.Name())
        return
    end

    if not is_spell_ability_ready(spellName) and have_spell(spellName) and not is_memorized(spellName) then
        local gem = 5
        if spellConfig.Gem ~= nil then
            gem = spellConfig.Gem
        end
        --print("attempting to memorize ", spellName .. " ... GEM ", gem)
        cmdf('/memorize "%s" %d', spellName, gem)
        delay(3000) -- XXX 3s
    end

    if not have_item_inventory(spellConfig.Name) and mq.TLO.Me.CurrentMana() < spell.Mana() then
        log.Info("SKIPPING BUFF, not enough mana. Have %d, need %d", mq.TLO.Me.CurrentMana(), spell.Mana())
        return false
    end

    if have_alt_ability(spellName) and not is_alt_ability_ready(spellName) then
        --print("SKIPPING BUFF, AA ", spellName, " is not ready")
        return false
    end

    local pretty = spellName
    if have_item_inventory(spellConfig.Name) then
        local item = find_item(spellConfig.Name)
        if item ~= nil then
            pretty = item.ItemLink("CLICKABLE")()
        end
    end

    if spawn.Type() == "Pet" then
        log.Info("Buffing \agmy pet %s\ax with \ay%s\ax.", spawn.CleanName(), pretty)
    else
        log.Info("Buffing \agmyself\ax with \ay%s\ax.", pretty)
        if spell.TargetType() == "Self" then
            -- don't target myself on self-buffs
            spawnID = nil
        end
    end

    return castSpell(spellName, spawnID)
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
            log.Error("cant rebuff (%s), toon too far away: %s %s spell range = %d, spawn distance = %d", spell.TargetType(), buffItem, spawn.CleanName(), spell.Range(), spawn.Distance())
            return false
        end
    else
        if spell.TargetType() ~= "Self" and spawn.Distance() >= spell.Range() then
            log.Error("cant rebuff (%s), toon too far away: %s %s spell range = %d, spawn distance = %d", spell.TargetType(), buffItem, spawn.CleanName(), spell.Range(), spawn.Distance())
            return false
        end
    end

    if spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Height() <= 2.04 then
        --print("will not shrink myself with ", spellConfig.Name, " because my height is already ", mq.TLO.Me.Height())
        return false
    end

    if spellConfig.MinMana ~= nil then
        if mq.TLO.Me.PctMana() < spellConfig.MinMana then
            log.Info("SKIP BUFFING, my mana is %d %% vs required %d %%",  mq.TLO.Me.PctMana(), spellConfig.MinMana)
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
        if inventory_item_count(spellConfig.Reagent) == 0 then
            all_tellf("SKIP BUFFING %s , out of reagent %s", spellConfig.Name, spellConfig.Reagent)
            return false
        end
    end

    return true
end

-- returns datatype spell or nil if not found
function getSpellFromBuff(name)
    if have_item_inventory(name) then
        return mq.TLO.FindItem(name).Clicky.Spell
    elseif have_spell(name) then
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
        local spell = parseSpellLine(spellRow)
        if have_spell(spell.Name) then
            memorize_spell(spellRow)
        end
    end
end

---@param spellName string
function cast_mgb_spell(spellName)
    if not is_alt_ability_ready("Mass Group Buff") then
        all_tellf("\arMass Group Buff is not available...\ax Ready in %s", mq.TLO.Me.AltAbilityTimer("Mass Group Buff").TimeHMS())
        return
    end

    if not have_alt_ability(spellName) and not have_spell(spellName) then
        all_tellf("\ar%s is not available...", spellName)
        return
    end

    memorize_spell(spellName, 5)

    use_alt_ability("Mass Group Buff", nil)
    delay(1000)
    all_tellf("\agMGB %s inc\ax...", spellName)
    if have_alt_ability(spellName) then
        use_alt_ability(spellName)
    else
        castSpellRaw(spellName, nil, "gem5 -maxtries|3")
    end
end

local aeWarCryCombatAbilities = {
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

-- Use the best available AE berserker war cry combat ability
function cast_ae_bloodthirst()
    if not have_alt_ability("Cry of Battle") then
        all_tellf("\arCry of Battle is not available...\ax Need to purchase AA")
        return
    end
    if not is_alt_ability_ready("Cry of Battle") then
        all_tellf("\arCry of Battle is not available...\ax Ready in %s", mq.TLO.Me.AltAbilityTimer("Cry of Battle").TimeHMS())
        return
    end

    -- L70, slot 3: Add Defensive Proc: Bloodthirst Effect (30% dmg mod)
    local name = "Bloodthirst"
    if have_combat_ability(name) then
        use_alt_ability("Cry of Battle", nil)
        delay(1000)
        all_tellf("\agMGB %s inc\ax...", name)
        use_combat_ability(name)
        return
    end

    all_tellf("\ar%s ability not available...\ax Need to purchase discs", name)
end


function cast_evac_spell()
    -- XXX TODO use rogue "Stealthy Getaway", need to be hidden in order to use it

    -- DRU/WIZ L59 Exodus AA (instant cast)
    -- Hastened Exodus reduces recast time by 10% per rank
    -- Rank 0: recast time 72 min
    -- Rank 4: recast time XX min
    if is_alt_ability_ready("Exodus") then
        use_alt_ability("Exodus")
        return
    end

    if class_shortname() == "DRU" then
        -- L57 Succor (9s cast, cost 100 mana)
        if have_spell("Succor") then
            castSpellRaw("Succor", nil, "gem5 -maxtries|3")
            return
        end

        -- L18 Lesser Succor (10.5s cast, cost 150 mana)
        if have_spell("Lesser Succor") then
            castSpellRaw("Lesser Succor", nil, "gem5 -maxtries|3")
            return
        end
        log.Error("I have no evac spell!")
    elseif class_shortname() == "WIZ" then
        -- L57 Evacuate (9s cast, cost 100 mana)
        if have_spell("Evacuate") then
            castSpellRaw("Evacuate", nil, "gem5 -maxtries|3")
            return
        end

        -- L18 Lesser Evacuate (10.5s cast, cost 150 mana)
        if have_spell("Lesser Evacuate") then
            castSpellRaw("Lesser Evacuate", nil, "gem5 -maxtries|3")
            return
        end
        log.Error("I have no evac spell!")
    end
end

function click_nearby_door()
    -- TODO: dont know how to access /doors list from lua/macroquest

    -- WORK-AROUND: in sro, "HUT1" is in the way for a correct doortarget
    if zone_shortname() == "sro" and is_within_distance_to_loc(-2114, 1348, -81, 50) then
        log.Info("sro ldon raid instance special")
        cmd("/doortarget RUJPORTAL701")
    elseif zone_shortname() == "poknowledge" and is_within_distance_to_loc(-760, 1226, -151, 50) then
        log.Info("pok gunthak stone special")
        -- XXX no door nearby !?!? except "PORTBASE", the foundation which is unclickable !?
    else
        -- XXX check if door within X radius
        cmd("/doortarget")
    end

    log.Info("CLICKING NEARBY DOOR %s, id %d, distance %d", mq.TLO.DoorTarget.Name(), mq.TLO.DoorTarget.ID(), mq.TLO.DoorTarget.Distance())

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
    local spellName = nil --- @type string|nil
    if class_shortname() == "WIZ" then
        spellName = aliases.WIZ["port " .. name]
    elseif class_shortname() == "DRU" then
        spellName = aliases.DRU["port " .. name]
    else
        return
    end

    if spellName == nil then
        all_tellf("\arERROR\ax: Unknown port alias \ag%s\ax", name)
        return
    end

    all_tellf("Porting group to \ag%s\ax (\ay%s\ax) ...", name, spellName)
    unflood_delay()

    if memorize_spell(spellName, 5) ~= nil then
        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
        wait_until_not_casting()
    end

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
    local rez = get_rez_spell_item_aa()
    if rez == nil then
        return
    end
    local spawn = spawn_from_id(spawnID)
    if spawn == nil then
        -- unlikely
        all_tellf("ERROR: tried to rez spawnid %s which is not in zone %s", spawnID, zone_shortname())
        return
    end
    log.Info("Performing rez on %s, %d %s", spawn.Name(), spawnID, type(spawnID))
    if have_spell(rez) and not is_memorized(rez) then
        mq.cmdf('/memorize "%s" %d', rez, 5)
        mq.delay(2000)
    end

    -- try 3 times to get a rez spell before giving up (to wait for ability to become ready...)
    for i = 1, 3 do
        if is_alt_ability_ready(rez) or is_spell_ready(rez) or is_item_clicky_ready(rez) then
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

-- Cleric: performs an AE rez
function ae_rez()
    local rez = get_rez_spell_item_aa()
    if rez == nil then
        return
    end

    local corpses = spawn_count('pccorpse radius 100')
    all_tellf("\amAERez started in %s\ax (%d corpses) ...", zone_shortname(), corpses)

    local spawnQuery = 'pccorpse radius 100'
    local classOrder = {'CLR', 'DRU', 'SHM', 'ENC', 'RNG', 'BST', 'PAL', 'SHD', 'WAR', 'BRD', 'MNK', 'ROG', 'BER', 'WIZ', 'NEC', 'MAG'}
    for i=1, #classOrder do
        ae_rez_query(rez, 'pccorpse radius 100 '..classOrder[i])
    end

    all_tellf("\amAEREZ DONE\ax")
    clear_ae_rezzed()
end

-- holds names of those already being rezzed
---@type string[]
local aeRezzedNames = {}

---@param name string
function mark_ae_rezzed(name)
    table.insert(aeRezzedNames, name)
end

function clear_ae_rezzed()
    aeRezzedNames = {}
end

---@param rez string rez spell/item name
---@param spawnQuery string
function ae_rez_query(rez, spawnQuery)

    local corpses = spawn_count(spawnQuery)
    log.Info("ae_rez_query %s: %d", spawnQuery, corpses)
    if corpses == 0 then
        return
    end
    wait_until_not_casting()

    if have_spell(rez) and not is_memorized(rez) then
        mq.cmdf('/memorize "%s" %d', rez, 5)
        mq.delay(2000)
    end

    --log.Info("Rezzing %s", spawnQuery)

    for i = 1, corpses do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn ~= nil and spawn.ID() ~= nil then
            local skip = false

            -- XXX fix, access aeRezzedNames without recurisive includes
            for _, rezzedName in ipairs(aeRezzedNames) do
                log.Info("rezzedname check: %s vs %s", rezzedName, spawn.Name())
                if rezzedName == spawn.Name() then
                    log.Info("already being rezzed, should skip !!!")
                    all_tellf("aerez: skipping marked corpse %s", rezzedName)
                    skip = true
                end
            end
            if not skip then
                log.Info("Trying to rez %s", spawn.Name())

                -- tell bots this corpse is rezzed
                cmdf("/dgzexecute /ae_rezzed %s", spawn.Name())

                target_id(spawn.ID())

                if is_alt_ability_ready(rez) or is_spell_ready(rez) or is_item_clicky_ready(rez) then
                    all_tellf("Rezzing \ag%s\ax with \ay%s\ax", spawn.Name(), rez)
                    castSpellRaw(rez, spawn.ID())
                    delay(3000)
                    wait_until_not_casting()
                else
                    all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax.", spawn.Name())
                end
            end
        end
        doevents()
        delay(13000) -- XXX TODO: instead wait until given rez spell is ready before cast
    end
end

function consent_me()
    local spawnQuery = 'pccorpse radius 500'
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        cmdf("/dexecute %s /consent %s", spawn.DisplayName(), mq.TLO.Me.Name())
    end
end

-- ask for consent, then gathers corpses
function gather_corpses()
    local spawnQuery = 'pccorpse radius 100'
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn.Distance() > 20 then
            log.Info("Gathering corpse %s", spawn.Name())
            target_id(spawn.ID())
            cmdf("/dexecute %s /consent %s", spawn.DisplayName(), mq.TLO.Me.Name())
            delay(100)
            cmd("/corpse")
            delay(1000, function() return spawn() ~= nil and spawn.Distance() < 20 end)
        end
    end
end

function loot_my_corpse()

    cmd("/squelch /target clear")
    -- target my corpse
    cmdf("/target %s's corpse", mq.TLO.Me.Name())
    mq.delay(100)
    if mq.TLO.Target.ID() == nil then
        all_tellf("No corpse around, giving up!")
        return
    end

    move_to(mq.TLO.Target.ID())

    -- open loot window
    cmd("/loot")
    delay(5000, function() return window_open("LootWnd") end)

    if not window_open("LootWnd") then
        all_tellf("ERROR FATAL CANNOT OPEN MY LOOT WINDOW.")
        return
    end

    -- click loot all button
    cmd("/notify LootWnd LootAllButton leftmouseup")
    delay(30000, function() return not window_open("LootWnd") end)
    all_tellf("Ready to die again!")
end

-- used by /fdi
---@param name string
function report_find_item(name)
    name = strip_link(name)
    log.Info("Searching for %s", name)

    if is_orchestrator() then
        cmdf("/dgzexecute /fdi %s", name)
    end

    local item = find_item(name)
    if item ~= nil then
        local inv_cnt = inventory_item_count(item.Name())
        if inv_cnt == 1 then
            all_tellf("%s in %s", item.ItemLink("CLICKABLE")(), inventory_slot_name(item.ItemSlot()))
        else
            all_tellf("%s in %s (count: %d)", item.ItemLink("CLICKABLE")(), inventory_slot_name(item.ItemSlot()), inv_cnt)
        end
    end

    item = find_item_bank(name)
    if item == nil then
        return
    end

    local in_bank = banked_item_count(item.Name())
    if in_bank == 1 then
        all_tellf("%s in bank slot %d", item.ItemLink("CLICKABLE")(), item.ItemSlot())
    elseif in_bank > 0 then
        all_tellf("%s in bank (count: %d)", item.ItemLink("CLICKABLE")(), in_bank)
    end
end

-- used by /fmi
---@param name string
function report_find_missing_item(name)
    name = strip_link(name)

    if is_orchestrator() then
        cmdf("/dgzexecute /fmi %s", name)
    end

    local item = find_item(name)
    if item ~= nil then
        return
    end

    local item = find_item_bank(name)
    if item ~= nil then
        return
    end
    all_tellf("I miss %s", name)
end

function report_clickies()
    log.Info("My clickies:")

    -- XXX TODO skip Expendable

    -- XXX 15 sep 2022: item.Expendable() seem to be broken, always returns false ? https://discord.com/channels/511690098136580097/840375268685119499/1019900421248126996

    for i = 0, 32 do -- equipment: 0-22 is worn gear, 23-32 is inventory top level
        if mq.TLO.Me.Inventory(i).ID() then
            local inv = mq.TLO.Me.Inventory(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item.Clicky() ~= nil and not item.Expendable() then
                        --print ( "one ", item.Name(), " ", item.Charges() , " ", item.Expendable())
                        log.Info(inventory_slot_name(i).." # "..c.." "..item.ItemLink("CLICKABLE")().." effect: "..item.Clicky.Spell.Name())
                    end
                end
            else
                if inv.Clicky() ~= nil and not inv.Expendable() then
                    --print ( "two ", inv.Name(), " ", inv.Charges(), " ", inv.Expendable())
                    log.Info(inventory_slot_name(i).." "..inv.ItemLink("CLICKABLE")().." effect: "..inv.Clicky.Spell.Name())
                end
            end
        end
    end

    for i = 1, 26 do -- bank top level slots: 1-24 is bank bags, 25-26 is shared bank
        if mq.TLO.Me.Bank(i)() ~= nil then
            local key = "bank"..tostring(i)
            local inv = mq.TLO.Me.Bank(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item.Clicky() ~= nil and not item.Expendable() then
                        print ( "three ", item.Name(), " ", item.Charges(), " ", item.Expendable())
                        log.Info(key.." # "..c.." "..item.ItemLink("CLICKABLE")().." effect: "..item.Clicky.Spell.Name())
                    end
                end
            else
                if inv.Clicky() ~= nil and not inv.Expendable() then
                    --print ( "four ", inv.Name(), " ", inv.Charges(), " ", inv.Expendable())
                    log.Info(key.." "..inv.ItemLink("CLICKABLE")().." effect: "..inv.Clicky.Spell.Name())
                end
            end
        end
    end
end

function report_worn_augs()
    log.Info("Currently worn auguments:")
    local hp = 0
    local mana = 0
    local endurance = 0
    local ac = 0
    for i = 0, 22 do
        if mq.TLO.Me.Inventory(i).ID() then
            for a = 0, mq.TLO.Me.Inventory(i).Augs() do
                if mq.TLO.Me.Inventory(i).AugSlot(a)() ~= nil then
                    local item = mq.TLO.Me.Inventory(i).AugSlot(a).Item
                    hp = hp + item.HP()
                    mana = mana + item.Mana()
                    endurance = endurance + item.Endurance()
                    ac = ac + item.AC()
                    log.Info(inventory_slot_name(i).." #"..a..": "..item.ItemLink("CLICKABLE")().." "..item.HP().." HP")
                end
            end
        end
    end
    log.Info("Augument total: "..hp.." HP, "..mana.." mana, "..endurance.." endurance, "..ac.." AC")
end

-- check all nearby peers if their banker is ready and use it.
---@param aaName string
function ask_nearby_peer_to_activate_aa(aaName)
    local spawnQuery = "pc notid " .. mq.TLO.Me.ID() .. " radius 50"

    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        local peer = spawn.Name()
        if is_peer(peer) then
            local value = query_peer(peer, "Me.AltAbilityReady["..aaName.."]", 0)
            if value == "TRUE" then
                log.Info("Asking %s to activate banker ...", peer)
                cmdf("/dexecute %s /banker", peer)
                return
            end
        end
        delay(1)
        doevents()
    end
end

-- used by /lcorpse
function open_nearby_corpse()
    if has_target() ~= nil then
        cmd("/squelch /target clear")
    end
    cmd("/target corpse radius 100")
    delay(500, function()
        return has_target()
    end)
    cmd("/loot")
end

---@param filter string
function drop_buff(filter)
    if filter == nil then
        return
    end
    if is_orchestrator() then
        cmdf("/dgzexecute /dropbuff %s", filter)
    end

    if filter == "all" then
        drop_all_buffs()
    else
        cmdf("/removebuff %s", filter)
    end
end

-- summons my mount
function mount_on()
    if botSettings.settings.mount == nil then
        return
    end

    if not mq.TLO.Me.CanMount() then
        all_tellf("MOUNT ERROR, cannot mount in %s", zone_shortname())
        return
    end

    -- XXX see if mount clicky buff is on us already

    local spell = getSpellFromBuff(botSettings.settings.mount)
    if spell == nil then
        all_tellf("/mounton: getSpellFromBuff %s FAILED", botSettings.settings.mount)
        cmd("/beep 1")
        return false
    end

    if have_buff(spell.RankName()) then
        log.Error("I am already mounted.")
        return false
    end

    -- XXX dont summon if we are already mounted.
    log.Info("Summoning mount %s ...", botSettings.settings.mount)
    castSpellAbility(nil, botSettings.settings.mount)
end
