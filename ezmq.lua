-- collection of functions to simplify working with macroquest through Lua

-- @type mq
local mq = require("mq")

local log = require("knightlinc/Write")

local timer = require("lib/Timer")

-- Returns a 24-hour timestamp, in the format "HH:MM:SS".
---@return string
function time()
    ---@diagnostic disable-next-line: return-type-mismatch
    return os.date("%H:%M:%S")
end

-- Send a text to all peers
function all_tellf(...)
    --cmdf("/dgtell all [%s] %s", time(), string.format(...))
    mq.cmdf("/bc [%s] %s", time(), string.format(...))
end

--- Send a text to all peers thru MQ2DanNet
function all_tell(msg)
    mq.cmdf("/bc [%s] %s", time(), msg)
end

local follow  = require("lib/following/Follow")

local spellGroups  = require("lib/spells/SpellGroups")
local serverSettings = require("lib/settings/default/ServerSettings")
local botSettings = require("lib/settings/BotSettings")

-- returns true if `spawn` is within maxDistance
---@param spawn spawn
---@param maxDistance number
---@return boolean
function is_within_distance(spawn, maxDistance)
    return spawn ~= nil and spawn() ~= nil and spawn.Distance() <= maxDistance
end

-- Am I the foreground instance?
---@return boolean
function is_orchestrator()
    return mq.TLO.FrameLimiter.Status() == "Foreground"
end

-- returns true if location is within maxDistance from you
---@return boolean
function is_within_distance_to_loc(y, x, z, maxDistance)
    return mq.TLO.Math.Distance(string.format("%f,%f,%f", y, x, z))() <= maxDistance
end

-- returns true if there is line of sight between you and `spawn`
---@param spawn spawn
---@return boolean
function line_of_sight_to(spawn)
    local q = mq.TLO.Me.Y()..","..mq.TLO.Me.X()..","..mq.TLO.Me.Z()..":"..spawn.Y()..","..spawn.X()..","..spawn.Z()
    return mq.TLO.LineOfSight(q)()
end

function move_to_peer(peer)
    local spawn = spawn_from_peer_name(peer)
    if spawn == nil then
        return
    end
    move_to(spawn.ID())
end

-- Move to the location of `spawn` using MQ2Nav.
-- Returns true on success
---@param spawnID integer
---@return boolean
function move_to(spawnID)
    local spawn = spawn_from_id(spawnID)
    if spawn == nil or spawn() == nil then
        all_tellf("move_to: lost target spawn %d", spawnID)
        return false
    end

    log.Debug("move_to %d (at distance %d)", spawnID, spawn.Distance())

    --if serverSettings.followMode:lower() == "mq2advpath" and not line_of_sight_to(spawn) then
    --    all_tellf("move_to ERROR: cannot see %s", spawn.Name())
    --    return
    --end

    local dist = 10

    if spawn.Distance() < dist then
        return true
    end

    if not is_standing() then
        mq.cmd("/stand")
        mq.delay(50)
    end

    -- abort existing follow commands
    follow.Pause()

    if serverSettings.followMode:lower() == "mq2nav" then
        mq.cmdf("/nav id %d", spawnID)
    elseif serverSettings.followMode:lower() == "mq2advpath" then
        mq.cmdf("/afollow spawn %d", spawnID)
    end

    mq.delay("4m", function()
        return spawn == nil or spawn() == nil or spawn.Distance() < dist or not mq.TLO.Navigation.Active()
    end)

    -- abort our given move-to commands
    follow.Pause()

    if spawn() == nil then
        return false
    end
    return spawn.Distance() < dist
end

-- Returns true if low on endurance
---@return boolean
function low_endurance()
    return mq.TLO.Me.PctEndurance() < 70
end

---@param y number
---@param x number
---@param z number|nil
function move_to_loc(y, x, z)

    local dist = 10

    if not is_standing() then
        mq.cmd("/stand")
        mq.delay(50)
    end

    -- abort existing follow commands
    follow.Pause()

    if serverSettings.followMode:lower() == "mq2nav" then
        mq.cmdf("/nav loc %d %d %d", y, x, z)
    elseif serverSettings.followMode:lower() == "mq2advpath" then
        -- uses MQ2MoveUtils. TODO: can we move to a location using /afollow ?
        mq.cmdf("/moveto loc %f %f %f", y, x, z)
    end

    mq.delay(30000, function() return is_within_distance_to_loc(y, x, z, 15) end)

    -- abort our given move-to commands
    follow.Pause()
end

-- Does `t` contain `v`?
---@param t table
---@param v any
---@return boolean
function in_array(t, v)
    for i = 1, #t do
        if v == t[i] then return true end
    end
    return false
end

-- returns true if we are running the Emu build of MacroQuest (rof2 client)
---@return boolean
function is_rof2()
    if mq.TLO.MacroQuest.BuildName() == "Emu" then
        return true
    end
    return false
end

-- returns true if `x` is a number (integer or float)
---@param peer string Peer name
---@return boolean
function is_number(x)
    if tonumber(x) ~= nil then
        return true
    end
    return false
end

-- returns true if `peer` is a connected client
---@param peer string Peer name
---@return boolean
function is_peer(peer)
    -- NOTE: NetBots return string "NULL" if not exists, if it exists then it returns a number
    return is_number(mq.TLO.NetBots(peer).ID())
end

-- returns true if peerName is in the same zone
---@param peer string
---@return boolean
function is_peer_in_zone(peer)
    local spawn = spawn_from_peer_name(peer)
    return spawn ~= nil and is_peer(spawn.Name())
end

-- returns true if spawnID is another peer
---@param spawnID integer
---@return boolean
function is_peer_id(spawnID)
    local spawn = spawn_from_id(spawnID)
    return spawn ~= nil and is_peer(spawn.Name())
end

-- returns true if spawnID is in LoS
---@return boolean
function is_spawn_los(spawnID)
    local spawn = spawn_from_id(spawnID)
    return spawn ~= nil and spawn.LineOfSight()
end

-- returns true if spawnID is a NPC
---@return boolean
function is_npc(spawnID)
    local spawn = spawn_from_id(spawnID)
    return spawn ~= nil and spawn() ~= nil and (spawn.Type() == "NPC" or spawn.Type() == "Pet")
end

---@param spawnID integer
---@return spawn|nil
function spawn_from_id(spawnID)
    return spawn_from_query("id "..tostring(spawnID))
end

---@param name string
---@return spawn|nil
function spawn_from_peer_name(name)
    return spawn_from_query("pc =".. name)
end

-- Get the number of spawns matching `query`
---@return integer
function spawn_count(query)
    return mq.TLO.SpawnCount(query)()
end

---@param query string
---@return spawn|nil
function spawn_from_query(query)
    local o = mq.TLO.Spawn(query)
    if o() == nil then
        return nil
    end
    return o
end

--- Returns the name of the group priest curer, with a preference for SHM or DRU
---@return string|nil
function get_group_curer()
    local name = nil
    for i=1,mq.TLO.Group.Members() do
        local class = mq.TLO.Group.Member(i).Class.ShortName()
        if (class == "CLR") then
            name = mq.TLO.Group.Member(i).Name()
        end
    end

    for i=1,mq.TLO.Group.Members() do
        local class = mq.TLO.Group.Member(i).Class.ShortName()
        if class == "SHM" or class == "DRU" then
            name = mq.TLO.Group.Member(i).Name()
        end
    end
    return name
end

--- Returns the name of a nearby priest curer, with a preference for SHM or DRU
---@return string|nil
function get_nearby_curer()

    local spawnQuery = 'pc radius 100'

    local peers = spawn_count(spawnQuery)
    if peers == 0 then
        return nil
    end

    for i = 1, peers do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn ~= nil and spawn.ID() ~= nil then
            if spawn.Class.ShortName() == "CLR" or spawn.Class.ShortName() == "DRU" or spawn.Class.ShortName() == "SHM" then
                return spawn.Name()
            end
        end
    end
    return nil
end

--- Returns true if `id` is an item I have in inventory or in bank.
---@param id integer
---@return boolean
function have_item_id(id)
    return have_item_inventory_id(id) or have_item_banked_id(id)
end

--- Returns true if `name` is an item name I have in inventory or in bank.
---@param name string
---@return boolean
function have_item(name)
    return have_item_inventory(name) or have_item_banked(name)
end

-- Returns true if `name` is an item I have in inventory.
---@param name string
---@return boolean
function have_item_inventory(name)
    return name == nil or mq.TLO.FindItemCount("=" .. name)() > 0
end

-- Returns true if `id` is an item I have in inventory.
---@param id integer
---@return boolean
function have_item_inventory_id(id)
    return mq.TLO.FindItemCount(id)() > 0
end

-- Returns true if `name` is an item I have in bank.
---@param name string
---@return boolean
function have_item_banked(name)
    return mq.TLO.FindItemBankCount("=" .. name)() > 0
end

-- Returns true if `id` is an item I have in bank.
---@param id integer
---@return boolean
function have_item_banked_id(id)
    return mq.TLO.FindItemBankCount(id)() > 0
end

-- Returns number of items by EXACT NAME in bank.
---@param name string
---@return integer
function banked_item_count(name)
    return mq.TLO.FindItemBankCount("=" .. name)()
end

-- Returns number of items by EXACT NAME in inventory.
---@param name string
---@return integer
function inventory_item_count(name)
    return mq.TLO.FindItemCount("=" .. name)()
end

-- Returns true if I have item `name` equipped.
---@param name string
---@return boolean
function have_item_equipped(name)
    -- equipment: 0-22 is worn gear, 23-32 is inventory top level
    for i = 0, 22 do
        if mq.TLO.Me.Inventory(i).ID() ~= nil and mq.TLO.Me.Inventory(i).Name() == name then
            return true
        end
    end
    return false
end

-- Returns true if I have a target.
---@return boolean
function have_target()
    return mq.TLO.Target() ~= nil
end

-- Get the current target.
---@return spawn|nil
function get_target()
    if not have_target() then
        return nil
    end
    return mq.TLO.Target
end

-- Target NPC by name.
---@param name string
function target_npc_name(name)
    mq.cmdf('/target npc "%s"', name)
end

-- Target spawn by id.
---@param id integer
function target_id(id)
    if id ~= nil then
        mq.cmdf("/target id %d", id)
        mq.delay(10)
        mq.delay(1000, function() return mq.TLO.Target.ID() == id end)
    end
end

-- Partial search by name (inventory, bags). Will not search bank!
---@param name string
---@return item|nil
function find_item(name)
    local item = mq.TLO.FindItem(name)
    if item() ~= nil then
        return item
    end
    return nil
end

-- Partial search by name (banked items)
---@param name string
---@return item|nil
function find_item_bank(name)
    local item = mq.TLO.FindItemBank(name)
    if item() ~= nil then
        return item
    end
    return nil
end

