local mq = require("mq")

require('e4_Spells')

local queue = require('Queue')
local timer = require("Timer")

local Heal = {
    queue = queue.new(), -- holds toons that requested a heal
}

function Heal.Init()
    mq.event("dannet_chat", "[ #1# (#2#) ] #3#", function(text, peer, channel, msg)
        --print("-- dannet_chat: chan ", channel, " msg: ", msg)

        if me_healer() and channel == heal_channel() and botSettings.settings.healing ~= nil then
            if string.sub(msg, 1, 1) ~= "/" then
                -- ignore text starting with a  "/"
                handleHealmeRequest(msg)
            end
        end
    end)

    -- Perform rez on target or delegate it to nearby cleric
    ---@param spawnID integer
    mq.bind("/rezit", function(spawnID)
        print("rezit", spawnID)

        if is_orchestrator() then
            if not has_target() then
                print("/rezit ERROR: No corpse targeted.")
                return
            end
            local spawn = get_target()
            if spawn == nil then
                print("/rezit ERROR: No target to rez.")
                return
            end

            spawnID = spawn.ID()
            if spawn.Type() ~= "Corpse" then
                print("/rezit ERROR: Target is not a corpse (type ", spawn.Type(), ")")
                return
            end

            if not is_clr() then
                local clrName = nearest_peer_by_class("CLR")
                if clrName == nil then
                    cmd("/dgtell all \arERROR\ax: Cannot request rez, no cleric nearby.")
                    return
                end
                print("Requesting rez for \ay"..spawn.Name().."\ax from \ag"..clrName.."\ax.")
                cmd("/dexecute "..clrName.." /rezit "..spawn.ID())
                return
            end
        end

        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            -- unlikely
            cmd("/dgtell all ERROR: tried to rez spawnid "..spawnID.." which is not in zone "..zone_shortname())
            return
        end
        print("Performing rez on ", spawnID, " ", type(spawnID), " ", spawn.Name())

        -- try 3 times to get a rez spell before giving up (to wait for ability to become ready...)
        for i = 1, 3 do
            local rez = get_rez_spell_item_aa()
            if rez ~= nil then
                cmd("/dgtell all Rezzing \ag"..spawn.Name().."\ax with \ay"..rez.."\ax. "..i.."/3")
                castSpell(rez, spawn.ID())
                break
            else
                cmd("/dgtell all \arWARN\ax: Not ready to rez \ag"..spawn.Name().."\ax. "..i.."/3")
            end
            doevents()
            delay(2000) -- 2s delay
        end

    end)

    -- Rezzes nearby player corpses
    mq.bind("/aerez", function()
        cmd("/dgtell all AERez started in "..zone_shortname().." ...")
        delay(10)

        local spawnQuery = 'pccorpse radius 100'
        for i = 1, spawn_count(spawnQuery) do
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)
            --print("/aerez Considering Spawn "..spawn.Name() .. " "..i.." of ".. spawn_count(spawnQuery))

            local rez = get_rez_spell_item_aa()
            if rez ~= nil then
                target_id(spawn.ID())
                cmd("/dgtell all Rezzing "..spawn.Name().." with "..rez)
                castSpell(rez, spawn.ID())
                break
            else
                cmd("/dgtell all \arWARN\ax: Not ready to rez \ag"..spawn.Name().."\ax.")
            end
            doevents()
            delay(10000) -- 10s delay
        end
        print("AEREZ ENDING")
    end)

    joinCurrentHealChannel()
    memorizeListedSpells()
end

-- joins/changes to the heal channel for current zone
function joinCurrentHealChannel()
    -- orchestrator only joins to watch the numbers
    if is_orchestrator() or me_healer() then
        if heal_channel() == botSettings.healme_channel then
            return
        end

        if botSettings.healme_channel ~= "" then
            cmd("/dleave "..botSettings.healme_channel)
        end

        botSettings.healme_channel = heal_channel()
        cmd("/djoin "..botSettings.healme_channel) -- new zone
    end
