local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'

local globalSettings = require("e4_Settings")
local botSettings = require("e4_BotSettings")
local aliases = require("settings/Spell Aliases")

local follow = require("e4_Follow")

local bci = broadCastInterfaceFactory()

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
        log.Debug("refreshBuff skip. we are in zone %s, vs required %s", zone_shortname(), spellConfig.Zone)
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
        mq.delay(5000, function() return mq.TLO.Me.Gem(spellName)() ~= nil end)
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
            --log.Debug("cant rebuff (%s), toon too far away: %s %s spell range = %d, spawn distance = %d", spell.TargetType(), buffItem, spawn.CleanName(), spell.Range(), spawn.Distance())
            return false
        end
    else
        if spell.TargetType() ~= "Self" and spawn.Distance() >= spell.Range() then
            --log.Error("cant rebuff (%s), toon too far away: %s %s spell range = %d, spawn distance = %d", spell.TargetType(), buffItem, spawn.CleanName(), spell.Range(), spawn.Distance())
            return false
        end
    end

    if spawn.ID() == mq.TLO.Me.ID() then
        if not spell.Stacks() then
            --log.Debug("cant rebuff %s, dont stack", spellConfig.Name)
            return false
        end
    else
        if not spell.StacksSpawn(spawn.ID()) then
            all_tellf("cant rebuff %s on spawn, dont stack", spellConfig.Name)
            return false
        end
    end

    if spellConfig.Shrink ~= nil and spellConfig.Shrink and mq.TLO.Me.Height() <= 2.04 then
        --print("will not shrink myself with ", spellConfig.Name, " because my height is already ", mq.TLO.Me.Height())
        return false
    end

    if spellConfig.MinMana ~= nil then
        if mq.TLO.Me.PctMana() < spellConfig.MinMana then
            log.Info("SKIP BUFFING %s, my mana is %d %% vs required %d %%", spellConfig.Name, mq.TLO.Me.PctMana(), spellConfig.MinMana)
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
        --log.Error("getSpellFromBuff: can't find %s", name)
        all_tellf("ERROR: Missing \ar%s\ax", name)
        return nil
    end
end

-- Memorizes all spells listed in character settings.gems in their correct position.
function memorizeListedSpells()
    if botSettings.settings.gems == nil then
        return
    end

    if haveMemorizedListedSpells() then
        return
    end

    if not is_sitting() then
        cmd("/sit on")
        delay(100)
    end

    for spellRow, gem in pairs(botSettings.settings.gems) do
        memorize_spell(spellRow, gem)
    end

    if window_open("SpellBookWnd") then
        cmd("/windowstate SpellBookWnd close")
    end

    if is_sitting() then
        cmd("/sit off")
    end
end

-- Returns true if I have memorized all current spells in their proper spell gems
---@return boolean
function haveMemorizedListedSpells()
    for spellRow, gem in pairs(botSettings.settings.gems) do
        local o = parseSpellLine(spellRow)

        if not have_spell(o.Name) then
            all_tellf("ERROR don't know spell/song \ar%s\ax", o.Name)
            cmd("/beep 1")
            return false
        end

        local gem = defaultGem
        if o.Gem ~= nil then
            gem = o.Gem
        elseif botSettings.settings.gems ~= nil and botSettings.settings.gems[o.Name] ~= nil then
            gem = botSettings.settings.gems[o.Name]
        elseif gem == nil then
            all_tellf("\arWARN\ax: Spell/song lacks gems default slot or Gem|n argument: %s", spellRow)
            gem = 5
        end

        local nameWithRank = mq.TLO.Spell(o.Name).RankName()
        if mq.TLO.Me.Gem(gem).Name() ~= nameWithRank then
            log.Info("Do not have memorized \ag%s\ax in gem %d (have \ay%s\ax)", nameWithRank, gem, mq.TLO.Me.Gem(gem).Name())
            return false
        end
    end

    return true
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

    if not have_alt_ability(spellName) then
        memorize_spell(spellName, 5)
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

local aeWarCryCombatAbilities = {
    "Ancient: Cry of Chaos",        -- L65, slot 2: Hundred Hands Effect, slot 11: 60 atk
    "Battle Cry of the Mastruq",    -- L65, slot 2: Hundred Hands Effect, slot 11: 50 atk
    "War Cry of Dravel",            -- L64, slot 2: Hundred Hands Effect, slot 11: 40 atk
    "Battle Cry of Dravel",         -- L57, slot 2: Hundred Hands Effect, slot 11: 30 atk
    "War Cry",                      -- L50, slot 2: Hundred Hands Effect, slot 11: 20 atk
    "Battle Cry",                   -- L30, slot 2: Hundred Hands Effect, slot 11: 10 atk
}

-- Use the best available AE berserker war cry combat ability (DoDH)
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