-- Exact search by name, return item name (clickable item link if possible)
---@param name string
---@return string
function item_link(name)
    local item = find_item("="..name)
    if item == nil then
        return name
    end
    return item.ItemLink("CLICKABLE")()
end

-- Is `item` clicky effect ready to use?
---@param name string
---@return boolean
function is_item_clicky_ready(name)
    local item = find_item(name)
    if item == nil then
        return false
    end
    return item.Clicky() ~= nil and item.Timer.Ticks() == 0
end

-- Returns true if `name` is a spell currently memorized in a gem
---@param name string
---@return boolean
function is_memorized(name)
    return mq.TLO.Me.Gem(mq.TLO.Spell(name).RankName())() ~= nil
end

-- Is spell in my spellbook?
---@param name string
---@return boolean
function have_spell(name)
    if have_alt_ability(name) then
        -- NOTE: some AA's overlap with spell names.
        -- We work around this by pretending to lack those spells if we have the AA.
        -- Examples:
        -- CLR/06 Sanctuary / CLR Sanctuary AA
        -- SHM/62 Ancestral Guard / SHM Ancestral Guard AA
        -- SHD/60 Death Peace / SHD Death Peace AA
        return false
    end
    local ranked = mq.TLO.Spell(name).RankName()
    if mq.TLO.Me.Book(ranked)() ~= nil then
        return true
    end
    return mq.TLO.Me.Book(name)() ~= nil
end

-- Returns true if we have enough mana to cast `spell`
---@return boolean
function have_mana_for_spell(name)
    if not have_spell(name) then
        return false
    end
    local spell = mq.TLO.Spell(name)
    -- add 20 mana to spell cost to mitigate rof2 client being out of sync with server regen (oct 2023)
    return mq.TLO.Me.CurrentMana() > (20 + spell.Mana())
end

-- Is this a name of a spell?
---@param name string
---@return boolean
function is_spell(name)
    if have_alt_ability(name) then
        -- NOTE: some AA's overlap with spell names. Examples:
        -- CLR/06 Sanctuary / CLR Sanctuary AA
        -- SHM/62 Ancestral Guard / SHM Ancestral Guard AA
        return false
    end
    return mq.TLO.Spell(name)() ~= nil
end

---@param name string
---@return spell|nil
function get_spell(name)
    local spell = mq.TLO.Spell(name)
    if spell ~= nil then
        return mq.TLO.Spell(spell.RankName())
    end
    return nil
end

---@param id number spell id
---@return spell|nil
function get_spell_from_id(id)
    local spell = mq.TLO.Spell(id)
    if spell() ~= nil then
        return spell
    end
    return nil
end

-- Is spell `name` ready to cast?
---@param name string
---@return boolean
function is_spell_ready(name)
    if mq.TLO.Me.SpellInCooldown() then
        -- global cooldown
        return false
    end
    local spell = get_spell(name)
    if spell == nil then
        return false
    end
    return mq.TLO.Me.SpellReady(spell.RankName())()
end

-- Returns true if `name` is an AA that exists.
---@param name string
---@return boolean
function is_alt_ability(name)
    return mq.TLO.AltAbility(name)() ~= nil
end

-- Returns true if `name` is an AA that you have purchased.
---@param name string
---@return boolean
function have_alt_ability(name)
    return mq.TLO.Me.AltAbility(name)() ~= nil
end

-- Returns rank of AA `name`, or 0.
---@param name string
---@return integer
function alt_ability_rank(name)
    return toint(mq.TLO.Me.AltAbility(name).Rank())
end

-- Returns true if the AA `name` is ready to use.
---@param name string
---@return boolean
function is_alt_ability_ready(name)
    return mq.TLO.Me.AltAbilityReady(name)()
end

-- Returns true if I have the ability `name`.
---@param name string
---@return boolean
function have_ability(name)
    return mq.TLO.Me.Ability(name)()
end

-- Returns true if the ability `name` is ready to use.
---@param name string
---@return boolean
function is_ability_ready(name)
    return mq.TLO.Me.AbilityReady(name)()
end

-- Do we have combat ability `name`?
---@return boolean
function have_combat_ability(name)
    return mq.TLO.Me.CombatAbility(name)() ~= nil
end

-- Returns true if the combat ability `name` is ready to use.
---@param name string
---@return boolean
function is_combat_ability_ready(name)
    return mq.TLO.Me.CombatAbilityReady(name)()
end

---@param name string
function use_combat_ability(name)
    -- /disc argument MUST NOT use quotes
    mq.cmdf("/disc %s", name)
end

---@param name string
function use_ability(name)
    -- /doability argument MUST use quotes
    mq.cmdf('/doability "%s"', name)
end

-- Performs alt ability `name` unconditionally, including retrying and waiting until cast is completed before returning
---@param name string
---@param spawnID integer|nil
function use_alt_ability(name, spawnID)

    if not have_alt_ability(name) then
        all_tellf("\arERROR\ax: I do not have AA \ay%s\ax", name)
        return
    end
    if not is_alt_ability_ready(name) then
        all_tellf("\arERROR\ax: %s is not ready, ready in \ay%s\ax", name, mq.TLO.Me.AltAbilityTimer(name).TimeHMS())
        return
    end

    if not is_standing() then
        cmd("/stand")
    end

    if is_brd() then
        local exe = string.format('/medley queue "%s"', name)
        if spawnID ~= nil then
            exe = exe .. string.format(" -targetid|%d", spawnID)
        end
        cmd(exe)
    else
        wait_until_not_casting()

        local args = '"'..name..'" alt -maxtries|3'
        if spawnID ~= nil then
            args = args .. ' -targetid|'.. tostring(spawnID)
        end

        mq.cmdf("/casting %s", args)
    end

    mq.delay(500)
    mq.delay(20000, function() return not is_casting() end)
    mq.delay(500)
end

-- returns true if I have the buff `name` on me
---@param name string
---@return boolean
function have_buff(name)
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        --log.Debug("have_buff: spell didnt resolve for \ay%s", name)
        if not have_ability(name) and not have_item(name) and name ~= "Wondrous Rapidity" and name ~= "Wonderous Rapidity" then
            log.Debug("have_buff: asked about unrecognized buff \ay%s", name)
        end
        return false
    end
    if mq.TLO.Me.Buff(name)() == name then
        return true
    end
    return mq.TLO.Me.Buff(spell.RankName())() == name
end

-- returns true if I have the song `name` on me
---@param name string
---@return boolean
function have_song(name)
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        if not have_ability(name) and not have_item(name) then
            all_tellf("have_song ERROR, asked about odd buff %s", name)
        end
        return false
    end
    return mq.TLO.Me.Song(name)() ~= nil or mq.TLO.Me.Song(spell.RankName())() ~= nil
end

---@param name string
---@return boolean
function have_buff_or_song(name)
    return have_buff(name) or have_song(name)
end

-- returns true if my pet have the buff `name` on me
---@param name string
---@return boolean
function pet_have_buff(name)
    if name == nil then
        -- XXX backtrace and debug, should not happen!
        -- FIXME: sometimes trigger on MAG, don't know why yet
        all_tellf("pet_have_buff: ERROR input is nil, should not happen!")
        return false
    end
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        all_tellf("ERROR pet_have_buff odd buff %s", name)
        return false
    end
    if mq.TLO.Me.Pet.Buff(name)() ~= nil then
        return true
    end
    return mq.TLO.Me.Pet.Buff(spell.RankName())() == name
end

-- Am I casting a spell/song?
---@return boolean
function is_casting()
    return mq.TLO.Me.Casting() ~= nil
end

-- Pauses up to 60 seconds until casting current spell is finished
function wait_until_not_casting()
    mq.delay("60s", function() return is_brd() or not is_casting() end)
end

-- Am I moving?
---@return boolean
function is_moving()
    return mq.TLO.Me.Moving()
end

-- Am I standing?
---@return boolean
function is_standing()
    return mq.TLO.Me.Standing()
end

-- Am I sitting?
---@return boolean
function is_sitting()
    return mq.TLO.Me.Sitting()
end

-- Returns true if I am meditating (sitting and not max mana/end)
---@return boolean
function is_meditating()
    if mq.TLO.Me.MaxMana() > 0 and mq.TLO.Me.PctMana() == 100 then
        return false
    end
    if mq.TLO.Me.MaxMana() == 0 and mq.TLO.Me.PctEndurance() == 100 then
        return false
    end
    return mq.TLO.Me.Sitting()
end

-- Am I invisible?
---@return boolean
function is_invisible()
    return mq.TLO.Me.Invis()
end

-- Am I stunned?
---@return boolean
function is_stunned()
    return mq.TLO.Me.Stunned()
end

-- Am I feigning?
---@return boolean
function is_feigning()
    return mq.TLO.Me.Feigning()
end

-- Returns my class shortname, eg "WAR".
---@return string
function class_shortname()
    return mq.TLO.Me.Class.ShortName()
end

-- Returns my race shortname, eg "OGR".
---@return string
function race_shortname()
    return map_race_shortname(mq.TLO.Me.Race.Name())
end

-- Returns the race shortname, like HUM for Human.
---@param race string name
---@return string
function map_race_shortname(race)
    local map = {
        ["Barbarian"] = "BAR",
        ["Dark Elf"]  = "DEF",
        ["Drakkin"] = "DRK",
        ["Dwarf"] = "DWF",
        ["Erudite"] = "ERU",
        ["Froglok"] = "FRG",
        ["Gnome"] = "GNM",
        ["Half Elf"]  = "HEF",
        ["Halfling"] = "HFL",
        ["High Elf"] = "HIE",
        ["Human"] = "HUM",
        ["Iksar"] = "IKS",
        ["Ogre"] = "OGR",
        ["Troll"] = "TRL",
        ["Vah Shir"]  = "VAH",
        ["Wood Elf"]  = "ELF",
    }
    if map[race] == nil then
        log.Debug("map_race_shortname unmapped %s (not a player race)", race)
        return "UNKNOWN-RACE"
    end
    return map[race]
end

-- Am I a Bard?
---@return boolean
function is_brd()
    return mq.TLO.Me.Class.ShortName() == "BRD"
end

-- Am I a Warrior?
---@return boolean
function is_war()
    return mq.TLO.Me.Class.ShortName() == "WAR"
end

-- Am I a Paladin?
---@return boolean
function is_pal()
    return mq.TLO.Me.Class.ShortName() == "PAL"
end

-- Am I a Shadowknight?
---@return boolean
function is_shd()
    return mq.TLO.Me.Class.ShortName() == "SHD"
end

-- Am I a Rogue?
---@return boolean
function is_rog()
    return mq.TLO.Me.Class.ShortName() == "ROG"
end

-- Am I a Magician?
---@return boolean
function is_mag()
    return mq.TLO.Me.Class.ShortName() == "MAG"
end

-- Am I a Necromancer?
---@return boolean
function is_nec()
    return mq.TLO.Me.Class.ShortName() == "NEC"
