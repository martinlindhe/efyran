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
end

-- Requires: tbl is a table containing strings; v is a string.
-- Effects : returns true if tbl contains v, false otherwise.
function find_in(tbl, v)
    for _, element in ipairs(tbl) do
        if (element == v) then
            return true
        end
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

-- return spell or nil
function getSpell(name)
    if mq.TLO.Spell(name).ID() ~= nil then
        return mq.TLO.Spell(name)
    end
    return nil
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

-- reutrns true if `name` is a spell currently memorized in a gem
function is_memorized(name)
    return mq.TLO.Me.Gem(name)() ~= nil
end

-- returns true if `name` is a spell in my spellbook
function is_spell_in_book(name)
    return mq.TLO.Me.Book(name)() ~= nil
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

function is_brd()
    return mq.TLO.Me.Class.ShortName() == "BRD"
end

-- returns true if I am in a guild
function in_guild()
    return mq.TLO.Me.Guild() ~= nil
end

-- returns true if we are in hovering state (just died, waiting for rez in the same zone)
function is_hovering()
    return mq.TLO.Me.State() == "HOVER"
end

-- returns true if a window `name` is open
function window_open(name)
    return mq.TLO.Window(name).Open() == true
end

-- returns true if successful
function open_merchant_window(spawn)

    if spawn.Distance() > 20 then
        print("Too far away from merchant. Giving up")
        return
    end

    -- Right click merchant, and wait for window to open.

    local attempt = 1
    while true do

        if attempt >= 3 then
            mq.cmd.dgtell("all Giving up opening merchant window after", attempt, "attempts")
            break
        end

        if not window_open("MerchantWnd") then
            mq.cmd("/click right target")
            mq.delay(5000, function() return window_open("MerchantWnd") end)
        end

        if window_open("MerchantWnd") then
            break
        end

        mq.delay(500)
        attempt = attempt +1
    end

    -- Wait for merchant's item list to populate.

    local merchantTotal = -1
    attempt = 1
    while true do
        if attempt >= 10 then
            mq.cmd.dgtell("all Giving up listing merchant window items")
            break
        end

        if merchantTotal ~= mq.TLO.Window("MerchantWnd").Child("ItemList").Items() then
            merchantTotal = mq.TLO.Window("MerchantWnd").Child("ItemList").Items()
            print("merchant total: ", merchantTotal)
        end
        mq.delay(100)
        attempt = attempt +1
    end

end
