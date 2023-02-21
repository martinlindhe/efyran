local mq = require("mq")
local log = require("knightlinc/Write")

require("e4_Spells")

local botSettings = require("e4_BotSettings")
local queue = require("Queue")
local timer = require("Timer")
local follow  = require("e4_Follow")
local buffs   = require("e4_Buffs")

local askForHealTimer = timer.new_expired(5 * 1) -- 5s
local askForHealPct = 88 -- at what % HP to start begging for heals

local Heal = {
    queue = queue.new(), -- holds toons that requested a heal

    ---@type string
    healme_channel = "", -- healme channel for current zone
}

function Heal.Init()
    mq.event("dannet_chat", "[ #1# (#2#) ] #3#", function(text, dnetPeer, channel, msg)
        if string.sub(msg, 1, 16) == "#available-buffs" then
            local peerName = strip_dannet_peer(dnetPeer)

            -- if peer is in my zone, remember their announcement
            if spawn_from_peer_name(peerName) ~= nil then
                local available = string.sub(msg, 18)
                --log.Debug("%s ANNOUNCED AVAILABLE BUFFS: %s", peerName, available)
                buffs.otherAvailable[peerName] = available
            end
        elseif me_healer() and channel == heal_channel() and botSettings.settings.healing ~= nil then
            if string.sub(msg, 1, 1) ~= "/" then -- ignore text starting with a  "/"
                enqueueHealmeRequest(msg)
            end
        end
    end)

    joinCurrentHealChannel()
    memorizeListedSpells()
end

-- joins/changes to the heal channel for current zone
function joinCurrentHealChannel()
    -- orchestrator only joins to watch the numbers
    if is_orchestrator() or me_healer() then
        if heal_channel() == Heal.healme_channel then
            return
        end

        if Heal.healme_channel ~= "" then
            cmdf("/dleave %s", Heal.healme_channel)
        end

        Heal.healme_channel = heal_channel()
        cmdf("/djoin %s", Heal.healme_channel)
    end
end

local healQueueMaxLength = 25

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
        all_tellf("Peer is not in zone, ignoring heal request from '%s'", peer)
        return
    end

    -- if queue don't already contain this bot
    if not Heal.queue:contains(peer) then
        -- if queue is less than 10 requests, always add it
        if Heal.queue:size() >= healQueueMaxLength then
            -- XXX: if queue is >= 10 long, always add if listed as tank or important bot
            -- XXX: if queue is >= 10 long, add with 50% chance ... if >= 20 long, beep and ignore.

            all_tellf("queue is full ! len is %d. queue: %s", Heal.queue:size(), Heal.queue:describe())
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

    Heal.askForHeal()
end

function Heal.askForHeal()
    if not is_hovering() and mq.TLO.Me.PctHPs() <= askForHealPct and askForHealTimer:expired() then
        -- ask for heals if i take damage
        local s = mq.TLO.Me.Name().." "..mq.TLO.Me.PctHPs() -- "Avicii 82"
        --print(mq.TLO.Time, "HELP HEAL ME, ", s)
        cmd("/dgtell "..heal_channel().." "..s)
        askForHealTimer:restart()
    end
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
                Heal.queue:remove(peer)
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
                Heal.queue:remove(peer)
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
            log.Debug("Decided to heal ANY %s at %d %%", peer, pct)
            Heal.queue:remove(peer)
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
            all_tellf("WARNING: got a rez from (NOT A PEER) %s: %s", peer, s)
            cmd("/beep 1")
            delay(10000) -- 10s
            return
        end
        all_tellf("Accepting rez from %s", peer)
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")

        -- click in the RespawnWnd if open (live)
        if window_open("RespawnWnd") then
            all_tellf("BEEP RespawnWnd is open ...")
            cmd("/beep 1")
        end

        -- let some time pass after accepting rez.
        delay(5000)

        -- request buffs
        buffs.RequestBuffs()

        loot_my_corpse()
    end
end

function nearby_npc_count(radius)
    return spawn_count(string.format("npc radius %d zradius 75", radius))
end

function Heal.medCheck()

    if botSettings.settings.healing ~= nil and botSettings.settings.healing.automed ~= nil and not botSettings.settings.healing.automed then
        return
    end

    if nearby_npc_count(75) > 0 then
        return
    end

    if is_sitting() and mq.TLO.Me.PctMana() >= 100 then
        all_tellf("Ending medbreak, full mana.")
        cmd("/sit off")
        return
    end

    if follow.spawn ~= nil or is_brd() or is_sitting() or in_combat() or is_hovering() or is_casting() or is_moving() or window_open("SpellBookWnd") or window_open("LootWnd") then
        return
    end

    if mq.TLO.Me.MaxMana() > 0 and mq.TLO.Me.PctMana() < 70 then
        all_tellf("Low mana, medding at %d%%", mq.TLO.Me.PctMana())
        cmd("/sit on")
    end
end



