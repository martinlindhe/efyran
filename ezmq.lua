-- collection of functions to simplify working with macroquest through Lua

-- @type mq
local mq = require("mq")

-- returns true if `spawn` is within maxDistance
---@param spawn spawn
---@param maxDistance number
---@return boolean
function is_within_distance(spawn, maxDistance)
    return spawn.Distance() <= maxDistance
end

-- Am I the foreground instance?
---@return boolean
function is_orchestrator()
    return mq.TLO.FrameLimiter.Status() == "Foreground"
end

-- returns true if location is within maxDistance
---@return boolean
function is_within_distance_to_loc(y, x, z, maxDistance)
    return mq.TLO.Math.Distance(y, x, z) <= maxDistance
end

-- returns true if there is line of sight between you and `spawn`
---@param spawn spawn
---@return boolean
function line_of_sight_to(spawn)
    local q = mq.TLO.Me.Y()..","..mq.TLO.Me.X()..","..mq.TLO.Me.Z()..":"..spawn.Y()..","..spawn.X()..","..spawn.Z()
    return mq.TLO.LineOfSight(q)()
end

-- moves to the location of `spawn` using MQ2MoveUtils
---@param spawn spawn
function move_to(spawn)
    print("move_to ", spawn.Name())

    if not line_of_sight_to(spawn) then
        mq.cmd.dgtell("all move_to ERROR: cannot see", spawn.Name())
        mq.cmd.beep(1)
        return
    end

    mq.cmd.moveto("loc "..spawn.Y().." "..spawn.X())
    mq.delay(10000, function() return is_within_distance(spawn, 15) end)
    mq.cmd.moveto("off")
end

---@param y number
---@param x number
---@param z number
function move_to_loc(y, x, z)
    mq.cmd.moveto("loc "..y.." "..x)
    mq.delay(10000, function() return is_within_distance_to_loc(y, x, z, 15) end)
    mq.cmd.moveto("off")
end

-- Does `t` contain `v`?
---@param t table
---@param v any
---@return boolean
function in_array(t, v)
    for i=1,#t do
        if v == t[i] then return true end
    end
    return false
end

---@return boolean
function is_rof2()
    -- XXX hack, will be able to check if on emu with MacroQuest.Build value soon
    --  ? value == 1 is live (?), value 2 is test, 3 is beta, 4 is rof2-emu
    -- XXX BEST YET: MacroQuest.BuildName is a text string (Live, Test, Beta, Emu) ? 21 aug '22, not yet in master branch
    if mq.TLO.EverQuest.Server() == "antonius" then
        return false
    end
    return true
end

-- returns true if peerName is another peer
---@param peerName string
---@return boolean
function is_peer(peerName)
    return mq.TLO.DanNet(peerName)() ~= nil
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

---@param spawnID integer
---@return spawn|nil
function spawn_from_id(spawnID)
    return spawn_from_query("id "..tostring(spawnID))
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

---@param name string
---@return spawn|nil
function spawn_from_peer_name(name)
    return spawn_from_query("pc =".. name)
end

-- returns true if `name` is an item i have
---@return boolean
function have_item(name)
    return mq.TLO.FindItemCount("=" .. name)() > 0
end

-- return true if peer has a target
---@return boolean
function has_target()
    return mq.TLO.Target() ~= nil
end

-- Get the current target
---@return spawn|nil
function get_target()
    if not has_target() then
        return nil
    end
    return mq.TLO.Target
end

-- Target NPC by name
---@param name string
function target_npc_name(name)
    mq.cmd("/target npc "..name)
end

-- Target spawn by id
---@param id integer
function target_id(id)
    mq.cmd("/target id "..tostring(id))
    mq.delay(10)
    mq.delay(1000, function() return mq.TLO.Target.ID() == tonumber(id) end)
end

-- Partial search by name
---@param name string
---@return item|nil
function get_item(name)
    if mq.TLO.FindItem(name).ID() ~= nil then
        return mq.TLO.FindItem(name)
    end
    return nil
end

