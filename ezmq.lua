-- collection of functions to simplify working with macroquest through Lua
mq = require("mq")

-- returns true if i am the foreground instance
function is_orchestrator()
    return mq.TLO.FrameLimiter.Status() == "Foreground"
end

-- returns true if `spawn` is within maxDistance
function is_within_distance(spawn, maxDistance)
    return spawn.Distance() <= maxDistance
end

-- returns true if location is within maxDistance
function is_within_distance_to_loc(y, x, maxDistance)
    return mq.TLO.Math.Distance(y, x) <= maxDistance
end

-- returns true if there is line of sight between you and `spawn`
function line_of_sight_to(spawn)
    local q = mq.TLO.Me.Y()..","..mq.TLO.Me.X()..","..mq.TLO.Me.Z()..":"..spawn.Y()..","..spawn.X()..","..spawn.Z()
    return mq.TLO.LineOfSight(q)()
end

-- moves to the location of `spawn` using MQ2MoveUtils
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

function move_to_loc(y, x)
    mq.cmd.moveto("loc "..y.." "..x)
    mq.delay(10000, function() return is_within_distance_to_loc(y, x, 15) end)
    mq.cmd.moveto("off")
end

-- returns true if t contains v, false otherwise.
function in_array(t, v)
    for i=1,#t do
        if v == t[i] then return true end
    end
    return false
end

function is_rof2()
    -- XXX hack, will be able to check if on emu with MacroQuest.Build value soon
    --  ? value == 1 is live (?), value 2 is test, 3 is beta, 4 is rof2-emu
    -- XXX BEST YET: MacroQuest.BuildName is a text string (Live, Test, Beta, Emu) ? 21 aug '22, not yet in master branch
    if mq.TLO.EverQuest.Server() == "antonius" then
        return false
    end
    return true
end

-- returns true if spawn is another peer
function is_peer(spawn)
    if spawn == nil or spawn.Type() ~= "PC" then
        return false
    end
    return mq.TLO.DanNet(spawn.Name())() ~= nil
end

-- returns true if spawnID is another peer
function is_peer_id(spawnID)
    return is_peer(spawn_from_id(spawnID))
end

-- returns true if spawnID is in LoS
function is_spawn_los(spawnID)
    local spawn = spawn_from_id(spawnID)
    return spawn ~= nil and spawn.LineOfSight()
end

-- return spawn or nil
function spawn_from_id(spawnID)
    return spawn_from_query("id ".. spawnID)
end

-- return number. the number of spawns matching `query`
function spawn_count(query)
    return mq.TLO.SpawnCount(query)()
end

function spawn_from_query(query)
    --print("spawn_from_query: ", query)
    local o = mq.TLO.Spawn(query)
    if o() == nil then
        return nil
    end
    return o
end

-- returns a spawn, nil if not found
function spawn_from_peer_name(name)
    return spawn_from_query("pc =".. name)
end

-- returns true if `name` is an item i have
function have_item(name)
    return mq.TLO.FindItemCount("=" .. name)() > 0
end

-- return true if peer has a target
function has_target()
    return mq.TLO.Target() ~= nil
end

-- return the current target spawn, or nil
function get_target()
    if not has_target() then
        return nil
    end
    return mq.TLO.Target
end

-- partial search by name, return item or nil
function get_item(name)
    if mq.TLO.FindItem(name).ID() ~= nil then
        return mq.TLO.FindItem(name)
    end
    return nil
end

-- return true if `item` clicky effect is ready to use
function is_item_clicky_ready(name)
    local item = get_item(name)
    if item == nil then
        mq.cmd.dgtell("all ERROR: is_item_clicky_ready() called with item I do not have:", name)
        return false
    end
    return item.Clicky() ~= nil and item.Timer.Ticks() == 0
end

-- returns true if `name` is a spell currently memorized in a gem
function is_memorized(name)
    return mq.TLO.Me.Gem(mq.TLO.Spell(name).RankName)() ~= nil
end

-- returns true if `name` is a spell in my spellbook
function is_spell_in_book(name)
    if is_alt_ability(name) then
        -- NOTE: some AA's overlap with spell names. use is_alt_ability() to distinguish. Examples:
        -- CLR/06 Sanctuary / CLR Sanctuary AA
        -- SHM/62 Ancestral Guard / SHM Ancestral Guard AA
        return false
    end
    return mq.TLO.Me.Book(mq.TLO.Spell(name).RankName)() ~= nil
end

-- return spell or nil
function get_spell(name)
    if mq.TLO.Spell(name).ID() ~= nil then
        return mq.TLO.Spell(mq.TLO.Spell(name).RankName)
    end
    return nil
end

-- returns true if `name` is ready to cast
function is_spell_ready(name)
    local spell = get_spell(name)
    if spell == nil then
        return false
    end
    return mq.TLO.Me.SpellReady(spell.RankName)()