end

-- Am I a Cleric?
---@return boolean
function is_clr()
    return mq.TLO.Me.Class.ShortName() == "CLR"
end

-- Am I a Druid?
---@return boolean
function is_dru()
    return mq.TLO.Me.Class.ShortName() == "DRU"
end

-- Am I a Shaman?
---@return boolean
function is_shm()
    return mq.TLO.Me.Class.ShortName() == "SHM"
end

-- Am I a Ranger?
---@return boolean
function is_rng()
    return mq.TLO.Me.Class.ShortName() == "RNG"
end

-- Am I a Wizard?
---@return boolean
function is_wiz()
    return mq.TLO.Me.Class.ShortName() == "WIZ"
end

-- Am I a Enchanter?
---@return boolean
function is_enc()
    return mq.TLO.Me.Class.ShortName() == "ENC"
end

-- Am I a Monk?
---@return boolean
function is_mnk()
    return mq.TLO.Me.Class.ShortName() == "MNK"
end

-- Am I a Beastlord?
---@return boolean
function is_bst()
    return mq.TLO.Me.Class.ShortName() == "BST"
end

-- Am I in a guild?
---@return boolean
function in_guild()
    return mq.TLO.Me.Guild() ~= nil
end

-- Am I in a raid?
---@return boolean
function in_raid()
    return mq.TLO.Raid.Members() > 0
end

-- Am I in a group?
---@return boolean
function in_group()
    return mq.TLO.Group.Members() > 0
end

-- Am I group leader?
---@return boolean
function is_group_leader()
    return mq.TLO.Group.Members() > 1 and mq.TLO.Group.Leader.Name() == mq.TLO.Me.Name()
end

-- Am I raid leader?
---@return boolean
function is_raid_leader()
    return mq.TLO.Raid.Members() > 1 and mq.TLO.Raid.Leader.Name() == mq.TLO.Me.Name()
end

--- Am I grouped with PC `name`?
---@return boolean
function is_grouped_with(name)
    if not in_group() then
        return false
    end
    return name == mq.TLO.Me.Name() or mq.TLO.Group.Member(name).ID() ~= nil
end

--- Am I in raid with PC `name`?
---@return boolean
function is_raided_with(name)
    if not in_raid() then
        return false
    end
    return name == mq.TLO.Me.Name() or mq.TLO.Raid.Member(name).ID() ~= nil
end

-- Am I hovering? (just died, waiting for rez in the same zone)
---@return boolean
function is_hovering()
    return window_open("RespawnWnd")
end

function is_gm()
    return mq.TLO.Me.GM()
end

-- Am I in combat?
---@return boolean
function in_combat()
    local xdist = mq.TLO.Me.XTarget(1).Distance()
    return mq.TLO.Me.Combat()
        or mq.TLO.Me.CombatState() == "COMBAT"
        or mq.TLO.Me.PctAggro() > 0
        or (xdist ~= nil and xdist < 200)
end

-- Is window `name` open?
---@param name string
---@return boolean
function window_open(name)
    return mq.TLO.Window(name).Open() == true
end

-- Close window by clicking on a button
---@param name string
function close_window(name)
    if not window_open(name) then
        return
    end
    mq.cmdf("/invoke ${Window[%s].DoClose}", name)
end

-- Returns true if any obstructive window is open (loot, trade, bank, merchant, spell book)
---@return boolean
function obstructive_window_open()
    return mq.TLO.Corpse.Open() or window_open("MerchantWnd") or window_open("GiveWnd") or window_open("BankWnd") or window_open("BigBankWnd")
        or window_open("SpellBookWnd") or window_open("LootWnd") or window_open("tradewnd")
        or window_open("ConfirmationDialogBox")
end

-- Opens merchant window with `spawn`.
---@param spawn spawn
function open_merchant_window(spawn)

    if spawn == nil or spawn() == nil then
        return
    end

    if window_open("MerchantWnd") then
        all_tellf("WARNING: A merchant window was already open. Closing it")
        close_window("MerchantWnd")
        mq.delay(1000)
    end

    if spawn.Distance() > 20 then
        log.Error("Too far away from merchant. Giving up")
        return
    end

    mq.cmdf("/target id %d", spawn.ID())

    local attempt = 1
    while true do

        if attempt >= 3 then
            all_tellf("ERROR: Giving up opening merchant window after %d attempts", attempt)
            break
        end

        if window_open("MerchantWnd") then
            break
        end

        -- Right click merchant, and wait for window to open.
        mq.cmd("/click right target")
        mq.delay(5000, function() return window_open("MerchantWnd") end)

        mq.delay(500)
        attempt = attempt +1
    end

    if not window_open("MerchantWnd") then
        log.Error("Giving up.. Could not open merchant window.")
    end

    -- Wait for merchant's item list to populate.
    local merchantTotal = -1
    attempt = 1
    while true do
        if attempt >= 10 then
            log.Error("Giving up listing merchant window items")
            break
        end

        if merchantTotal ~= mq.TLO.Window("MerchantWnd").Child("ItemList").Items() then
            merchantTotal = mq.TLO.Window("MerchantWnd").Child("ItemList").Items()
            log.Info("Merchant total: ", merchantTotal)
        end
        mq.delay(200)
        attempt = attempt +1
    end
end

-- Opens merchant with the nearest merchant.
function open_nearby_merchant()
    if window_open("MerchantWnd") then
        return
    end
    local merchant = spawn_from_query("Merchant radius 100")
    if merchant == nil then
        log.Error("No merchant nearby")
        return
    end

    log.Info("Opening trade window for merchant %s, type %s", merchant.Name(), type(merchant))

    move_to(merchant.ID())
    open_merchant_window(merchant)
end

-- lowercased zone shortnames
local neutralZones = { "guildlobby", "guildhall", "bazaar", "poknowledge", "potranquility", "nexus", "shadowrest" }

-- returns true if we are in a neutral zone
---@return boolean
function in_neutral_zone()
    local zone = zone_shortname():lower()
    for k, v in pairs(neutralZones) do
        if zone == v then
            return true
        end
    end
    return false
end

-- returns true if we allow to cast buffs in neutral zones (allowed on emu, disallowed on live)
---@return boolean
function allow_buff_in_zone()
    if is_rof2() then
        return true
    end
    return not in_neutral_zone()
end

-- opens all inventory bags
function open_bags()
    for i = 1, 10 do
        local pack = "Pack"..tostring(i)
        local slot = get_inventory_slot(pack)
        if slot ~= nil and is_container(slot) and not mq.TLO.Window(pack).Open() then
            mq.cmdf("/itemnotify %s rightmouseup", pack)
            mq.delay(1) -- this delay is needed to ensure /itemnotify is not called too fast
            mq.delay(1000, function() return mq.TLO.Window(pack).Open() end)
        end
    end
    mq.delay(1)
end

-- closes all inventory bags
function close_bags()
    for i = 1, 10 do
        local pack = "Pack"..tostring(i)
        local slot = get_inventory_slot(pack)
        if slot ~= nil and is_container(slot) and mq.TLO.Window(pack).Open() then
            mq.cmdf("/itemnotify %s rightmouseup", pack)
            mq.delay(1) -- this delay is needed to ensure /itemnotify is not called too fast
            mq.delay(1000, function() return not mq.TLO.Window(pack).Open() end)
        end
    end
    mq.delay(1)
end

---@return integer
function num_inventory_slots()
    -- TODO is number in a mq.TLO value?
    -- TODO return 8 on servers who only support it
    return 10
end

---@param name string
---@return item|nil
function get_inventory_slot(name)
    local v = mq.TLO.Me.Inventory(name)
    if v() == nil then
        return nil
    end
    return v
end

-- returns true if `item` is a container
---@param item item
---@return boolean
function is_container(item)
    return item ~= nil and item.Container() ~= 0
end

-- returns true if i have a pet
---@return boolean
function have_pet()
    return mq.TLO.Me.Pet.ID() ~= 0
end

-- returns true if `name` is a running Lua script
---@param name string
---@return boolean
function is_script_running(name)
    for pid in string.gmatch(mq.TLO.Lua.PIDs(), '([^,]+)') do
        ---@diagnostic disable-next-line: param-type-mismatch
        local luainfo = mq.TLO.Lua.Script(pid)
        if luainfo.Name() == name then
            return true
        end
    end
    return false
end

---@return boolean
function have_cursor_item()
    return mq.TLO.Cursor.ID() ~= nil
end

-- Returns the number of free inventory slots.
---@return integer
function free_inventory_slots()
    return mq.TLO.Me.FreeInventory()
end

--- This can happen if item cannot be worn by race/class combo but the worn slot is empty. /autoinv will try to equip
---@param item item | fun() : nil
---@return boolean
local function mustManualyEmptyCursor(item)
    if not item() then
        return false
    end

    if not item.Class(mq.TLO.Me.Class())() then
        return false
    end

    if not item.Race(mq.TLO.Me.Race())() then
        return false
    end

    for i = 1, item.WornSlots(), 1 do
        local wornslot = item.WornSlot(i)
        if wornslot() and not mq.TLO.Me.Inventory(wornslot.ID())() then
            return true
        end
    end

    return false
end

-- autoinventories all items on cursor. returns false on failure
---@param force? boolean
function clear_cursor(force)
    while true do
        local cursor = mq.TLO.Cursor

        if not force and obstructive_window_open() then
            if cursor() ~= nil then
                log.Warn("clear_cursor: aborting with %s on cursor!, obstructive window is open", cursor.Name())
            end
            return false
        end

        if cursor() == nil or cursor.ID() == nil then
            return true
        end

        if (mq.TLO.Me.FreeInventory() < 1 and not cursor.Stackable())
        or (mq.TLO.Me.FreeInventory() == 0 and cursor.Stackable() and cursor.FreeStack() == 0) then
            all_tellf("ERROR: Inventory full! Cannot auto-inventory %s", cursor.ItemLink("CLICKABLE")())
            --mq.cmd("/beep 1")
            return false
        end

        -- 77678 Molten Orb
        if not force and cursor.ID() ~= 77678 then
            all_tellf("Putting cursor item %s in inventory.", cursor.ItemLink("CLICKABLE")())
        end

        if mustManualyEmptyCursor(cursor) then
            local numberOfBagSlots = mq.TLO.Me.NumBagSlots()
            for i = 1, numberOfBagSlots do
                local inventoryItem = mq.TLO.Me.Inventory(i + 22)
                if inventoryItem() then
                    if inventoryItem.Container() > 0 then
                        if inventoryItem.Container() > inventoryItem.Items() and inventoryItem.SizeCapacity() >= cursor.Size() then
                            for p = 1, inventoryItem.Container() do
                                mq.cmdf("/nomodkey /itemnotify in pack%d %d leftmouseup", i, p)
                                break
                            end
                        end
                    else
                        mq.cmdf("/nomodkey /itemnotify pack%d leftmouseup", i)
                        break
                    end
                end
            end
        else
            mq.cmd("/autoinventory")
        end

        mq.delay(2000, function() return mq.TLO.Cursor.ID() == nil end)
        mq.delay(200)
    end