-- Partial search by name, return item name (clickable link if possible)
---@param name string
---@return string
function item_link(name)
    local item = get_item(name)
    if item == nil then
        return name
    end
    return item.ItemLink("CLICKABLE")()
end

-- Is `item` clicky effect ready to use?
---@param name string
---@return boolean
function is_item_clicky_ready(name)
    local item = get_item(name)
    if item == nil then
        mq.cmd.dgtell("all ERROR: is_item_clicky_ready() called with item I do not have:", name)
        return false
    end
    return item.Clicky() ~= nil and item.Timer.Ticks() == 0
end

-- returns true if `name` is a spell currently memorized in a gem
---@param name string
---@return boolean
function is_memorized(name)
    return mq.TLO.Me.Gem(mq.TLO.Spell(name).RankName)() ~= nil
end

-- Is spell in my spellbook?
---@param name string
---@return boolean
function is_spell_in_book(name)
    if is_alt_ability(name) then
        -- NOTE: some AA's overlap with spell names. use is_alt_ability() to distinguish. Examples:
        -- CLR/06 Sanctuary / CLR Sanctuary AA
        -- SHM/62 Ancestral Guard / SHM Ancestral Guard AA
        return false
    end
    return mq.TLO.Me.Book(mq.TLO.Spell(name).RankName)() ~= nil
end

-- Is this a name of a spell?
---@param name string
---@return boolean
function is_spell(name)
    if is_alt_ability(name) then
        -- NOTE: some AA's overlap with spell names. use is_alt_ability() to distinguish. Examples:
        -- CLR/06 Sanctuary / CLR Sanctuary AA
        -- SHM/62 Ancestral Guard / SHM Ancestral Guard AA
        return false
    end
    return mq.TLO.Spell(name)() ~= nil
end

---@param name string
---@return spell|nil
function get_spell(name)
    if mq.TLO.Spell(name).ID() ~= nil then
        return mq.TLO.Spell(mq.TLO.Spell(name).RankName)
    end
    return nil
end

-- Is spell `name` ready to cast?
---@param name string
---@return boolean
function is_spell_ready(name)
    local spell = get_spell(name)
    if spell == nil then
        return false
    end
    return mq.TLO.Me.SpellReady(spell.RankName)()
end

-- exact search by name
---@param name string
---@return integer
function getItemCountExact(name)
    if mq.TLO.FindItem("="..name).ID() ~= nil then
        return mq.TLO.FindItemCount("="..name)()
    end
    return 0
end

-- returns true if `name` is an AA that you have purchased
---@param name string
---@return boolean
function is_alt_ability(name)
    return mq.TLO.Me.AltAbility(name)() ~= nil
end

-- returns true if the AA `name` is ready to use
---@param name string
---@return boolean
function is_alt_ability_ready(name)
    return mq.TLO.Me.AltAbilityReady(name)()
end

-- returns true if I have the ability `name`
---@param name string
---@return boolean
function is_ability(name)
    return mq.TLO.Me.Ability(name)()
end

-- returns true if the ability `name` is ready to use
---@param name string
---@return boolean
function is_ability_ready(name)
    return mq.TLO.Me.AbilityReady(name)()
end

---@param name string
---@param spawnID integer
function cast_alt_ability(name, spawnID)

    if is_brd() and is_casting() then
        mq.cmd.twist("stop")
        mq.delay(100)
    end

    local cmd = '/casting "'..name..'|alt'
    if spawnID ~= nil then
        cmd = cmd .. ' -targetid|'.. tostring(spawnID)
    end

    mq.cmd(cmd)
    mq.delay(1000)
    mq.delay(20000, function() return not is_casting() end)

    if is_brd() then
        local item = get_item(name)
        if item ~= nil then
            -- item click
            print("cast_alt_ability item click sleep, ", item.Clicky.CastTime(), " + ", item.Clicky.Spell.RecastTime() )
            mq.delay(item.Clicky.CastTime() + item.Clicky.Spell.RecastTime() + 1500) -- XXX recast time is 0
        else
            -- spell / AA
            local spell = get_spell(name)
            if spell ~= nil then
                local sleepTime = spell.MyCastTime() + spell.RecastTime()
                --print("spell sleep for '", spell.Name(), "', my cast time:", spell.MyCastTime(), ", recast time", spell.RecastTime(), " = ", sleepTime)
                mq.delay(sleepTime)
            end
        end
        print("ME BARD cast_alt_ability ", name, " -- SO I RESUME TWIST!")
        mq.cmd.twist("start")
    end