end

local healQueueMaxLength = 10

---@param s string
---@return string, integer
function parseHealmeRequest(s)
    local name = ""
    local pct = "0"
    local i = 1
    for sub in s:gmatch("%S+") do
        if i == 1 then
            name = sub
        else
            pct = sub
        end
        i = i + 1
    end
    return name, pct + 0
end

---@param msg string Example "Avicii 75" (Name/PctHP)
function handleHealmeRequest(msg)

    local peer, pct = parseHealmeRequest(msg)
    --print("heal peer ", peer," pct ", pct)

    -- ignore if not in zone
    local spawn = spawn_from_peer_name(peer)
    if tostring(spawn) == "NULL" then
        cmd("/dgtell all Peer is not in zone, ignoring heal request from '"..peer.."'")
        return
    end

    -- if queue don't already contain this bot
    if not Heal.queue:contains(peer) then
        -- if queue is less than 10 requests, always add it
        if #Heal.queue >= healQueueMaxLength then
            -- XXX: if queue is >= 10 long, always add if listed as tank or important bot
            -- XXX: if queue is >= 10 long, add with 50% chance ... if >= 20 long, beep and ignore.

            cmd("/dgtell all queue is full ! len is "..#Heal.queue..". queue: "..Heal.queue)
            cmd("/beep 1")
            return
        end

        Heal.queue:add(peer, pct)
        --print("added ", peer, " to heal queue")
    end

    --print("current heal queue:")
    --tprint(Heal.queue)
end

local lifeSupportTimer = timer.new_expired(5 * 1) -- 5s

function Heal.Tick()

    if is_hovering() then
        return
    end

    if lifeSupportTimer:expired() then
        lifeSupportTimer:restart()
        Heal.performLifeSupport()
    end

    Heal.processQueue()

    Heal.acceptRez()

    Heal.medCheck()
end

function Heal.processQueue()
    -- check if heals need to be casted
    if Heal.queue:size() == 0 or botSettings.settings.healing == nil then
        return
    end
    --print("heal tick. queue is ", Heal.queue:size(), ": ", Heal.queue:describe())

    -- first find any TANKS
    if botSettings.settings.healing.tanks ~= nil and botSettings.settings.healing.tank_heal ~= nil then
        --print("check if any listed tanks is in queue ...")
        for k, peer in pairs(botSettings.settings.healing.tanks) do
            if Heal.queue:contains(peer) then
                local pct = Heal.queue:prop(peer)
                if healPeer(botSettings.settings.healing.tank_heal, peer, pct) then
                    return
                end
            end
        end
    end

    -- then find any IMPORTANT
    if botSettings.settings.healing.important ~= nil and botSettings.settings.healing.important_heal ~= nil then
        --print("check if any listed important bots is in queue ...")
        for k, peer in pairs(botSettings.settings.healing.important) do
            if Heal.queue:contains(peer) then
                local pct = Heal.queue:prop(peer)
                if healPeer(botSettings.settings.healing.important_heal, peer, pct) then
                    return
                end
            end
        end
    end

    -- finally care for the rest
    if botSettings.settings.healing.all_heal ~= nil then
        --print("check if ANY bots is in queue...")
        local peer = Heal.queue:peek_first()
        if peer ~= nil then
            local pct = Heal.queue:prop(peer)
            --print("healing ", peer, " at pct ", pct)
            if healPeer(botSettings.settings.healing.all_heal, peer, pct) then
                return
            end
        end
    end
end

function Heal.acceptRez()
    if not window_open("ConfirmationDialogBox") then
        return
    end

    local s = mq.TLO.Window("ConfirmationDialogBox").Child("CD_TextOutput").Text()
    -- XXX full text

    -- Call of the Wild, druid recall to corpse, can still be rezzed.
    -- "NAME is attempting to return you to your corpse. If you accept this, you will still be able to get a resurrection later. Do you wish this?"
    if string.find(s, "wants to cast") ~= nil or string.find(s, "attempting to return you") ~= nil then
        -- grab first word from sentence
        local i = 1
        local peer = ""
        for w in s:gmatch("%S+") do
            if i == 1 then
                peer = w
                break
            end
            i = i + 1
        end

        --print("got a rez from", peer, " ( ", spawn.Name() , ")")
        if not is_peer(peer) then
            cmd("/dgtell all WARNING: got a rez from (NOT A PEER) "..peer..": "..s)
            cmd("/beep 1")
            delay(1000) -- XXX
            -- XXX should we decline the rez?
            return
        end
        cmd("/dgtell all Accepting rez from "..peer)
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")

        -- click in the RespawnWnd if open (live)
        if window_open("RespawnWnd") then
            cmd("/dgtell all BEEP RespawnWnd is open ...")
            cmd("/beep 1")
        end

        -- let some time pass after accepting rez.
        delay(5000)

        -- target my corpse
        cmd("/target "..mq.TLO.Me.Name().."'s corpse")
        delay(1000)

        -- open loot window
        cmd("/loot")
        delay(5000, function() return window_open("LootWnd") end)

        if not window_open("LootWnd") then
            cmd("/dgtell all ERROR FATAL CANNOT OPEN MY LOOT WINDOW.")
            return
        end

        -- click loot all button
        cmd("/notify LootWnd LootAllButton leftmouseup")
        delay(30000, function() return not window_open("LootWnd") end)
    end
end

function Heal.medCheck()

    if botSettings.settings.healing ~= nil and botSettings.settings.healing.automed ~= nil and not botSettings.settings.healing.automed then
        --print("wont med. healing.automed is false")
        return
    end

    if follow.spawn ~= nil or is_brd() or is_hovering() or is_casting() or is_moving() or window_open("SpellBookWnd") or window_open("LootWnd") then
        return
    end

    if mq.TLO.Me.MaxMana() > 0 then
        if mq.TLO.Me.PctMana() < 70 and mq.TLO.Me.Standing() then
            cmd("/dgtell all Low mana, medding at "..mq.TLO.Me.PctMana().."%")
            cmd("/sit on")
        elseif mq.TLO.Me.PctMana() >= 100 and not mq.TLO.Me.Standing() and not mq.TLO.Me.Ducking() then
            cmd("/dgtell all Ending medbreak, full mana.")
            cmd("/sit off")
        end
    end
end

local nearbyNPCFilter = "npc radius 75 zradius 75"

-- tries to defend myself using settings.healing.life_support
function Heal.performLifeSupport()
    --print("Heal.performLifeSupport")

    if have_buff("Resurrection Sickness") then
        --cmd("/dgtell all performLifeSupport GIVING UP. REZ SICKNESS")
        return
    end

    if botSettings.settings.healing == nil or botSettings.settings.healing.life_support == nil then
        if mq.TLO.Me.PctHPs() < 70 then
            cmd("/dgtell all performLifeSupport ERROR I dont have healing.life_support configured. Current HP is "..mq.TLO.Me.PctHPs().."%")
        end
        return
    end

    if mq.TLO.Me.Ducking() then
        cmd("/dgtell all performLifeSupport WARNING: Standing up. Was ducking")
        cmd("/stand")
        delay(20)
    end

    for k, row in pairs(botSettings.settings.healing.life_support) do
        local spellConfig = parseSpellLine(row)
        --print("k ", k, " v ", row, ", parsed as name: ", spellConfig.Name)

        local skip = false
        if spellConfig.HealPct ~= nil and tonumber(spellConfig.HealPct) < mq.TLO.Me.PctHPs() then
            -- remove, dont meet heal criteria
            --print("performLifeSupport skip use of ", spellConfig.Name, ", my hp ", mq.TLO.Me.PctHPs, " vs required ", spellConfig.HealPct)
            skip = true
        end

        -- if we got this buff/song on, then skip.
        if spellConfig.CheckFor ~= nil and (have_buff(spellConfig.CheckFor) or have_song(spellConfig.CheckFor)) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", I have buff ", spellConfig.CheckFor, " on me")
            skip = true
        end

        -- only cast if at least this many NPC:s is nearby
        if spellConfig.MinMobs ~= nil and spawn_count(nearbyNPCFilter) < tonumber(spellConfig.MinMobs) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Not enought nearby mobs. Have ", spawn_count(nearbyNPCFilter), ", need ", spellConfig.MinMobs)
            skip = true
        end

        -- only cast if at most this many NPC:s is nearby
        if spellConfig.MaxMobs ~= nil and spawn_count(nearbyNPCFilter) > tonumber(spellConfig.MaxMobs) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Too many nearby mobs. Have ", spawn_count(nearbyNPCFilter), ", need ", spellConfig.MaxMobs)
            skip = true
        end

        if spellConfig.Zone ~= nil and zone_shortname() ~= spellConfig.Zone then
            -- TODO: allow multiple zones listed as comma separated shortnames
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", we are in zone ", zone_shortname(), " vs required ", spellConfig.Zone)
            skip = true
        end

        if have_alt_ability(spellConfig.Name) and not is_alt_ability_ready(spellConfig.Name) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", AA is not ready")
            skip = true
        end

        if have_ability(spellConfig.Name) and not is_ability_ready(spellConfig.Name) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Ability is not ready")
            skip = true
        end

        if have_item(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", item clicky is not ready")
            skip = true
        end

        if is_spell_in_book(spellConfig.Name) then
            if not is_memorized(spellConfig.Name) then
                cmd("/dgtell all performLifeSupport skip "..spellConfig.Name..", spell is not memorized")
                skip = true
            elseif not is_spell_ready(spellConfig.Name) then
                --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", spell is not ready")
                skip = true
            end
        end

        --print(" skip = ", skip, " spellConfig = ", spellConfig.Name)

        if not skip then
            if is_ability_ready(spellConfig.Name) then
                cmd("/dgtell all USING LIFE SUPPORT ability "..spellConfig.Name.." at "..mq.TLO.Me.PctHPs().."%")
                cmd("/doability "..spellConfig.Name)
            else
                local spell = getSpellFromBuff(spellConfig.Name)
                if spell ~= nil then
                    local spellName = spell.RankName()
                    if have_item(spellConfig.Name) or have_alt_ability(spellConfig.Name) then
                        spellName = spellConfig.Name
                    end
                    cmd("/dgtell all USING LIFE SUPPORT "..spellName.." at "..mq.TLO.Me.PctHPs().."%")
                    castSpell(spellName, mq.TLO.Me.ID())
                end
            end
            return
        end
    end