end

-- Guestimates if you are naked/waiting for rez (being "naked" will block buffing)
---@return boolean
function is_naked()
    if mq.TLO.Me.Inventory("chest").ID() == nil and mq.TLO.Me.Inventory("arms").ID() == nil and mq.TLO.Me.Inventory("legs").ID() == nil and mq.TLO.Me.Inventory("head").ID() == nil and mq.TLO.Me.Inventory("mainhand").ID() == nil then
        return true
    end
    return false
end

-- true if CLR,DRU,SHM
---@return boolean
function is_priest()
    return class_priest(mq.TLO.Me.Class.ShortName())
end

-- true if WIZ,MAG,ENC,NEC
---@return boolean
function is_caster()
    return class_caster(mq.TLO.Me.Class.ShortName())
end

-- true if BRD,BER,BST,MNK,PAL,RNG,ROG,SHD,WAR
---@return boolean
function is_melee()
    return class_melee(mq.TLO.Me.Class.ShortName())
end

-- true if PAL,SHD,RNG,BST
---@return boolean
function is_hybrid()
    return class_hybrid(mq.TLO.Me.Class.ShortName())
end

-- true if WAR,PAL,SHD
---@return boolean
function is_tank()
    return class_tank(mq.TLO.Me.Class.ShortName())
end

-- XXX add more:
-- Silk (ENC,MAG,NEC,WIZ)
-- Chain (ROG,BER,SHM,RNG)
-- Leather (DRU,BST,MNK)
-- Plate (WAR,BRD,CLR,PAL,SHD)
-- Knight (PAL,SHD)


-- true if BRD,BER,BST,MNK,PAL,RNG,ROG,SHD,WAR
---@param class string Class shortname.
---@return boolean
function class_melee(class)
    return class == "BRD" or class == "BER" or class == "BST" or class == "MNK" or class == "PAL" or class == "RNG" or class == "ROG" or class == "SHD" or class == "WAR"
end

-- true if PAL,SHD,RNG,BST
---@param class string Class shortname.
---@return boolean
function class_hybrid(class)
    return class == "PAL" or class == "SHD" or class == "RNG" or class == "BST"
end

-- true if CLR,DRU,SHM
---@param class string Class shortname.
---@return boolean
function class_priest(class)
    return class == "CLR" or class == "DRU" or class == "SHM"
end

-- true if WIZ,MAG,ENC,NEC
---@param class string Class shortname.
---@return boolean
function class_caster(class)
    return class == "WIZ" or class == "MAG" or class == "ENC" or class == "NEC"
end

-- true if WAR,PAL,SHD
---@param class string Class shortname.
---@return boolean
function class_tank(class)
    return class == "WAR" or class == "PAL" or class == "SHD"
end

-- true if class wears plate armor (WAR,PAL,SHD,CLR,BRD)
function class_plate(class)
    return class == "WAR" or class == "PAL" or class == "SHD" or class == "CLR" or class == "BRD"
end

-- true if class wears chain armor (RNG,ROG,SHM,BER)
function class_chain(class)
    return class == "RNG" or class == "ROG" or class == "SHM" or class == "BER"
end

-- true if class wears silk armor (WIZ,MAG,ENC,NEC)
function class_silk(class)
    return class == "WIZ" or class == "MAG" or class == "ENC" or class == "NEC"
end

-- true if class wears leather armor (DRU,MNK,BST)
function class_leather(class)
    return class == "DRU" or class == "MNK" or class == "BST"
end

---Get the current server name ("antonius" for Antonius Bayle)
---@return string
function current_server()
    return mq.TLO.MacroQuest.Server()
end

--@return string
function server_buffs_settings_file()
    return mq.TLO.MacroQuest.Server() .. "__Default Buffs.lua"
end

-- Returns a Level/Name compbo describing yourself, such as "WAR/100 Gimp"
---@return string
function present_myself()
    return string.format("%s/%d %s", mq.TLO.Me.Class.ShortName(), mq.TLO.Me.Level(), mq.TLO.Me.Name())
end

local baseSlots = { -- XXX this should be accessible from mq TLO ?
    [0] = "charm",
    [1] = "leftear",
    [2] = "head",
    [3] = "face",
    [4] = "rightear",
    [5] = "neck",

    [6] = "shoulder",
    [7] = "arms",
    [8] = "back",
    [9] = "leftwrist",
    [10] = "rightwrist",
    [11] = "ranged",
    [12] = "hands",
    [13] = "mainhand",
    [14] = "offhand",
    [15] = "leftfinger",
    [16] = "rightfinger",
    [17] = "chest",
    [18] = "legs",
    [19] = "feet",
    [20] = "waist",
    [21] = "powersource",
    [22] = "ammo",

    [23] = "pack1",
    [24] = "pack2",
    [25] = "pack3",
    [26] = "pack4",
    [27] = "pack5",
    [28] = "pack6",
    [29] = "pack7",
    [30] = "pack8",
    [31] = "pack9",
    [32] = "pack10",
}

-- returns a text representation of inventory slot id, see https://docs.macroquest.org/reference/general/slot-names/
---@param n integer
function inventory_slot_name(n)
    if baseSlots[n] ~= nil then
        return baseSlots[n]
    end
    -- true if item is on cursor
    all_tellf("ERROR: lookup inventory slot %d failed", n)
    return "UNKNOWN"
end

-- Makes character visible and drops sneak/hide.
function drop_invis()
    if is_rog() then
        if mq.TLO.Me.Sneaking() then
            log.Debug("ROG - Dropping Sneak")
            mq.cmd("/doability Sneak")
            mq.delay(2000)
        end
        if is_invisible() then
            log.Debug("ROG - dropping Hide")
            mq.cmd("/doability Hide")
            mq.delay(2000)
        end
    end

    mq.cmd("/makemevisible")
    mq.delay(2000, function() return not is_invisible() end)
    if is_invisible() then
        all_tellf("\arERROR\ax Cannot make myself visible.")
    end
end

-- Do I have the skill/language `name`?
---@param name string
---@return boolean
function have_skill(name)
    if have_language(name) then
        return true
    end
    local val = mq.TLO.Me.Skill(name)()
    if val == nil then
        all_tellf("UNLIKELY: queried for a skill that didnt resolve (maybe a typo?): %s", name)
        return false
    end
    return val > 0
end

-- Return my skill/language value.
---@param name string Kick, Taunt etc.
---@return integer|nil
function skill_value(name)
    if have_language(name) then
        return language_value(name)
    end
    return mq.TLO.Me.Skill(name)()
end

-- Return my skill/language cap
---@param name string Kick, Taunt etc.
---@return integer|nil
function skill_cap(name)
    local cap = mq.TLO.Me.SkillCap(name)()
    if cap == nil then
        if have_language(name) then
            return 100
        end
        -- NOTE: this might be a macroquest bug. if a language skill is learned while in game, that skill doesnt seem to be registered by macroquest /oct 2023
        log.Warn("skill_cap returned 0 for \ay%s\ax", name)
        return 0
    end
    return cap
end

-- Do I have the language `name`?
---@param name string
---@return boolean
function have_language(name)
    if mq.TLO.Me.Language(name)() == nil then
        return false
    end
    return mq.TLO.Me.Language(name)() > 0
end

-- Return my language cap
---@param name string
---@return integer
function language_value(name)
    return mq.TLO.Me.LanguageSkill(name)()
end

-- Returns true if plugin `name` is currently loaded.
---@param name string
---@return boolean
function plugin_loaded(name)
    return mq.TLO.Plugin(name)() ~= nil
end

-- Loads the plugin `name`.
---@param name string
function load_plugin(name)
    mq.cmdf("/plugin %s", name)
end

-- query a peer using MQ2DanNet
---@param peer string
---@param query string
---@param timeout? number defaults to 1000
function query_peer(peer, query, timeout)
    mq.cmdf('/dquery %s -q "%s"', peer, query)
    mq.delay(timeout or 1000)
    local value = mq.TLO.DanNet(peer).Q(query)()
    log.Debug("Querying \aymq.TLO.DanNet(%s).Q(%s)\ax = %s", peer, query, value)
    return value
end

local shortToLongClass = {
    CLR = "Cleric",
    DRU = "Druid",
    SHM = "Shaman",
    WAR = "Warrior",
    PAL = "Paladin",
    SHD = "Shadow Knight",
    BRD = "Bard",
    ROG = "Rogue",
    BER = "Berserker",
    MNK = "Monk",
    RNG = "Ranger",
    BST = "Beastlord",
    WIZ = "Wizard",
    MAG = "Magician",
    ENC = "Enchanter",
    NEC = "Necromancer",
}

-- returns the nearest peer by class shortname, or nil on failure
---@param shortClass string Class shortname.
---@return string|nil
function nearest_peer_by_class(shortClass)
    local longName = shortToLongClass[shortClass]
    if longName == nil then
        all_tellf("INVALID shortToLongClass %s", shortClass)
        return nil
    end

    local spawnQuery = 'pc notid '..mq.TLO.Me.ID()..' radius 100 class "'..longName..'"'
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        local peer = spawn.Name()
        if is_peer(peer) then
            return peer
        end
    end
    return nil
end

-- Seeds the current process with a value unlikely to be used by another process.
function seed_process()
    math.randomseed(mq.TLO.EverQuest.PID() + (os.clock() * 1000))
end

---@return boolean
function in_table(t, val)
    for k, v in pairs(t) do
        if v == val then
            return true
        end
    end
    return false
end

---@class SpellObject
---@field public Name string Spell name.
---@field public Shrink boolean This is a shrink effect
---@field public GoM boolean Only use if Gift of Mana is available.
---@field public NoAggro boolean Only use if not on aggro list.
---@field public NoPet boolean Only use if not having a pet.
---@field public Class string Class filter list.
---@field public NotClass string Class filter list.
---@field public Gem integer The spell gem to use for casting this spell. Default is 5.
---@field public Reagent string Required component in order to cast this spell.
---@field public CheckFor string Comma-separated list of effects on target. A match will block the spell from being cast.
---@field public MinMana integer % of minimum mana required to cast this spell.
---@field public MaxMana integer % of maximum mana required to cast this spell (eg. Cannibalization).
---@field public MinEnd integer % of minimum endurance required to cast this ability.
---@field public MinHP integer % of minimum HP required to cast this ability (eg. Cannibalization).
---@field public MaxHP integer % of maximum HP required to cast this ability (eg. Snare).
---@field public HealPct integer % of health threshold before heal is cast.
---@field public MinMobs integer Minimum number of mobs nearby required to cast this spell.
---@field public MaxMobs integer Maximum number of mobs nearby allowed to cast this spell.
---@field public MaxLevel integer Maximum level of target allowed to cast this spell.
---@field public MinPlayers integer Minimum number of players nearby required to cast this spell.
---@field public Zone integer Comma-separated list of zone short names where spell is allowed to cast.
---@field public MinLevel integer Minimum level.
---@field public PctAggro integer Skips cast if your aggro % is above threshold.
---@field public Summon string Name for summoning spell component, eg "Molten Orb/NoAggro/Summon|Summon: Molten Orb" (MAG).
---@field public MaxTries integer Max number of casts.
---@field public Cure string Type of cure (poison,disease,curse,any), for auto cures.
---@field public Group boolean This is a group spell (used for group cures for auto cure).
---@field public Self boolean This is a self spell (used for auto cure).
---@field public Only string /only|xxx filter
---@field public Not string /not|xxx filter
---@field public Delay integer Number of seconds between reuse of this spell/ability.
---@field public spellGroup string used internally