end

-- returns true if I have the buff `name` on me
---@param name string
---@return boolean
function have_buff(name)
    --assert(type(name) == "string")
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        mq.cmd.dgtell("all have_buff ERROR: asked about odd 1buff", name)
        return false
    end
    if mq.TLO.Me.Buff(name)() == name then
        return true
    end
    return mq.TLO.Me.Buff(spell.RankName)() == name
end

-- returns true if I have the song `name` on me
---@param name string
---@return boolean
function have_song(name)
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        mq.cmd.dgtell("all BEEP error, asked about odd 2buff", name)
        mq.cmd.beep(1)
        return false
    end
    return mq.TLO.Me.Song(name)() ~= nil or mq.TLO.Me.Song(spell.RankName)() ~= nil
end

-- Am I casting a spell/song?
---@return boolean
function is_casting()
    return mq.TLO.Me.Casting() ~= nil
end

-- pauses until casting current spell is finished
function wait_until_not_casting()
    mq.delay(20000, function() return not is_casting() end)
end

-- Am I moving?
---@return boolean
function is_moving()
    return mq.TLO.Me.Moving()
end

-- Am I sitting?
---@return boolean
function is_sitting()
    return mq.TLO.Me.Sitting()
end

-- Am I a Bard?
---@return boolean
function is_brd()
    return mq.TLO.Me.Class.ShortName() == "BRD"
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

-- Am I hovering? (just died, waiting for rez in the same zone)
---@return boolean
function is_hovering()
    return window_open("RespawnWnd")
end

-- Is window `name` open?
---@param name string
---@return boolean
function window_open(name)
    return mq.TLO.Window(name).Open() == true
end

-- Opens merchant window with `spawn`.
---@param spawn spawn
function open_merchant_window(spawn)

    if window_open("MerchantWnd") then
        mq.cmd.dgtell("all WARNING: A merchant window was already open. Closing it")
        close_merchant_window()
        mq.delay(1000)
    end

    if spawn.Distance() > 20 then
        print("Too far away from merchant. Giving up")
        return
    end

    mq.cmd.target("id", spawn.ID())

    local attempt = 1
    while true do

        if attempt >= 3 then
            mq.cmd.dgtell("all Giving up opening merchant window after", attempt, "attempts")
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
        print("Giving up.. Could not open merchant window.")
    end

    -- Wait for merchant's item list to populate.
    local merchantTotal = -1
    attempt = 1
    while true do
        if attempt >= 10 then
            print("Giving up listing merchant window items")
            break
        end

        if merchantTotal ~= mq.TLO.Window("MerchantWnd").Child("ItemList").Items() then
            merchantTotal = mq.TLO.Window("MerchantWnd").Child("ItemList").Items()
            print("Merchant total: ", merchantTotal)
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
        print("ERROR no merchant nearby")
        return
    end

    print("OPENING TRADE WITH MERCHANT ", merchant, " ", type(merchant))

    move_to(merchant)
    open_merchant_window(merchant)
end

-- Close currently open merchant window.
function close_merchant_window()
    if not window_open("MerchantWnd") then
        return
    end
    mq.cmd("/notify MerchantWnd MW_Done_Button leftmouseup")
end

-- returns true if we are in a neutral zone (be less obvious on live)
---@return boolean
function in_neutral_zone()
    if is_rof2() then
        -- ignore neutral zone check on emu.
        return false
    end
    local neutralZones = { "guildlobby", "guildhall", "bazaar", "poknowledge", "potranquility", "nexus" }
    for k, v in pairs(neutralZones) do
        if mq.TLO.Zone.ShortName():lower() == v:lower() then
            return true
        end
    end
    return false
