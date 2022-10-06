local mq = require("mq")
local log = require("knightlinc/Write")

require('e4_Spells')

local queue = require('Queue')
local timer = require("Timer")

local Heal = {
    queue = queue.new(), -- holds toons that requested a heal
}

function Heal.Init()
    mq.event("dannet_chat", "[ #1# (#2#) ] #3#", function(text, peer, channel, msg)
        if me_healer() and channel == heal_channel() and botSettings.settings.healing ~= nil then
            if string.sub(msg, 1, 1) ~= "/" then -- ignore text starting with a  "/"
                enqueueHealmeRequest(msg)
            end
        end
    end)

    -- Perform rez on target or delegate it to nearby cleric
    ---@param spawnID integer
    mq.bind("/rezit", function(spawnID)
        if is_orchestrator() then
            if not has_target() then
                log.Error("/rezit: No corpse targeted.")
                return
            end
            local spawn = get_target()
            if spawn == nil then
                log.Error("/rezit: No target to rez.")
                return
            end

            spawnID = spawn.ID()
            if spawn.Type() ~= "Corpse" then
                log.Error("/rezit: Target is not a corpse. Type %s",  spawn.Type())
                return
            end

            if not is_clr() then
                local clrName = nearest_peer_by_class("CLR")
                if clrName == nil then
                    cmd("/dgtell all \arERROR\ax: Cannot request rez, no cleric nearby.")
                    return
                end
                log.Info("Requesting rez for \ay%s\ax from \ag%s\ax.", spawn.Name(), clrName)
                cmdf("/dexecute %s /rezit %d", clrName, spawn.ID())
                return
            end
        end

        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            -- unlikely
            cmdf("/dgtell all ERROR: tried to rez spawnid %s which is not in zone %s", spawnID, zone_shortname())
            return
        end
        log.Info("Performing rez on %s, %d %s", spawn.Name(), spawnID, type(spawnID))

        -- try 3 times to get a rez spell before giving up (to wait for ability to become ready...)
        for i = 1, 3 do
            local rez = get_rez_spell_item_aa()
            if rez ~= nil then
                cmdf("/dgtell all Rezzing \ag%s\ax with \ay%s\ax. %d/3", spawn.Name(), rez, i)
                castSpell(rez, spawn.ID())
                break
            else
                cmdf("/dgtell all \arWARN\ax: Not ready to rez \ag%s\ax. %d/3", spawn.Name(), i)
            end
            doevents()
            delay(2000) -- 2s delay
        end

    end)

    -- Rezzes nearby player corpses
    mq.bind("/aerez", function()
        cmdf("/dgtell all AERez started in %s ...", zone_shortname())
        wait_until_not_casting()

        local spawnQuery = 'pccorpse radius 100'
        for i = 1, spawn_count(spawnQuery) do
            local spawn = mq.TLO.NearestSpawn(i, spawnQuery)

            local rez = get_rez_spell_item_aa()
            if rez ~= nil then
                target_id(spawn.ID())
                cmdf("/dgtell all Rezzing %s with %s", spawn.Name(), rez)
                castSpell(rez, spawn.ID())
                wait_until_not_casting()
                break
            else
                cmdf("/dgtell all \arWARN\ax: Not ready to rez \ag%s\ax.", spawn.Name())
            end
            doevents()
            delay(10000) -- 10s
        end
        log.Info("AEREZ ENDING")
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
            cmdf("/dleave %s", botSettings.healme_channel)
        end

        botSettings.healme_channel = heal_channel()
        cmdf("/djoin %s", botSettings.healme_channel)
    end
end

local healQueueMaxLength = 20

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
    return name, toint(pct)
end

---@param msg string Example "Avicii 75" (Name/PctHP)
function enqueueHealmeRequest(msg)

    local peer, pct = parseHealmeRequest(msg)
    --print("heal peer ", peer," pct ", pct)

    -- ignore if not in zone
    local spawn = spawn_from_peer_name(peer)
    if tostring(spawn) == "NULL" then
        cmdf("/dgtell all Peer is not in zone, ignoring heal request from '%s'", peer)
        return
    end

    -- if queue don't already contain this bot
    if not Heal.queue:contains(peer) then
        -- if queue is less than 10 requests, always add it
        if Heal.queue:size() >= healQueueMaxLength then
            -- XXX: if queue is >= 10 long, always add if listed as tank or important bot
            -- XXX: if queue is >= 10 long, add with 50% chance ... if >= 20 long, beep and ignore.

            cmdf("/dgtell all queue is full ! len is %d. queue: %s", Heal.queue:size(), Heal.queue:describe())
            cmd("/beep 1")
            return
        end

        Heal.queue:add(peer, pct)
        --print("added ", peer, " to heal queue")
    end
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
    if is_clr() then
        --all_tellf("processQueue: queue is %d: %s", Heal.queue:size(), Heal.queue:describe())
    end
    if Heal.queue:size() == 0 or botSettings.settings.healing == nil then
        return
    end
--    log.Debug("Heal.processQueue(): queue is %d: %s", Heal.queue:size(), Heal.queue:describe())

    -- first find any TANKS
    if botSettings.settings.healing.tanks ~= nil and botSettings.settings.healing.tank_heal ~= nil then
        for k, peer in pairs(botSettings.settings.healing.tanks) do
            if Heal.queue:contains(peer) then
                local pct = toint(Heal.queue:prop(peer))
                log.Info("Decided to heal TANK %s at %d %%", peer, pct)
                if healPeer(botSettings.settings.healing.tank_heal, peer, pct) then
                    return
                end
            end
        end
    end

    -- then find any IMPORTANT
    if botSettings.settings.healing.important ~= nil and botSettings.settings.healing.important_heal ~= nil then
        for k, peer in pairs(botSettings.settings.healing.important) do
            if Heal.queue:contains(peer) then
                local pct = toint(Heal.queue:prop(peer))
                log.Info("Decided to heal IMPORTANT %s at %d %%", peer, pct)
                if healPeer(botSettings.settings.healing.important_heal, peer, pct) then
                    return
                end
            end
        end
    end

    -- finally care for the rest
    if botSettings.settings.healing.all_heal ~= nil then
        local peer = Heal.queue:peek_first()
        if peer ~= nil then
            local pct = toint(Heal.queue:prop(peer))
            log.Info("Decided to heal ANY %s at %d %%", peer, pct)
            if healPeer(botSettings.settings.healing.all_heal, peer, pct) then
                return
            end
        end
    end
    log.Debug("Heal.processQueue(): Did nothing.")
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

        log.Debug("Got a rez from %s", peer)
        if not is_peer(peer) then
            cmdf("/dgtell all WARNING: got a rez from (NOT A PEER) %s: %s", peer, s)
            cmd("/beep 1")
            delay(10000) -- 10s
            return
        end
        cmdf("/dgtell all Accepting rez from %s", peer)
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")

        -- click in the RespawnWnd if open (live)
        if window_open("RespawnWnd") then
            cmd("/dgtell all BEEP RespawnWnd is open ...")
            cmd("/beep 1")
        end

        -- let some time pass after accepting rez.
        delay(5000)

        -- request buffs
        buffs.RequestBuffs()

        -- target my corpse
        cmdf("/target %s's corpse", mq.TLO.Me.Name())
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
        return
    end

    if follow.spawn ~= nil or is_brd() or in_combat() or is_hovering() or is_casting() or is_moving() or window_open("SpellBookWnd") or window_open("LootWnd") then
        return
    end

    if mq.TLO.Me.MaxMana() > 0 then
        if mq.TLO.Me.PctMana() < 70 and mq.TLO.Me.Standing() then
            cmdf("/dgtell all Low mana, medding at %d%%", mq.TLO.Me.PctMana())
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
    --log.Debug("Heal.performLifeSupport")

    if have_buff("Resurrection Sickness") then
        return
    end

    if botSettings.settings.healing == nil or botSettings.settings.healing.life_support == nil then
        if mq.TLO.Me.PctHPs() < 70 then
            cmdf("/dgtell all performLifeSupport ERROR I dont have healing.life_support configured. Current HP is %d%%", mq.TLO.Me.PctHPs())
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
        if spellConfig.HealPct ~= nil and spellConfig.HealPct < mq.TLO.Me.PctHPs() then
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
        if spellConfig.MinMobs ~= nil and spawn_count(nearbyNPCFilter) < spellConfig.MinMobs then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Not enought nearby mobs. Have ", spawn_count(nearbyNPCFilter), ", need ", spellConfig.MinMobs)
            skip = true
        end

        -- only cast if at most this many NPC:s is nearby
        if spellConfig.MaxMobs ~= nil and spawn_count(nearbyNPCFilter) > spellConfig.MaxMobs then
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
                cmdf("/dgtell all performLifeSupport skip %s, spell is not memorized", spellConfig.Name)
                skip = true
            elseif not is_spell_ready(spellConfig.Name) then
                --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", spell is not ready")
                skip = true
            end
        end

        --print(" skip = ", skip, " spellConfig = ", spellConfig.Name)

        if not skip then
            if is_ability_ready(spellConfig.Name) then
                cmdf("/dgtell all USING LIFE SUPPORT ability %s at %d%%", spellConfig.Name, mq.TLO.Me.PctHPs())
                cmdf("/doability %s", spellConfig.Name)
            else
                local spell = getSpellFromBuff(spellConfig.Name)
                if spell ~= nil then
                    local spellName = spell.RankName()
                    if have_item(spellConfig.Name) or have_alt_ability(spellConfig.Name) then
                        spellName = spellConfig.Name
                    end
                    cmdf("/dgtell all USING LIFE SUPPORT %s at %d%%", spellName, mq.TLO.Me.PctHPs())
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
    log.Debug("healPeer: %s at %d %%", peer, pct)

    for k, heal in pairs(spell_list) do
        local spawn = spawn_from_peer_name(peer)
        local spellConfig = parseSpellLine(heal)
        if spawn == nil then
            -- peer died
            log.Info("Removing from heal queue, peer died: %s", peer)
            Heal.queue:remove(peer)
            return false
        elseif spellConfig.MinMana ~= nil and mq.TLO.Me.PctMana() < spellConfig.MinMana then
            log.Info("SKIP HEALING, my mana %d vs required %d", mq.TLO.Me.PctMana(), spellConfig.MinMana)
        elseif spellConfig.HealPct ~= nil and spellConfig.HealPct < pct then
            -- remove, dont meet heal criteria
            -- DONT RETURN HERE because specific spell does not meet criteria!
            log.Info("Skip using of heal, heal pct for %s is %d. dont need heal at %d for %s", spellConfig.Name, spellConfig.HealPct, pct, peer)

        elseif not is_spell_in_book(spellConfig.Name) and have_item(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            -- SKIP clickies that is not ready
            log.Info("Skip using of heal to heal %s at %d, clicky %s is not ready", peer, pct, spellConfig.Name)
        else

            Heal.queue:remove(peer)
            all_tellf("Healing \ag%s\ax at %d%% with %s", peer, pct, spellConfig.Name)

            local check = castSpellAbility(spawn, heal, function()
                if not is_casting() then
                    all_tellf("done casting heal, breaking")
                    return true
                end
                if mq.TLO.Target.ID() ~= spawn.ID() then
                    all_tellf("target changed in heal callback, breaking")
                    return true
                end
                if mq.TLO.Target() ~= nil and mq.TLO.Target.PctHPs() >= 98 then
                    all_tellf("Ducking heal! Target was %d %%, is now %d %%", pct, mq.TLO.Target.PctHPs())
                    cmd("/interrupt")
                    return true
                end
            end)
            if check then  -- XXX castSpellAbility should take spellConfig obj directly
                return true
            end

            return true
        end

        doevents()
        delay(1)
    end
    --all_tellf("Removing from heal queue, no usable heal available for %s at %d %%", peer, pct)
    Heal.queue:remove(peer)
    return false
end

return Heal