-- is turned into bools
local shortProperties = { "Shrink", "GoM", "NoAggro", "NoPet", "Group", "Self" }

-- is turned into integers
local intProperties = { "PctAggro", "MinMana", "MaxMana", "MinEnd", "MinHP", "MaxHP", "MaxLevel", "HealPct", "MinMobs", "MaxMobs", "MinPlayers", "MaxTries", "Delay" }

-- parses a spell/ability etc line with properties, returns a object
-- example in: "Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction"
---@param s string
---@return SpellObject
function parseSpellLine(s)

    local o = {}
    local tokens = split_str(s, "/")
    if #tokens == 1 and tokens[1] == "Shrink" then
        o.Name = tokens[1]
        o.Shrink = true
        return o
    end

    for k, token in pairs(tokens) do
        local found, _ = string.find(token, "|")
        if found then
            local key = ""
            local subIndex = 0
            for v in string.gmatch(token, "[^|]+") do
                if subIndex == 0 then
                    key = v
                end
                if subIndex == 1 then
                    if in_table(intProperties, key) then
                        v = toint(v)
                    end
                    o[key] = v
                end
                subIndex = subIndex + 1
            end
        else
            if in_table(shortProperties, token) then
                --print("allowed: ", token)
                o[token] = true
            else
                --print("assuming name: ", token)
                o.Name = token
            end
        end
    end

    if s == "" then
        o.Name = ""
    end

    if spellGroups[class_shortname()] ~= nil then
        local spellGroup = spellGroups[class_shortname()][o.Name]
        if spellGroup ~= nil then
            local spellObj = findBestSpellFromSpellGroup(o.Name)
            if spellObj ~= nil then
                local groupName = o.Name
                for k, v in pairs(spellObj) do
                    o[k] = v
                end
                o.spellGroup = groupName
            else
                all_tellf("ERROR: parseSpellLine: did not find a best spell for [+r+]spellGroups.%s.%s[+x+]", class_shortname(), o.Name)
            end
        end
    end
    return o
end

---@class FilterObject
---@field public Only string
---@field public Not string
---@field public Zone string space-separated zone shortnames
---@field public Instance string name of instance (aka Shared Task)

-- parses a filter line with properties, returns a object
-- example in: "/Only|WAR"
---@param s string
---@return FilterObject
function parseFilterLine(s)

    local o = {}
    local tokens = split_str(s, "/")

    for k, token in pairs(tokens) do
        --log.Debug("token: %s", token)
        if token ~= nil then
            local found, _ = string.find(token, "|")
            if found then
                local key = ucfirst(token:sub(1, found - 1))
                local val = token:sub(found + 1)
                --log.Debug("key = %s, val = %s", key, val)
                o[key] = val
            end
        end
    end

    return o
end

---@param s string
---@param sSeparator string
---@return table
function split_str(s, sSeparator)
    assert(sSeparator ~= '')
    local nMax = 10
    local aRecord = {}
    if s == nil then
        return aRecord
    end
    if string.len(s) > 0 then
        nMax = nMax or -1
        local nField, nStart = 1, 1
        local nFirst,nLast = string.find(s, sSeparator, nStart)
        while nFirst and nMax ~= 0 do
            table.insert(aRecord, string.sub(s, nStart, nFirst-1))
            nField = nField+1
            nStart = nLast+1
            nFirst,nLast = string.find(s, sSeparator, nStart)
            nMax = nMax-1
        end
        table.insert(aRecord, string.sub(s, nStart))
    end
    return aRecord
end

-- Returns the name of the best available rez for CLR/PAL, or nil if none
---@ return string|nil
function get_rez_spell()
    local rezSpells = nil
    if is_clr() then
        rezSpells = spellGroups.CLR.clr_rez
    elseif is_pal() then
        rezSpells = spellGroups.PAL.pal_rez
    else
        return nil
    end

    for k, rez in pairs(rezSpells) do
        if have_alt_ability(rez) or have_spell(rez) or have_item_inventory(rez) then
            return rez
        end
    end
    return nil
end

function write_ini(file, section, key, val)
    mq.cmdf('/ini "%s" "%s" "%s" "%s"', file, section, key, val)
end

-- Number of open buff slots (not counting the short duration buff slots).
---@return integer
function free_buff_slots()
    return mq.TLO.Me.FreeBuffSlots()
end

local auraNames = {
    "Myrmidon's Aura",      -- WAR/55: Increase Proc Modifier by 1%, Slot 12: 60 AC
    "Champion's Aura",      -- WAR/70: Increase Proc Modifier by 2%, Slot 12: 90 AC
    "Disciple's Aura",      -- MNK/55: 5% riposte, 5% parry, 5% block
    "Master's Aura",        -- MNK/70: 10% riposte, 10% parry, 10% block
    "Aura of Rage",         -- BER/55: Increase melee Critical Damage by 20%
    "Bloodlust Aura",       -- BER/70: Increase melee Critical Damage by 30%
    "Aura of Insight",      -- BRD/55: Spell Damage 1-15%, Melee Overhaste 15%
    "Aura of the Muse",     -- BRD/70: Spell Damage 1-30%, Melee Overhaste 25%
    "Aura of the Zealot",   -- CLR/55: Slot 2: Mitigate Melee Damage by 1%
    "Aura of the Pious",    -- CLR/70: Slot 2: Mitigate Melee Damage by 3%
    "Aura of the Grove",    -- DRU/55: Slot 11: +10 hp/tick, -2 disease counter
    "Aura of Life",         -- DRU/70: Slot 11: +30 hp/tick, -4 disease counter
    "Beguiler's Aura",      -- ENC/55: Slot 11: +4 mana/tick
    "Illusionist's Aura",   -- ENC/70: Slot 11: +6 mana/tick
    "Holy Aura",            -- PAL/55: Spell Damage 1-15%, Melee Overhaste 15%
    "Blessed Aura",         -- PAL/70: Spell Damage 1-30%, Melee Overhaste 25%
}

-- Finds the best available L55 or L70 aura for your class.
---@return string|nil
function find_best_aura()
    local aura = nil
    for k, name in pairs(auraNames) do
        if have_combat_ability(name) or have_spell(name) then
            aura = name
        end
    end
    return aura
end

-- Remove one item link from input text (returns item name).
---@param s string
---@return string
function strip_link(s)
    -- TODO: macroquest can expose existing functionality to lua, says brainiac. someone just need to write a patch
    if string.find(s, "000") then
        log.Debug("strip_link: detected item link %s", s)
        s = string.sub(s, 58, string.len(s) - 1)
    end
    return s
end

--- Returns true if `s` is a item link.
---@return boolean
function is_item_link(s)
    return s ~= strip_link(s)
end

-- Delay between 0 and `ms` milliseconds (random).
---@param ms integer milliseconds
function random_delay(ms)
    mq.delay(math.random(0, ms))
end

-- Delays a random amount of seconds in order not to flood the connection. 0.4s delay for each connected nearby peer.
--
-- Used to reduce CPU load while zoning many peers at once.
function unflood_delay()
    local count = peer_count()
    local players = spawn_count("pc radius 100")
    if players < count then
        count = players
    end
    if count < 12 then
        count = 12
    end
    random_delay(count * 200) -- minimum 12*200 = 2,4s cap
end

-- Returns true if `name` is ready to use.
---@param name string Name of aa, spell, combat ability, ability or item clicky.
---@return boolean
function is_spell_ability_ready(name)
    if not is_brd() and is_casting() then
        return false
    end
    if is_alt_ability_ready(name) then
        --log.Debug("is_spell_ability_ready aa TRUE", name)
        return true
    end
    if is_memorized(name) and is_spell_ready(name) then
        --log.Debug("is_spell_ability_ready spell TRUE", name)
        return true
    end
    if is_combat_ability_ready(name) then
        --log.Debug("is_spell_ability_ready combat ability TRUE", name)
        return true
    end
    if is_ability_ready(name) then
        --log.Debug("is_spell_ability_ready ability TRUE", name)
        return true
    end
    if is_item_clicky_ready(name) then
        --log.Debug("is_spell_ability_ready item TRUE", name)
        return true
    end
    return false
end

-- Returns true if I know `name`.
---@param name string Name of aa, spell, combat ability, ability or item clicky.
---@return boolean
function known_spell_ability(name)
    if have_alt_ability(name) then
        --print("known_spell_ability aa TRUE", name)
        return true
    end
    if have_spell(name) then
        --print("known_spell_ability spell TRUE", name)
        return true
    end
    if have_combat_ability(name) then
        --print("known_spell_ability combat ability TRUE", name)
        return true
    end
    if have_ability(name) then
        --print("known_spell_ability ability TRUE", name)
        return true
    end
    if have_item_inventory(name) then
        --print("known_spell_ability item TRUE", name)
        return true
    end
    return false
end

-- Remove all buffs from yourself.
function drop_all_buffs()
    for i = 1, mq.TLO.Me.MaxBuffSlots() do
        if mq.TLO.Me.Buff(i).ID() ~= nil then
            --log.Debug("Removing buff %s", mq.TLO.Me.Buff(i).Name())
            mq.cmdf('/removebuff "%s"', mq.TLO.Me.Buff(i).Name())
        end
    end
end

-- Remove all buffs from yourself that does not stack with spell `name`.
---@param name string
function drop_buffs_not_stacking_with(name)
    for i = 1, mq.TLO.Me.MaxBuffSlots() do
        if mq.TLO.Me.Buff(i).ID() ~= nil then
            if not mq.TLO.Me.Buff(i).WillStack(name) then
                all_tellf("drop_buffs_not_stacking_with: removing %s, will not stack with %s", mq.TLO.Me.Buff(i).Name(), name)
                mq.cmdf('/removebuff "%s"', mq.TLO.Me.Buff(i).Name())
            end
        end
    end
end

-- for rof2 emu. toggles tribute through the Tribute window
function toggleTribute()
    if not window_open("TributeBenefitWnd") then
        cmd("/keypress TOGGLE_TRIBUTEBENEFITWIN")
        delay(50)
    end
    cmd("/notify TBW_PersonalPage TBWP_ActivateButton leftmouseup")
    delay(50)
    cmd("/keypress TOGGLE_TRIBUTEBENEFITWIN")