-- Use the best available AE berserker war cry combat ability (DoDH)
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

    follow.Stop()

    all_tellf("Porting group to \ag%s\ax (\ay%s\ax) ...", name, spellName)
    unflood_delay()

    if memorize_spell(spellName, 5) ~= nil then
        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
        delay(5000) -- 5s to memorize and start casting
        wait_until_not_casting()
    end

end

-- Cleric: performs an AE rez
function ae_rez()
    local rez = get_rez_spell()
    if rez == nil then
        log.Error("Cannot AE rez, got no rez spell!")
        return
    end

    local classOrder = {'CLR', 'DRU', 'SHM', 'ENC', 'RNG', 'BST', 'PAL', 'SHD', 'WAR', 'BRD', 'MNK', 'ROG', 'BER', 'WIZ', 'NEC', 'MAG'}
    local spawnQuery = 'pccorpse radius 100'
    local corpses = spawn_count(spawnQuery)
    all_tellf("\amAERez started in %s\ax (%d corpses) ...", zone_shortname(), corpses)
    unflood_delay()

    for i=1, #classOrder do
        wait_until_not_casting()
        ae_rez_query(spawnQuery..' '..classOrder[i])
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

--- Returns true if `name` is marked as being rezzed
---@return boolean
function is_being_rezzed(name)
    for _, rezzedName in ipairs(aeRezzedNames) do
        if rezzedName == name then
            --log.Debug("aerez: skipping marked corpse %s", name)
            return true
        end
    end
    return false
end

---@param rez string rez spell/item name
---@param spawnQuery string
function ae_rez_query(spawnQuery)

    local corpses = spawn_count(spawnQuery)
    if corpses == 0 then
        return
    end

    log.Debug("ae_rez_query \ay%s\ax", spawnQuery)

    for i = 1, corpses do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn ~= nil and spawn.ID() ~= nil then
            if not is_being_rezzed(spawn.DisplayName()) then
                rez_corpse(spawn.ID())
            end
        end
    end
end

function rez_corpse(spawnID)
    local spawn = spawn_from_id(spawnID)
    if spawn == nil or spawn() == nil then
        return
    end
    log.Info("Trying to rez \ag%s\ax", spawn.DisplayName())

    local rez = get_rez_spell()
    if rez == nil then
        all_tellf("ae_rez_query ERROR: no rez spell found!")
        return
    end

    if is_alt_ability_ready("Blessing of Resurrection") then
        -- CLR/65: 96% exp, 3s cast, 12s recast (SoD)
        rez = "Blessing of Resurrection"
    end
    if have_item("Water Sprinkler of Nem Ankh") and is_item_clicky_ready("Water Sprinkler of Nem Ankh") then
        -- CLR/65 Epic1.0: 96% exp, 10s cast
        rez = "Water Sprinkler of Nem Ankh"
    end

    if have_spell(rez) and not is_memorized(rez) then
        log.Info("Memorizing %s ...", rez)
        mq.cmdf('/memorize "%s" %d', rez, 8) -- avoid gem5 as it is used for temp buffs
        mq.delay(5000, function() return mq.TLO.Me.Gem(rez)() ~= nil end)
    end


    mq.delay(15000, function() return not is_casting() and is_spell_ability_ready(rez) end)

    if is_spell_ability_ready(rez) then

        -- tell bots this corpse is rezzed
        local cmd = string.format("/ae_rezzed %s", spawn.DisplayName())
        bci.ExecuteZoneCommand(cmd)

        all_tellf("Rezzing %s \ag%s\ax with \ay%s\ax", spawn.Class.ShortName(), spawn.DisplayName(), rez)
        --target_id(spawn.ID())
        if globalSettings.allowBotTells then
            --cmdf("/tell %s Wait4Rez", spawn.DisplayName())
        end
        castSpellRaw(rez, spawn.ID())
    else
        all_tellf("\arWARN\ax: Not ready to rez \ag%s\ax (%s not ready).", spawn.Name(), rez)
    end
end

-- tell all peers with corpses nearby to consent me
function consent_me()
    local spawnQuery = 'pccorpse radius 2500'
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if is_peer(spawn.DisplayName()) then
            bci.ExecuteCommand(string.format("/consent %s", mq.TLO.Me.Name()), {spawn.DisplayName()})
        else
            all_tellf("Cannot autoconsent corpse \ar%s\ax, not a peer", spawn.DisplayName())
        end
    end
end

-- returns true if I have a corpse in current zone
--- @return boolean
function have_corpse_in_zone()
    local name = string.format("%s's corpse", mq.TLO.Me.Name())
    return spawn_count(name) > 0
end