end

-- uses healing.tank_heal, returns true if spell was cast
---@param spell_list table
---@param peer string Name of peer to heal.
---@param pct integer Health % of peer.
function healPeer(spell_list, peer, pct)
    --print("Heal: ", peer, " is in my queue, at ", pct, " want heal!!!")

    for k, heal in pairs(spell_list) do
        local spawn = spawn_from_peer_name(peer)
        local spellConfig = parseSpellLine(heal)
        if spawn == nil then
            -- peer died
            print("removing from heal queue, peer died: ", peer)
            Heal.queue:remove(peer)
            return false
        elseif spellConfig.MinMana ~= nil and mq.TLO.Me.PctMana() < tonumber(spellConfig.MinMana) then
            print("SKIP HEALING, my mana ", mq.TLO.Me.PctMana, " vs required ", spellConfig.MinMana)
        elseif spellConfig.HealPct ~= nil and tonumber(spellConfig.HealPct) < pct then
            -- remove, dont meet heal criteria
            --print("removing from heal queue, dont need heal: ", peer)
            Heal.queue:remove(peer)
            return false
        else
            cmd("/dgtell all Healing "..peer.." at "..pct.."% with spell "..spellConfig.Name)
            castSpell(spellConfig.Name, spawn.ID())
            Heal.queue:remove(peer)
            return true
        end
        doevents()
        delay(1)
    end
    return false
end

return Heal