end

-- returns a table with class shortname booleans wether nearby peers are of desired classes.
function find_available_classes()
    local o = {}
    local spawnQuery = "pc notid " .. mq.TLO.Me.ID()
    for i = 1, spawn_count(spawnQuery) do
        local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
        if spawn ~= nil then
            if is_peer(spawn.Name()) then
                o[spawn.Class.ShortName()] = true
            end
        end
    end
    return o
end

-- Returns the current zone short name.
---@return string
function zone_shortname()
    return mq.TLO.Zone.ShortName()
end

function trim(s)
    return s:match("^%s*(.-)%s*$")
end

--- collect arg into query, needed for /fdi water flask to work without quotes
function args_string(...)
    local s = ""
    for i = 1, select("#",...) do
        s = s ..  select(i,...) .. " "
    end
    return trim(s)
end

-- Check wether our class/race/name matches the given filter
---@param filter string A filter, such as "/only|WAR", or "/not|casters"
---@param sender string Peer name of sender
---@return boolean true if we match filter
function matches_filter(filter, sender)
    local filterConfig = parseFilterLine(filter)
    if filterConfig.Only ~= nil and not matches_filter_line(filterConfig.Only, sender) then
        return false
    end
    if filterConfig.Not ~= nil and matches_filter_line(filterConfig.Not, sender) then
        return false
    end
    return true
end

---@return boolean true if we match
---@param line string A filter argument, like "casters WAR BRD"
---@param sender string Peer name of sender
function matches_filter_line(line, sender)

    local spawn = spawn_from_query(sender)
    if spawn == nil or spawn() == nil then
        all_tellf("\arERROR failed to look up spawn %s", sender)
        return false
    end
    local class = spawn.Class.ShortName()
    local race = map_race_shortname(spawn.Race.Name())

    local tokens = split_str(line, " ")
    for k, v in pairs(tokens) do
        if class == v:upper() or race == v:upper() or v:lower() == mq.TLO.Me.Name():lower() or (v == "me" and is_orchestrator()) then
            return true
        end
        if v == "group" and is_grouped_with(sender) then
            return true
        end
        if v == "raid" and is_raided_with(sender) then
            return true
        end
        if (v == "priest" or v == "priests") and class_priest(class) then
            return true
        end
        if (v == "caster" or v == "casters") and class_caster(class) then
            return true
        end
        if (v == "tank" or v == "tanks") and class_tank(class) then
            return true
        end
        if (v == "melee" or v == "melees") and class_melee(class) then
            return true
        end
        if (v == "hybrid" or v == "hybrids") and class_hybrid(class) then
            return true
        end
        if v == "plate" and class_plate(class) then
            return true
        end
        if v == "chain" and class_chain(class) then
            return true
        end
        if v == "silk" and class_silk(class) then
            return true
        end
        if v == "leather" and class_leather(class) then
            return true
        end
     end
    return false
end

function hex_dump(str)
    local len = string.len( str )
    local dump = ""
    local hex = ""
    local asc = ""

    for i = 1, len do
        if 1 == i % 8 then
            dump = dump .. hex .. asc .. "\n"
            hex = string.format( "%04x: ", i - 1 )
            asc = ""
        end

        local ord = string.byte( str, i )
        hex = hex .. string.format( "%02x ", ord )
        if ord >= 32 and ord <= 126 then
            asc = asc .. string.char( ord )
        else
            asc = asc .. "."
        end
    end

    return dump .. hex
            .. string.rep( "   ", 8 - len % 8 ) .. asc
end

--- Upper-cases the first letter of input string
function ucfirst(s)
    return (s:gsub("^%l", string.upper))
end

-- removes server name part from a dannet peer name, and capitalizes it
function strip_dannet_peer(s)
    local pos = string.find(s, "_")
    if pos ~= nil then
        s = string.sub(s, pos + 1)
    end
    return ucfirst(s)
end

function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

-- Returns "true" or "false".
--
-- For debug printing booleans, since lua 5.1 does not have a string format way for booleans.
---@param b boolean
---@return string
function bools(b)
    return tostring(b)
end

-- Creates a integer from a string with a decimal number, or a float
---@param s string|number
---@return integer
function toint(s)
    if type(s) == "string" then
        local n = tonumber(s)
        if n == nil then
            return 0
        end
        return n + 0
    end
    if s == nil then
        return 0
    end
    return s + 0
end

---Performs an ingame slash action provided as a string.
---@param command string An in-game slash command (including the slash) (e.g. '/keypress DUCK').
function cmd(command)
    --log.Debug("/cmd %s", command)
    mq.cmd(command)
end

---Similar to cmd() but provides C/C++ string formatting.
---@param command string An in-game slash command (including the slash) (e.g. '/keypress %s').
---@param ...? any Variables that provide input the formated string.
function cmdf(command, ...)
    --log.Debug("/cmdf %s", command)
    mq.cmdf(command, ...)
end

---Process queued events.
---@param name? string Optional name of a single Event to process.
function doevents(name)
    mq.doevents(name)
end

---Provides a Timing delay.
---@param delayValue number|string A number (milliseconds) or string ending in s, m, or ms (e.g. '2s' or '1m').
---@param condition? function An optional condition that can end the delay early with a return of true.
function delay(delayValue, condition)
    mq.delay(delayValue, condition)
end

---@param cmd string
---@param fn fun(...)
function bind(cmd, fn)
    mq.unbind(cmd)
    mq.bind(cmd, fn)
end

function efyranConfigDir()
    return mq.TLO.MacroQuest.Path("config")() .. "\\efyran"
end

local castSpellAbilityTimers = {}
function resetCastSpellAbilityTimers()
    castSpellAbilityTimers = {}
end

---@param spawnID integer|nil
---@param row string
---@param callback? fun(): boolean
---@return boolean true if spell/ability was cast
function castSpellAbility(spawnID, row, callback)

    local spell = parseSpellLine(row)

    --log.Debug("castSpellAbility %s, row = %s", spell.Name, row)

    if have_ability(spell.Name) and not is_ability_ready(spell.Name) then
        --log.Debug("castSpellAbility skip ABILITY %s, not ready!", spell.Name)
        return false
    end

    if have_combat_ability(spell.Name) and have_buff_or_song(spell.Name) then
        --log.Debug("castSpellAbility skip COMBAT-ABILITY %s, have buff!", spell.Name)
        return false
    end

    if spell.PctAggro ~= nil and mq.TLO.Me.PctAggro() < spell.PctAggro then
        -- PctAggro skips cast if your aggro % is above threshold
        --log.Debug("SKIP PctAggro %s aggro %d vs required %d", spell.Name, mq.TLO.Me.PctAggro(), spell.PctAggro)
        return false
    end
    if spell.PctAggro ~= nil and mq.TLO.Me.PctAggro() >= spell.PctAggro then
        log.Debug("WILL USE %s, PctAggro is %d vs required %d", spell.Name, mq.TLO.Me.PctAggro(), spell.PctAggro)
    end
    if spell.NoAggro ~= nil and spell.NoAggro and mq.TLO.Me.TargetOfTarget.ID() == mq.TLO.Me.ID() then
        -- NoAggro skips cast if you are on top of aggro
        log.Info("SKIP NoAggro %s, i have aggro", spell.Name)
        return false
    end

    if spell.GoM ~= nil and spell.GoM and not have_song("Gift of Mana") then
        return false
    end

    if spell.MinMana ~= nil and mq.TLO.Me.PctMana() < spell.MinMana then
        --log.Debug("SKIP MinMana %s, %d vs required %d", spell.Name,  mq.TLO.Me.PctMana(), spell.MinMana)
        return false
    end

    if spell.MaxMana ~= nil and mq.TLO.Me.PctMana() > spell.MaxMana then
        --log.Debug("SKIP MaxMana %s, %d vs required %d", spell.Name,  mq.TLO.Me.PctMana(), spell.MaxMana)
        return false
    end

    if spell.MinEnd ~= nil and mq.TLO.Me.PctEndurance() < spell.MinEnd then
        --log.Debug("SKIP MinEnd %s, %d vs required %d", spell.Name,  mq.TLO.Me.PctEndurance(), spell.MinEnd)
        return false
    end

    if spell.MinHP ~= nil and mq.TLO.Me.PctHPs() > spell.MinHP then
        -- eg. Cannibalize if we have enough HP %
        log.Debug("SKIP MinHP %s, %d vs required %d", spell.Name,  mq.TLO.Me.PctHPs(), spell.MinHP)
        return false
    end

    if spell.Summon ~= nil and inventory_item_count(spell.Name) == 0 then
        log.Info("SKIP Summon %s, missing summoned item mid-fight", spell.Name)
        return false
    end

    if spell.NoPet ~= nil and spell.NoPet and have_pet() then
        all_tellf("SKIP NoPet, i have a pet up")
        return false
    end

    if spell.MinMobs ~= nil and nearby_npc_count(75) < spell.MinMobs then
        -- only cast if at least this many NPC:s is nearby
        --log.Debug("SKIP MinMobs, need %d (has %d)", spell.MinMobs, nearby_npc_count(75))
        return false
    end

    if spell.MaxMobs ~= nil and nearby_npc_count(75) > spell.MaxMobs then
        -- only cast if at most this many NPC:s is nearby
        all_tellf("SKIP MaxMobs %s, Too many nearby mobs. Have %d, need %d", spell.Name, spawn_count(nearbyNPCFilter),  spell.MaxMobs)
        return false
    end

    if spell.MinPlayers ~= nil and nearby_player_count(75) < spell.MinPlayers then
        -- only cast if at least this many players is nearby (eg Stonewall)
        all_tellf("SKIP MinPlayers, need %d (has %d)", spell.MinPlayers, nearby_player_count(75))
        return false
    end

    if not have_spell(spell.Name) and have_item_inventory(spell.Name) and not is_item_clicky_ready(spell.Name) then
        -- Item and spell examples: Molten Orb (MAG)
        log.Debug("SKIP cast, item clicky not ready: %s", spell.Name)
        return false
    end

    local spawn = spawn_from_id(spawnID)
    if spawn ~= nil and spawn() ~= nil then
        if spell.MaxHP ~= nil and spawn.PctHPs() > spell.MaxHP then
            -- eg. Snare mob at low health
            log.Debug("SKIP MaxHP %s, %d %% HP vs required %d", spell.Name, spawn.PctHPs(), spell.MaxHP)
            return false
        end

        local filterSpawn = spawn.DisplayName()
        if is_npc(spawn.ID()) then
            filterSpawn = mq.TLO.Me.Name()
        end
        if not matches_filter(row, filterSpawn) then
            -- so nukes with "/Not|raid" works, check vs PEER and not TARGET
            log.Debug("SKIP cast %s (filterSpawn \ay%s\ax, target \ay%s\ax), not matching %s", spell.Name, filterSpawn, spawn.Name(), row)
            return false
        end

        if spell.MaxLevel ~= nil and spawn.Level() > spell.MaxLevel then
            -- eg. skip Stun if target is too high level
            log.Debug("SKIP MaxLevel %s, %d vs required %d", spell.Name, spawn.Level(), spell.MaxLevel)
            return false
        end

        if is_peer(spawn.Name()) then
            local pct = peer_hp(spawn.Name())
            if spell.HealPct ~= nil and pct > spell.HealPct then
                log.Debug("castSpellAbility skip use of %s, peer %s hp %d%% vs required %d%%", spell.Name, spawn.Name(), pct, spell.HealPct)
                return false
            end
        end

        if spell.Group and not is_grouped_with(spawn.Name()) then
            all_tellf("SKIP Group, i am not grouped with %s (spell %s)", spawn.Name(), spell.Name)
            return false
        end

        if spell.Self and spawn.Name() ~= mq.TLO.Me.Name() then
            all_tellf("SKIP Self, cant cast on %s (spell %s)", spawn.Name(), spell.Name)
            return false
        end
    end

    -- Delay must be the last check as it resets the cast timer
    if spell.Delay ~= nil then
        local t = castSpellAbilityTimers[row]
        if t == nil then
            castSpellAbilityTimers[row] = timer.new(spell.Delay)
        else
            if not castSpellAbilityTimers[row]:expired() then
                return false
            end
            log.Info("Timer expired, restarting for \ay%s\ax (%d sec)", spell.Name, spell.Delay)
            castSpellAbilityTimers[row]:restart()
        end
    end

    --log.Debug("castSpellAbility START CAST %s", spell.Name)
    if not is_standing() then
        mq.cmd("/stand")
        mq.delay(50)
    end

    castSpell(spell.Name, spawnID)

    -- delay until done casting
    if callback == nil then
        callback = function()
            if spawnID == nil then
                return true
            end
            local spawn1 = spawn_from_id(spawnID)
            return spawn1 == nil or spawn1() == nil or spawn1.Type() == "Corpse" or not is_casting()
        end
    end

    delay(200)
    delay(10000, callback)
    --log.Debug("castSpellAbility: Done waiting after cast.")
    return true