end

-- opens all inventory bags
function open_bags()
    for i = 1, 10 do
        local pack = "Pack"..tostring(i)
        local slot = get_inventory_slot(pack)
        if is_container(slot) and not mq.TLO.Window(pack).Open() then
            mq.cmd("/itemnotify "..pack.." rightmouseup")
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
        if is_container(slot) and mq.TLO.Window(pack).Open() then
            mq.cmd("/itemnotify "..pack.." rightmouseup")
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
        local luainfo = mq.TLO.Lua.Script(pid)
        if luainfo.Name() == name then
            return true
        end
    end
    return false
end

-- returns a comma-separated list of all running scripts, except for `name`.
---@param name string
function get_running_scripts_except(name)
    local others = ""
    for pid in string.gmatch(mq.TLO.Lua.PIDs(), '([^,]+)') do
        local luainfo = mq.TLO.Lua.Script(pid)
        if luainfo.Name() ~= name then
            others = others .. ", " .. luainfo.Name()
        end
    end
    return others
end

---@return boolean
function has_cursor_item()
    return mq.TLO.Cursor.ID() ~= nil
end

-- autoinventories all items on cursor. returns false on failure
function clear_cursor()
    while true do
        if mq.TLO.Cursor.ID() == nil then
            --print("cursor clear. ending")
            return true
        end
        if mq.TLO.Me.FreeInventory() == 0 then
            mq.cmd.dgtell("all Cannot clear cursor, no free inventory slots")
            mq.cmd.beep(1)
            return false
        end
        mq.cmd.dgtell("all XXX:Putting cursor item ", mq.TLO.Cursor(), " in inventory.")
        mq.cmd("/autoinventory")
        mq.delay(10000, function() return mq.TLO.Cursor.ID() == nil end)
        mq.delay(100)
        mq.doevents()
    end
end

---@param name string
function cast_veteran_aa(name)
    if is_alt_ability(name) then
        if is_alt_ability_ready(name) then
            cast_alt_ability(name, mq.TLO.Me.ID())
        else
            mq.cmd.dgtell("all", "ERROR:", name, "is not ready, ready in", mq.TLO.Me.AltAbilityTimer(name).TimeHMS() )
        end
    else
        mq.cmd.dgtell("all", "ERROR: I do not have AA", name)
    end
end

---@return boolean
function me_healer()
    return is_healer(mq.TLO.Me.Class.ShortName())
end

---@return boolean
function me_priest()
    return is_priest(mq.TLO.Me.Class.ShortName())
end

---@return boolean
function me_tank()
    return is_tank(mq.TLO.Me.Class.ShortName())
end

-- XXX add more:
-- Silk (ENC,MAG,NEC,WIZ)
-- Chain (ROG,BER,SHM,RNG)
-- Leather (DRU,BST,MNK)
-- Plate (WAR,BRD,CLR,PAL,SHD)
-- Knight (PAL,SHD)
-- Melee (BRD,BER,BST,MNK,PAL,RNG,ROG,SHD,WAR)
-- Hybrid (PAL,SHD,RNG,BST)