function loot_my_corpse()

    if not have_corpse_in_zone() then
        log.Info("loot_my_corpse: I do not have a corpse in zone")
        return
    end

    -- target my corpse
    local name = string.format("%s's corpse", mq.TLO.Me.Name())
    cmdf("/target %s", name)
    move_to(mq.TLO.Target.ID())
    mq.delay(100)

    if mq.TLO.Target.ID() == nil then
        all_tellf("UNLIKELY: No corpse around, giving up!")
        return
    end

    -- open loot window
    cmd("/loot")
    delay(5000, function() return window_open("LootWnd") end)

    if not window_open("LootWnd") then
        log.Info("ERROR: CANNOT OPEN MY LOOT WINDOW.")
        return
    end

    -- click loot all button
    cmd("/notify LootWnd LootAllButton leftmouseup")
    delay(30000, function() return not window_open("LootWnd") end)
    all_tellf("\ayReady to die again!")
end

-- used by /fdi
---@param name string
---@param filter string|nil
function report_find_item(name, filter)
    name = strip_link(name)
    log.Info("Searching for %s", name)

    if is_orchestrator() then
        local exe = string.format("/fdi %s", name)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        bci.ExecuteZoneCommand(exe)
    end

    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
        log.Info("/fdi: I do not match filter \ay%s\ax", filter)
        return
    end

    local s = ""
    local click = ""

    local item = find_item(name)
    if item ~= nil then
        click = item.ItemLink("CLICKABLE")()
        local inv_cnt = inventory_item_count(item.Name())
        if inv_cnt == 1 then
            s = string.format("%s", inventory_slot_name(item.ItemSlot()))
        else
            s = string.format("%s (count: %d)", inventory_slot_name(item.ItemSlot()), inv_cnt)
        end
    end

    item = find_item_bank(name)
    if item ~= nil then
        click = item.ItemLink("CLICKABLE")()
        local in_bank = banked_item_count(item.Name())
        if in_bank > 0 then
            s = s .. ", "
        end
        if in_bank == 1 then
            s = s .. string.format("bank slot %d", item.ItemSlot())
        elseif in_bank > 0 then
            s = s .. string.format("bank (count: %d)", in_bank)
        end
    end

    if s ~= "" then
        all_tellf("%s in %s", click, s)
    end
end

-- used by /fmi
---@param name string
---@param filter string|nil
function report_find_missing_item(name, filter)
    name = strip_link(name)

    if is_orchestrator() then
        local exe = string.format("/fmi %s", name)
        if filter ~= nil then
            exe = exe .. " " .. filter
        end
        bci.ExecuteZoneCommand(exe)
    end

    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then
        log.Info("/fmi: I do not match filter \ay%s\ax", filter)
        return
    end

    local item = find_item(name)
    if item ~= nil then
        return
    end

    local item = find_item_bank(name)
    if item ~= nil then
        return
    end
    all_tellf("I miss \ay%s\ax", name)
end

-- used by /fmid
---@param id integer
function report_find_missing_item_by_id(id)

    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/fmid %s", tostring(id)))
    end

    local found = false
    if mq.TLO.Cursor.ID() == id then
        found = true
    end


    -- search equipment
    for i = 1, 22 do
        if mq.TLO.InvSlot(i).Item.ID() == id then
            found = true
        end
    end

    -- search inventory
    for i = 1, 10 do -- 10 = number of inventory slots
        local pack = string.format("pack%d", i)
        if mq.TLO.Me.Inventory(pack).ID() == id then
            found = true
        end
        if mq.TLO.Me.Inventory(pack).Container() then
            for e = 1, mq.TLO.Me.Inventory(pack).Container() do
                if mq.TLO.Me.Inventory(pack).Item(e).ID() == id then
                    found = true
                end
            end
        end
    end

    -- search bank
    for i = 1, 26 do -- 26 = number of bank slots

        if mq.TLO.Me.Bank(i).ID() == id then
            found = true
        end
        if mq.TLO.Me.Bank(i).Container() then
            for e = 1, mq.TLO.Me.Bank(i).Container() do
                if mq.TLO.Me.Bank(i).Item(e).ID() == id then
                    found = true
                end
            end
        end
    end

    if not found then
        all_tellf("\arMISSING ID %d", id)
    end

end


---@param cat string|nil Category (manaregen, xxx)
function list_my_clickies(cat)
    if cat ~= nil then
        all_tellf("report_clickies: TODO handle category arg")
    end
    log.Info("My clickies:")

    -- XXX TODO skip Expendable
    -- XXX 15 sep 2022: item.Expendable() seem to be broken, always returns false ? https://discord.com/channels/511690098136580097/840375268685119499/1019900421248126996

    -- equipment: 0-22 is worn gear, 23-32 is inventory top level
    for i = 0, 32 do
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

    -- bank top level slots: 1-24 is bank bags, 25-26 is shared bank
    for i = 1, 26 do
        if mq.TLO.Me.Bank(i)() ~= nil then
            local key = "bank"..tostring(i)
            local inv = mq.TLO.Me.Bank(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item.Clicky() ~= nil and not item.Expendable() then
                        --print( "three ", item.Name(), " ", item.Charges(), " ", item.Expendable())
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
                log.Info("Asking %s to activate \ay%s\ax ...", peer, aaName)
                bci.ExecuteCommand("/banker", {peer})
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