end

-- Unconditionally performs a spell cast. For processing spellRows, use castSpellAbility() instead !!!
--
-- helper for casting spell, clicky, AA, combat ability
-- returns true if spell was cast (special case 'false' on instant-cast clickies)
---@param name string spell name
---@param spawnID integer|nil
---@return boolean
function castSpell(name, spawnID)

    if have_combat_ability(name) then
        use_combat_ability(name)
        return true
    elseif have_ability(name) then
        --log.Debug("calling use_ability \ay%s\ax", name)
        use_ability(name)
        return true
    end

    --log.Debug("castSpell ITEM/SPELL/AA: %s", name)

    if is_brd() then
        local exe = string.format('/medley queue "%s"', name)
        if spawnID ~= nil then
            exe = exe .. string.format(" -targetid|%d", spawnID)
        end
        cmd(exe)
        return true
    end

    local extra = ""
    if not have_spell(name) and have_item_inventory(name) then
        -- Item and spell examples: Molten Orb (MAG)
        if not is_item_clicky_ready(name) then
            -- eg Worn Totem, with 4 min buff duration and 10 min recast
            return false
        end
        extra = "|item"
    end

    if is_sitting() then
        cmd("/stand")
    end

    castSpellRaw(name..extra, spawnID, "-maxtries|3")

    local instant = false

    if have_item_inventory(name) then
        -- item click
        local item = find_item(name)
        if item ~= nil then
            --log.Debug("item clicky %s cast time %d", name, item.CastTime())
            if item.CastTime() <= 100 then -- 0.1s
                instant = true
            end
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
            if spell.MyCastTime() <= 100 then -- 0.1s
                instant = true
            end
        end
    end

    if instant then
        -- don't signal cast delays for instant clickies
        return false
    end

    return true
end

---@param name string spell name
---@param spawnID integer|nil
---@param extraArgs string|nil
function castSpellRaw(name, spawnID, extraArgs)
    local exe = string.format('/casting "%s"', name)
    if spawnID ~= nil then
        exe = exe .. string.format(" -targetid|%d", spawnID)
    end
    if extraArgs ~= nil then
        exe = exe .. " " .. extraArgs
    end
    --log.Debug("-- castSpellRaw: %s", exe)
    cmdf(exe)

    -- a small delay so spell starts to be cast
    delay(400)
end


---@param targetId number
---@return boolean
function EnsureTarget(targetId)
    if not targetId then
        log.Debug("Invalid <targetId>")
        return false
    end

    if mq.TLO.Target.ID() ~= targetId then
        if mq.TLO.SpawnCount(string.format("id %d", targetId))() > 0 then
            mq.cmdf("/target id %s", targetId)
            mq.delay(500, function() return mq.TLO.Target.ID() == targetId end)
        else
            log.Warn("EnsureTarget has no spawncount for target id %d", targetId)
        end
    end

    return mq.TLO.Target.ID() == targetId
end

--- Returns true if spawn might be aggro (for classic)
---@param spawn spawn
---@return boolean
function IsMaybeAggressive(spawn)
    if spawn.Aggressive() then
        return true
    end

    local spawnAnimation = spawn.Animation();
    if not spawnAnimation then
        return false
    end

    local possibleAggroAnimations = {5,8,12,17,18,32,42,44,80,106,129,144}
    for index, value in ipairs(possibleAggroAnimations) do
        if value == spawnAnimation then
            return true
        end
    end

    return false
end

-- Memorizes given spell and waits until it is memorized
-- Returns nil on error
---@param spellRow string Example: "War March of Muram/Gem|4"
---@param defaultGem integer|nil Use nil for the default gem 5
--@return integer|nil
function memorize_spell(spellRow, defaultGem)
    local o = parseSpellLine(spellRow)

    if not have_spell(o.Name) then
        all_tellf("ERROR don't know spell/song [+r+]%s[+x+]", o.Name)
        mq.cmd("/beep 1")
        return nil
    end

    if mq.TLO.Corpse.Open() or window_open("MerchantWnd") or window_open("GiveWnd")
    or window_open("BankWnd") or window_open("BigBankWnd") or window_open("LootWnd")
    or window_open("tradewnd") or window_open("ConfirmationDialogBox") then
        log.Error("Cannot memorize %s, obstructive window is open!", o.Name)
        return nil
    end

    local gem = defaultGem
    if o.Gem ~= nil then
        gem = o.Gem
    elseif botSettings.settings.gems ~= nil then
        if botSettings.settings.gems[o.Name] ~= nil then
            gem = botSettings.settings.gems[o.Name]
        elseif botSettings.settings.gems[o.spellGroup] ~= nil then
            gem = botSettings.settings.gems[o.spellGroup]
        end
    end
    if gem == nil then
        all_tellf("\arWARN\ax: Spell/song lacks gems default slot or Gem|n argument: %s", spellRow)
        gem = 5
    end

    -- make sure that spell is memorized the required gem, else scribe it
    local nameWithRank = mq.TLO.Spell(o.Name).RankName()
    if mq.TLO.Me.Gem(gem).Name() ~= nameWithRank then
        log.Info("Memorizing \ag%s\ax in gem %d (had \ay%s\ax)", nameWithRank, gem, mq.TLO.Me.Gem(gem).Name())
        mq.cmdf('/memorize "%s" %d', nameWithRank, gem)
        mq.delay("10s", function() return mq.TLO.Me.Gem(nameWithRank)() ~= nil end)
        mq.delay(500)
        local waitForReady = mq.TLO.Spell(o.Name).RecoveryTime()
        mq.delay(waitForReady)
    end

    return gem
end

-- returns true if shield is equipped
function has_shield_equipped()
    return mq.TLO.Me.Inventory("offhand").Type() == "Shield"
end

-- retrurns name and price
function get_best_soulstone()
    local level = mq.TLO.Me.Level()

    if level <= 20 then
        return "Minor Soulstone", 12
    elseif level <= 30 then
        return "Lesser Soulstone", 28
    elseif level <= 40 then
        return "Soulstone", 55
    elseif level <= 50 then
        return "Greater Soulstone", 87
    elseif level <= 55 then
        return "Faceted Soulstone", 120
    elseif level <= 70 then
        return "Pristine Soulstone", 165
    elseif level <= 75 then
        return "Glowing Soulstone", 265
    elseif level <= 80 then
        return "Prismatic Soulstone", 425
    elseif level <= 85 then
        return "Iridescent Soulstone", 530
    elseif level <= 90 then
        return "Phantasmal Soulstone", 635
    elseif level <= 95 then
        return "Luminous Soulstone", 750
    elseif level <= 100 then
        return "Coalescent Soulstone", 865
    else
        -- TODO update with L100 to L130 names
        all_tellf("get_best_soulstone: FATAL ERROR TOO HIGH LEVEL %d", level)
    end
end

---@return integer
function peer_count()
    return mq.TLO.NetBots.Counts()
end

---@param peer string
---@param spellName string
---@return boolean
function peer_has_buff(peer, spellName)
    local spell = get_spell(spellName)
    if spell == nil or spell() == nil then
        return false
    end
    ---@type string
    local buffs = mq.TLO.NetBots(peer).Buff() -- string of buff id:s
    local tokens = split_str(buffs, " ")
    for k, v in pairs(tokens) do
        if toint(v) == spell.ID() then
            return true
        end
    end
    return false
end

---@param peer string
---@param spellName string
---@return boolean
function peer_has_song(peer, spellName)
    local spell = get_spell(spellName)
    return spell ~= nil and spell() ~= nil and mq.TLO.NetBots(peer).ShortBuff.Find(spell.ID())() ~= nil
end

-- Returns the current HP % for given `peer`
---@param peer string
---@return integer
function peer_hp(peer)
    local pct = mq.TLO.NetBots(peer).PctHPs()
    if pct == "NULL" then
        -- XXX should not happen
        all_tellf("FATAL peer_hp returned NULL for %s", peer)
        return 100
    end
    return toint(pct)
end

-- Returns the short zonename for given `peer`
---@param peer string
---@return string
function peer_zone(peer)
    local id = mq.TLO.NetBots(peer).Zone()
    return mq.TLO.Zone(id).ShortName()
end

-- returns table with peers
function get_peers()
    local peers = {}
    for i = 1, mq.TLO.NetBots.Counts() do
        local peer = mq.TLO.NetBots.Client(i)()
        table.insert(peers, peer)
    end
    return peers
end

function ucfirst(s)
    return s:sub(1,1):upper()..s:sub(2)
end

---@param radius integer
function nearby_npc_count(radius)
    return spawn_count(string.format("npc radius %d zradius 15", radius))
end