-- true if CLR,DRU,SHM,PAL,RNG,BST
---@param class string Class shortname.
---@return boolean
function is_healer(class)
    if class == nil then
        mq.cmd.dgtell("all is_healer called without class. did you mean me_healer() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM" or class == "PAL" or class == "RNG" or class == "BST"
end

-- true if CLR,DRU,SHM
---@param class string Class shortname.
---@return boolean
function is_priest(class)
    if class == nil then
        mq.cmd.dgtell("all is_priest called without class. did you mean me_priest() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM"
end

-- true if WAR,PAL,SHD
---@param class string Class shortname.
---@return boolean
function is_tank(class)
    if class == nil then
        mq.cmd.dgtell("all ERROR: is_tank called without class. did you mean me_tank() ?")
        mq.cmd.beep(1)
    end
    return class == "WAR" or class == "PAL" or class == "SHD"
end

---Get the current server name
---@return string
function current_server()
    return mq.TLO.MacroQuest.Server()
end

--@return string
function peer_settings_file()
    return mq.TLO.MacroQuest.Server() .. "_" .. mq.TLO.Me.Class.ShortName() .. "_" .. mq.TLO.Me.Name() .. ".lua"
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
    mq.cmd.dgtell("all ERROR: lookup inventory slot", n, "failed")
end

-- Makes character visible and drops sneak/hide.
function drop_invis()
    if mq.TLO.Me.Class.ShortName() == "ROG" then
        if mq.TLO.Me.Sneaking() then
            print("ROG - Dropping Sneak")
            mq.cmd("/doability Sneak")
            mq.delay(2000)
        end
        if mq.TLO.Me.Invis() then
            print("ROG - dropping Hide")
            mq.cmd("/doability Hide")
            mq.delay(2000)
        end
    end
    mq.cmd("/makemevisible")

    mq.delay(1000, function() return not mq.TLO.Me.Invis() end)

    if mq.TLO.Me.Invis() then
        mq.cmd.beep()
        mq.cmd.dgtell("all FATAL ERROR unhandled invis buff on me!")
    end
end

---@param name string
---@return boolean
function is_plugin_loaded(name)
    return mq.TLO.Plugin(name)() ~= nil
end

---@param name string
function load_plugin(name)
    mq.cmd("/plugin "..name)
end

-- query a peer using MQ2DanNet
---@param peer string
---@param query string
---@param timeout number
function query_peer(peer, query, timeout)
    mq.cmdf('/dquery %s -q "%s"', peer, query)
    mq.delay(timeout or 0)
    local value = mq.TLO.DanNet(peer).Q(query)()
    --print(string.format('\ayQuerying - mq.TLO.DanNet(%s).Q(%s) = %s', peer, query, value))
    return value
end

local shortToLongClass = {
    ["CLR"] = "Cleric",
    ["DRU"] = "Druid",
    ["SHM"] = "Shaman",
    ["WAR"] = "Warrior",
    ["PAL"] = "Paladin",
    ["SHD"] = "Shadow Knight",
    ["BRD"] = "Bard",
    ["ROG"] = "Rogue",
    ["BER"] = "Berserker",
    ["MNK"] = "Monk",
    ["RNG"] = "Ranger",
    ["BST"] = "Beastlord",
    ["WIZ"] = "Wizard",
    ["MAG"] = "Magician",
    ["ENC"] = "Enchanter",
    ["NEC"] = "Necromancer",
}

-- returns the nearest peer by class shortname, or nil on failure
---@param shortClass string Class shortname.
function nearest_peer_by_class(shortClass)
    local longName = shortToLongClass[shortClass]
    if longName == nil then
        mq.cmd.dgtell("all INVALID shortToLongClass ", shortClass)
        return nil
    end

    local o = {}
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
---@field public Shrink boolean
---@field public GoM boolean
---@field public NoAggro boolean
---@field public NoPet boolean


local shortProperties = { "Shrink", "GoM", "NoAggro", "NoPet" }
-- parses a spell/ability etc line with properties, returns a object
-- example in: "Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction"
---@param s string
---@return SpellObject
function parseSpellLine(s)

    local o = {}
    local idx = 0

    -- split on / separator
    local tokens = split_str(s, "/")

    for k, token in pairs(tokens) do
        idx = idx + 1
        --print("token ", idx, ": ", token)

        -- separate token on | "key" + "val"
        local found, _ = string.find(token, "|")
        if found then
            local key = ""
            local subIndex = 0
            for v in string.gmatch(token, "[^|]+") do
                if subIndex == 0 then
                    key = v
                end
                if subIndex == 1 then
                    --print(key, " = ", v)
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

    return o
end

---@param s string
---@param sSeparator string
---@return table
function split_str(s, sSeparator)
    assert(sSeparator ~= '')
    local nMax = 10
    local aRecord = {}
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