-- tries to defend myself using settings.healing.life_support
function Heal.performLifeSupport()
    --log.Debug("Heal.performLifeSupport")

    if have_buff("Resurrection Sickness") or mq.TLO.Me.PctHPs() >= 98 then
        return
    end

    if botSettings.settings.healing == nil or botSettings.settings.healing.life_support == nil then
        if mq.TLO.Me.PctHPs() < 70 then
            log.Error("performLifeSupport ERROR I dont have healing.life_support configured. Current HP is %d%%", mq.TLO.Me.PctHPs())
        end
        return
    end

    if mq.TLO.Me.Ducking() then
        all_tellf("performLifeSupport WARNING: Standing up. Was ducking")
        cmd("/stand")
        delay(20)
    end

    for k, row in ipairs(botSettings.settings.healing.life_support) do
        local spellConfig = parseSpellLine(row)
        --print("k ", k, " v ", row, ", parsed as name: ", spellConfig.Name)

        local skip = false
        if spellConfig.HealPct ~= nil and spellConfig.HealPct < mq.TLO.Me.PctHPs() then
            -- remove, dont meet heal criteria
            --print("performLifeSupport skip use of ", spellConfig.Name, ", my hp ", mq.TLO.Me.PctHPs, " vs required ", spellConfig.HealPct)
            skip = true
        elseif spellConfig.CheckFor ~= nil and (have_buff(spellConfig.CheckFor) or have_song(spellConfig.CheckFor)) then
            -- if we got this buff/song on, then skip.
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", I have buff ", spellConfig.CheckFor, " on me")
            skip = true
        elseif spellConfig.MinMobs ~= nil and nearby_npc_count(75) < spellConfig.MinMobs then
            -- only cast if at least this many NPC:s is nearby
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Not enought nearby mobs. Have ", spawn_count(nearbyNPCFilter), ", need ", spellConfig.MinMobs)
            skip = true
        elseif spellConfig.MaxMobs ~= nil and nearby_npc_count(75) > spellConfig.MaxMobs then
            -- only cast if at most this many NPC:s is nearby
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Too many nearby mobs. Have ", spawn_count(nearbyNPCFilter), ", need ", spellConfig.MaxMobs)
            skip = true
        elseif spellConfig.Zone ~= nil and zone_shortname() ~= spellConfig.Zone then
            -- TODO: allow multiple zones listed as comma separated shortnames
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", we are in zone ", zone_shortname(), " vs required ", spellConfig.Zone)
            skip = true
        elseif have_alt_ability(spellConfig.Name) and not is_alt_ability_ready(spellConfig.Name) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", AA is not ready")
            skip = true
        elseif have_ability(spellConfig.Name) and not is_ability_ready(spellConfig.Name) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", Ability is not ready")
            skip = true
        elseif have_item(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", item clicky is not ready")
            skip = true
        elseif have_spell(spellConfig.Name) then
            if not is_memorized(spellConfig.Name) then
                all_tellf("performLifeSupport skip %s, spell is not memorized (fix: list it in settings.gems so it can be used)", spellConfig.Name)
                skip = true
            elseif not is_spell_ready(spellConfig.Name) then
                --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", spell is not ready")
                skip = true
            end
        end

        --print(" skip = ", skip, " spellConfig = ", spellConfig.Name)

        if not skip then
            if is_ability_ready(spellConfig.Name) then
                all_tellf("USING LIFE SUPPORT ability %s at %d%%", spellConfig.Name, mq.TLO.Me.PctHPs())
                cmdf("/doability %s", spellConfig.Name)
            else
                local spell = getSpellFromBuff(spellConfig.Name)
                if spell ~= nil then
                    local spellName = spell.RankName()
                    if have_item(spellConfig.Name) or have_alt_ability(spellConfig.Name) then
                        spellName = spellConfig.Name
                    end
                    all_tellf("USING LIFE SUPPORT %s at %d%%", spellName, mq.TLO.Me.PctHPs())
                    castSpellAbility(nil, spellName)
                    return
                end
            end
        end
    end
end

-- uses healing.tank_heal, returns true if spell was cast
---@param spell_list table
---@param peer string Name of peer to heal.
---@param pct integer Health % of peer.
function healPeer(spell_list, peer, pct)
    log.Debug("healPeer: %s at %d %%", peer, pct)

    for k, heal in ipairs(spell_list) do
        local spawn = spawn_from_peer_name(peer)
        local spellConfig = parseSpellLine(heal)
        if spawn == nil or spawn.Distance() > 200 then
            -- peer died or is out of range
            return false
        elseif spellConfig.MinMana ~= nil and mq.TLO.Me.PctMana() < spellConfig.MinMana then
            log.Info("SKIP HEALING, my mana %d vs required %d", mq.TLO.Me.PctMana(), spellConfig.MinMana)
        elseif spellConfig.HealPct ~= nil and spellConfig.HealPct < pct then
            -- remove, dont meet heal criteria
            -- DONT RETURN HERE because specific spell does not meet criteria!
            log.Debug("Skip using of heal, heal pct for %s is %d. dont need heal at %d for %s", spellConfig.Name, spellConfig.HealPct, pct, peer)
        elseif not have_spell(spellConfig.Name) and not have_item(spellConfig.Name) then
            -- SKIP clickes that is not on me
            log.Warn("Skip using of heal to heal %s at %d, I do not have item on me: %s", peer, pct, spellConfig.Name)
        elseif not have_spell(spellConfig.Name) and have_item(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            -- SKIP clickies that is not ready
            log.Info("Skip using of heal to heal %s at %d, clicky %s is not ready", peer, pct, spellConfig.Name)
        else
            all_tellf("Healing \ag%s\ax at %d%% with %s", peer, pct, spellConfig.Name)

            local check = castSpellAbility(spawn, heal, function() -- XXX castSpellAbility should take spellConfig obj directly
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
            return true
        end
    end
    return false
end

return Heal