---@param radius integer
function nearby_player_count(radius)
    return spawn_count(string.format("pc radius %d zradius 15", radius))
end

-- report peers out of range or in another zone
function count_peers()

    local min_distance = 50
    local peers = get_peers()
    local sum = 0

    for i, peer in pairs(peers) do
        if is_peer_in_zone(peer) then
            local spawn = spawn_from_peer_name(peer)
            if spawn ~= nil then
                local dist = spawn.Distance()
                if dist > min_distance then
                    log.Warn("COUNT: \ay%s\ax at \ay%d\ax distance %s", peer, dist, spawn.HeadingTo.ShortName())
                elseif not spawn.LineOfSight() then
                    log.Warn("COUNT: \ay%s\ax at \ay%d\ax distance %s \arnot LoS\ax", peer, dist, spawn.HeadingTo.ShortName())
                else
                    sum = sum + 1
                end
            else
                log.Error("COUNT UNLIKELY ERROR: failed to resolve peer %s", peer)
            end
        else
            local zone = peer_zone(peer)
            log.Info("COUNT: \ay%s\ax is in zone \ar%s\ax", peer, zone)
        end
    end

    if sum ~= #peers then
        log.Warn("COUNT SUMMARY: %d of %d peers present", sum, #peers)
    else
        log.Info("COUNT SUMMARY: \agAll %d peers present!\ax", sum)
    end
end

---@param cat string Descriptive category
function findBestClickyWithEffectGroup(cat, effects)
    local best = 0
    local name = nil
    for effect, power in pairs(effects) do
        --log.Debug("Effect %s  ...", effect)
        local itemName = findItemWithEffect(effect)
        if itemName ~= nil and power > best then
            log.Info("Found item \ag%s\ax with effect \ay%s\ax (%d)", itemName, effect, power)
            best = power
            name = itemName
        end
    end

    if best == 0 then
        return nil
    end

    if name ~= nil and not have_item_inventory(name) and not is_naked() then
        all_tellf("ERROR: my best \ar%s\ax clicky is banked. Put it in inventory for use! (item %s, power %d)", cat, name, best)
        mq.cmd("/beep")
        return nil
    end

    return name
end

local manaRegenEffects = {
    ["Lunar Whispers"]            = 2,  -- slot 8: 2 mana regen. Items: Earring of Spirited Mind (ldon)
    ["Koadic's Heightened Focus"] = 5,  -- slot 8: 5 mana regen. Items: Koadic's Robe of Heightened Focus (ssra)
    ["Aura of Eternity"]          = 5,  -- slot 8: 5 mana regen, slot 10: 5 hp regen. Items: Celestial Cloak (pop bert)
    ["Aura of Taelosia"]          = 7,  -- slot 8: 7 mana regen, slot 10: 7 hp regen. Items: Pendant of Discord (tacvi)
    ["Maelin's Methodical Mind"]  = 8,  -- slot 8: 8 mana regen, slot 10: 5 hp regen. Items: Shawl of Eternal Forces (potime)
    ["Reyfin's Random Musings"]   = 9,  -- slot 8: 9 mana regen, slot 10: 6 hp regen. Items: Earring of Pain Deliverance (tacvi)
    ["Chaotic Enlightenment"]     = 10, -- slot 8: 10 mana regen, slot 10: 6 hp regen. Items: Earring of Dragonkin (anguish)
}

-- Mana regen (slot 8) or Mana+HP regen (slot 8 and 10) clickies
---@return string|nil
function FindBestManaRegenClicky()
    if not is_caster() and not is_priest() and not is_hybrid() then
        return nil
    end
    return findBestClickyWithEffectGroup("manaregen", manaRegenEffects)
end

local manaPoolEffects = {
    ["Koadic's Expansive Mind"]  = 250, -- slot 4: 250 max mana. Items: Shield of Mental Fortitude (ssra)
    ["Maelin's Meditation"]      = 400, -- slot 4: 400 max mana. Items: Eye of Dreams (potime), Muramite Signet Orb (wos)
    ["Reyfin's Racing Thoughts"] = 450, -- slot 4: 450 max mana. Items: Xxeric's Matted-Fur Mask (tacvi)
}

-- Mana pool (slot 4) clickies
---@return string|nil
function FindBestManaPoolClicky()
    if not is_caster() and not is_priest() then
        return nil
    end
    return findBestClickyWithEffectGroup("manapool", manaPoolEffects)
end

-- XXX other attack line: Grim Aura +
--"Reaper's Ring/CheckFor|Strength of Tunare", -- +10 atk (slot 1) - Grim Aura
--"Totem of Elitist Rites/CheckFor|Strength of Tunare", -- Aura of Rage - 20 atk (slot 1)
local attackEffects = {
    ["Savage Guard"]  = 25, -- slot 5: 25 attack. Items: Serrated Dart of Energy (potime), Irestone Band of Rage (ikkinz 3 raid)
    ["Furious Might"] = 40, -- slot 5: 40 attack. Items: Veil of Intense Evolution (mpg raid)
}

--- Attack (slot 5) clickies
---@return string|nil
function FindBestAttackClicky()
    if not is_melee() then
        return nil
    end
    return findBestClickyWithEffectGroup("attack", attackEffects)
end

-- stacks with all resists player buffs. DONT STACK WITH Form of Defense
local allResistsEffects = {
    ["Eternal Ward"] = 15, -- slot 1: 15 all resists, slot 10: 45 ac. Items: Prismatic Ring of Resistance (potime), Lavender Cloak of Destruction (uqua)
    ["Chaotic Ward"] = 20, -- slot 1: 20 all resists, slot 10: 67 ac. Items: Necklace of the Steadfast Spirit (anguish)
}

-- All resists (slot 1) clickies
---@return string|nil
function FindBestAllResistsClicky()
    return findBestClickyWithEffectGroup("all-resists", allResistsEffects)
end

local formOfEnduranceEffects = {
    ["Form of Endurance II"]  = 180, -- slot 6: immunity, slot 5: 180 max hp. Items: Veil of the Inferno (potime)
    ["Form of Endurance III"] = 270, -- slot 6: immunity, slot 5: 270 max hp. Items: Ring of the Beast (anguish)
}
function FindBestFormOfEnduranceClicky()
    return findBestClickyWithEffectGroup("form-of-endurance", formOfEnduranceEffects)
end

local formOfDefenceEffects = {
    ["Form of Defense III"] = 81,  -- slot 6: immunity, slot 10: 81 ac. Items: Hanvar's Hoop (anguish)
}
function FindBestFormOfDefenseClicky()
    return findBestClickyWithEffectGroup("form-of-defense", formOfDefenceEffects)
end

-- returns the name of the first item found with listed effect
---@return string|nil
function findItemWithEffect(effect)
    -- equipment: 0-22 is worn gear, 23-32 is inventory top level
    for i = 0, 32 do
        if mq.TLO.Me.Inventory(i).ID() then
            local inv = mq.TLO.Me.Inventory(i)
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    if item.Clicky() ~= nil and item.Clicky.Spell.Name() == effect then
                        return item.Name()
                    end
                end
            else
                if inv.Clicky() ~= nil and inv.Clicky.Spell.Name() == effect then
                    return inv.Name()
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
                    if item.Clicky() ~= nil and item.Clicky.Spell.Name() == effect then
                        return item.Name()
                    end
                end
            else
                if inv.Clicky() ~= nil and inv.Name() == effect then
                    return inv.Name()
                end
            end
        end
    end
    return nil
end

-- Calculates resist cap at Level 70
-- Returns true if my resists are capped
---@return boolean
function capped_resists()
    local cap = 550 -- base resist cap at L70

    local mpgRank = alt_ability_rank("Trials of Mata Muram")
    cap = cap + math.ceil(4.16 * mpgRank)

    local aaRank = alt_ability_rank("Discordant Defiance")
    cap = cap + (5 * aaRank)
    --log.Info("capped_resists = %f", cap)
    return mq.TLO.Me.svPrismatic() >= cap
end

-- Returns true if clicked
---@param itemName string
---@return boolean
function refresh_buff_clicky(itemName)
    --log.Info("refresh_buff_clicky %s", itemName)
    if itemName == nil then
        return false
    end
    local item = find_item("="..itemName)
    if item == nil then
        all_tellf("UNLIKELY: refresh_buff_clicky find_item fail %s", itemName)
        return false
    end
    --log.Info("refresh_buff_clicky %s (%s)", itemName, tostring(item.Clicky.Spell.Name()))
    if not have_buff(item.Clicky.Spell.Name()) then
        if free_buff_slots() <= 0 then
            all_tellf("ERROR: would refresh buff %s (%s) but no buff slots", item.Clicky.Spell.Name(), itemName)
            return false
        end
        log.Info("Refreshing clicky buff \ag%s\ax (%s) ...", item.Clicky.Spell.Name(), itemName)
        click_item(itemName)
        return true
    end
    return false
end

-- Clicks a item
---@param itemName string
function click_item(itemName)
    local item = find_item("="..itemName)
    if item == nil then
        all_tellf("FATAL: click_item not found %s", itemName)
        return
    end

    if is_brd() then
        mq.cmdf('/medley queue "%s"', itemName)
        return true
    end

    mq.cmdf('/casting "%s" item', itemName)
    mq.delay(100)

    mq.delay(item.CastTime())
end

-- Opens bank window, by summoning a clockwork banker if needed
-- Returns true on success
---@return boolean
local bankerQuery = "npc radius 100 banker"
function open_banker()
    local bankerPetQuery = "pet radius 100 banker" -- summoned banker is a pet

    local bankWnd = "BigBankWnd"
    if not serverSettings.bigBank then
        bankWnd = "BankWnd"
    end

    if not window_open(bankWnd) then
        if spawn_count(bankerQuery) == 0 and spawn_count(bankerPetQuery) == 0 and have_alt_ability("Summon Clockwork Banker") then
            log.Info("Summoning a banker ...")
            cmd("/banker")
            delay(1000)

            if spawn_count(bankerQuery) == 0 and spawn_count(bankerPetQuery) == 0 then
                log.Error("No banker nearby! Giving up!")
                return false
            end
        end
        log.Info("Opening nearby banker ...")

        local bankerID = 0
        if spawn_count(bankerQuery) > 0 then
            bankerID = mq.TLO.Spawn(bankerQuery).ID()
        elseif spawn_count(bankerPetQuery) > 0 then
            bankerID = mq.TLO.Spawn(bankerPetQuery).ID()
        end

        cmdf("/target id %d", bankerID)
        move_to(bankerID)
        delay(10)

        cmd("/click right target")
        delay(250)
    end

    if not window_open(bankWnd) then
        log.Error("Bank window not open! Giving up!")
        return false
    end
    return true
end

function close_bank_window()
    local bankWnd = "BigBankWnd"
    if not serverSettings.bigBank then
        bankWnd = "BankWnd"
    end
    close_window(bankWnd)
end