end

-- exact search by name, return number
function getItemCountExact(name)
    if mq.TLO.FindItem(name).ID() ~= nil then
        return mq.TLO.FindItemCount("="..name)()
    end
    return 0
end

-- returns true if `name` is an AA that you have purchased
function is_alt_ability(name)
    return mq.TLO.Me.AltAbility(name)() ~= nil
end

-- returns true if the AA `name` is ready to use
function is_alt_ability_ready(name)
    return mq.TLO.Me.AltAbilityReady(name)()
end

-- returns true if the ability `name` is ready to use
function is_ability_ready(name)
    return mq.TLO.Me.AbilityReady(name)()
end

-- returns true if I have the buff `name` on me
function have_buff(name)
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        mq.cmd.dgtell("all BEEP error, asked about odd 1buff", name)
        mq.cmd.beep(1)
        return false
    end
    return mq.TLO.Me.Buff(name)() ~= nil or mq.TLO.Me.Buff(spell.RankName)() ~= nil
end

-- returns true if I have the song `name` on me
function have_song(name)
    local spell = mq.TLO.Spell(name)
    if spell() == nil then
        mq.cmd.dgtell("all BEEP error, asked about odd 2buff", name)
        mq.cmd.beep(1)
        return false
    end
    return mq.TLO.Me.Song(name)() ~= nil or mq.TLO.Me.Song(spell.RankName)() ~= nil
end

-- returns true if I am casting a spell/song
function is_casting()
    return mq.TLO.Me.Casting() ~= nil
end

-- returns true if I am moving
function is_moving()
    return mq.TLO.Me.Moving()
end

function is_brd()
    return mq.TLO.Me.Class.ShortName() == "BRD"
end

-- returns true if I am in a guild
function in_guild()
    return mq.TLO.Me.Guild() ~= nil
end

-- returns true if we are in hovering state (just died, waiting for rez in the same zone)
function is_hovering()
    return window_open("RespawnWnd")
end

-- returns true if a window `name` is open
function window_open(name)
    return mq.TLO.Window(name).Open() == true
end

-- returns true if successful
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

function close_merchant_window()
    if not window_open("MerchantWnd") then
        return
    end
    mq.cmd("/notify MerchantWnd MW_Done_Button leftmouseup")
end

-- Opens trade with the nearest merchant.
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

-- returns true if we are in a neutral zone (be less obvious on live)
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

function num_inventory_slots()
    -- TODO is number in a mq.TLO value?
    -- TODO return 8 on servers who only support it
    return 10
end

-- returns item or nil
function get_inventory_slot(name)
    local v = mq.TLO.Me.Inventory(name)
    if v() == nil then
        return nil
    end
    return v
end

-- returns true if `item` is a container
function is_container(item)
    return item ~= nil and item.Container() ~= 0
end

-- returns true if i have a pet
function have_pet()
    return mq.TLO.Me.Pet.ID() ~= 0
end

-- returns true if `name` is a running Lua script
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
        print("Putting cursor item ", mq.TLO.Cursor(), " in inventory.")
        mq.cmd("/autoinventory")
        mq.delay(10000, function() return mq.TLO.Cursor.ID() == nil end)
        mq.delay(100)
        mq.doevents()
    end
end

function cast_veteran_aa(name)
    if mq.TLO.Me.AltAbility(name)() ~= nil then
        if mq.TLO.Me.AltAbilityReady(name)() then
            castSpell(name, mq.TLO.Me.ID())
        else
            mq.cmd.dgtell("all", "ERROR:", name, "is not ready, ready in", mq.TLO.Me.AltAbilityTimer(name).TimeHMS() )
        end
    else
        mq.cmd.dgtell("all", "ERROR: i do not have AA", name)
    end
end

function me_healer()
    return is_healer(mq.TLO.Me.Class.ShortName())
end

function me_priest()
    return is_priest(mq.TLO.Me.Class.ShortName())
end

function me_tank()
    return is_tank(mq.TLO.Me.Class.ShortName())
end

-- true if CLR,DRU,SHM,PAL,RNG,BST
function is_healer(class)
    if class == nil then
        mq.cmd.dgtell("all is_healer called without class. did you mean me_healer() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM" or class == "PAL" or class == "RNG" or class == "BST"
end

-- true if CLR,DRU,SHM
function is_priest(class)
    if class == nil then
        mq.cmd.dgtell("all is_priest called without class. did you mean me_priest() ?")
        mq.cmd.beep(1)
    end
    return class == "CLR" or class == "DRU" or class == "SHM"
end

-- true if WAR,PAL,SHD
function is_tank(class)
    if class == nil then
        mq.cmd.dgtell("all ERROR: is_tank called without class. did you mean me_tank() ?")
        mq.cmd.beep(1)
    end
    return class == "WAR" or class == "PAL" or class == "SHD"
end
