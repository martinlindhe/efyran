local mq = require("mq")
local log = require("efyran/knightlinc/Write")

require("efyran/e4_Spells")

local globalSettings = require("efyran/e4_Settings")

local botSettings = require("efyran/e4_BotSettings")
local timer = require("efyran/Timer")
local follow  = require("efyran/e4_Follow")
local buffs   = require("efyran/e4_Buffs")

local timeZonedDelay = 10 -- seconds

local Heal = {
    ---@type boolean
    autoMed = true,
}

function Heal.Init()
    mq.event("eqbc_chat", "<#1#> [#2#] #3#", function(text, peerName, time, msg)
        if string.sub(msg, 1, 16) == "#available-buffs" then
            -- if peer is in my zone, remember their announcement
            if spawn_from_peer_name(peerName) ~= nil then
                local available = string.sub(msg, 18)
                --log.Debug("%s ANNOUNCED AVAILABLE BUFFS: %s", peerName, available)
                buffs.otherAvailable[peerName] = available
            end
        end
    end)

    mq.bind("/medon", function()
        if is_orchestrator() then
            cmd("/dgzexecute /medon")
        end
        Heal.autoMed = true
        Heal.medCheck()
    end)

    mq.bind("/medoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /medoff")
        end
        Heal.autoMed = false
        Heal.medCheck()
    end)
end

local lifeSupportTimer = timer.new_expired(5 * 1) -- 5s

local groupBalanceTimer = timer.new_expired(30 * 1) -- 30s

function Heal.Tick()

    if is_hovering() or is_moving() or is_invisible() then
        return
    end

    if os.time() - timeZonedDelay <= buffs.timeZoned then
        -- ignore first few seconds after zoning, to avoid spamming heals before health data has been synced from server
        return
    end

    if groupBalanceTimer:expired() then
        groupBalanceTimer:restart()
        Heal.performGroupBalanceHeal()
    end

    if lifeSupportTimer:expired() then
        lifeSupportTimer:restart()
        Heal.performLifeSupport()
    end

    Heal.performHealDuties()

    Heal.acceptRez()

    Heal.medCheck()
end

-- check if heals need to be casted
function Heal.performHealDuties()
    if botSettings.settings.healing == nil then
        return
    end

    -- first find any TANKS
    if botSettings.settings.healing.tanks ~= nil and botSettings.settings.healing.tank_heal ~= nil then
        for k, peer in pairs(botSettings.settings.healing.tanks) do
            if is_peer_in_zone(peer) then
                local pct = peer_hp(peer)
                if healPeer(botSettings.settings.healing.tank_heal, peer, pct) then
                    return
                end
            end
        end
    end

    -- then find any IMPORTANT
    if botSettings.settings.healing.important ~= nil and botSettings.settings.healing.important_heal ~= nil then
        for k, peer in pairs(botSettings.settings.healing.important) do
            if is_peer_in_zone(peer) then
                local pct = peer_hp(peer)
                if healPeer(botSettings.settings.healing.important_heal, peer, pct) then
                    return
                end
            end
        end
    end

    -- finally care for the rest
    if botSettings.settings.healing.all_heal ~= nil then
        for i, peer in pairs(get_peers()) do
            if is_peer_in_zone(peer) then
                local pct = peer_hp(peer)
                if healPeer(botSettings.settings.healing.all_heal, peer, pct) then
                    return
                end
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

        log.Debug("Got a rez from %s", peer)
        if not is_peer(peer) then
            log.Warn("Got a rez from \ay%s\ax: \ap%s\ax", peer, s)
            all_tellf("Got a rez from \ay%s\ax: \ap%s\ax", peer, s)
            if not globalSettings.allowStrangers then
                cmd("/beep 1")
                delay(10000) -- 10s to not flood chat
                return
            end
        end

        -- tell bots that my corpse is rezzed
        cmdf("/bcaa //ae_rezzed %s", mq.TLO.Me.Name())

        all_tellf("Accepting rez from \ag%s\ax ...", peer)
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

        buffs.UpdateClickies()
    end
end

function Heal.medCheck()

    if os.time() - timeZonedDelay <= buffs.timeZoned then
        -- ignore first few seconds after zoning, to avoid sitting after zoning, before health data has been synced from server
        return
    end

    if botSettings.settings.healing ~= nil and botSettings.settings.healing.automed ~= nil and not botSettings.settings.healing.automed then
        return
    end

    if is_sitting() and not window_open("SpellBookWnd") then
        -- make sure to proecss events in order to not stand up in case of "/camp" command, which would end the macro
        doevents()

        if mq.TLO.Me.MaxMana() > 1 and mq.TLO.Me.PctMana() >= 100 then
            all_tellf("Ending medbreak, \agfull mana\ax.")
            cmd("/sit off")
            return
        end
        if mq.TLO.Me.MaxMana() == 0 and mq.TLO.Me.PctEndurance() >= 100 then
            all_tellf("Ending medbreak, \agfull endurance\ax.")
            cmd("/sit off")
            return
        end
    end

    if is_moving() or is_sitting() or in_combat() or is_hovering() or is_casting() or window_open("SpellBookWnd") or window_open("LootWnd") then
        return
    end

    local neutral = in_neutral_zone()
    if nearby_npc_count(50) > 0 and not neutral then
        return
    end
    if not neutral and is_brd() then
        return
    end

    if Heal.autoMed and mq.TLO.Me.MaxMana() > 0 and is_standing() and not is_moving() and mq.TLO.Me.PctMana() < 70 then
        all_tellf("Low mana, medding at \ay%d%%\ax", mq.TLO.Me.PctMana())
        cmd("/sit on")
    end

end

-- uses cleric Epic 1.5/2.0 clicky or Divine Arb AA to heal group if avg < 95%
---@return boolean true if performed action
function Heal.performGroupBalanceHeal()
    if not is_clr() or is_casting() or is_moving() or not in_group() or have_buff("Resurrection Sickness") or in_neutral_zone() then
        return false
    end

    local sum = mq.TLO.Me.PctHPs()
    local members = 1
    for i=1,mq.TLO.Group.Members() do
        local dist = mq.TLO.Group.Member(i).Distance()
        if dist ~= nil and dist < 100 then
            local pct = mq.TLO.Group.Member(i).PctHPs()
            if pct ~= nil then
                sum = sum + pct
                members = members + 1
            end
        end
    end

    local avg = sum / members
    if members <= 1 or avg >= 90 then
        return false
    end

    if is_alt_ability_ready("Divine Arbitration") then
        all_tellf("\ayHeal balance (AA) at %d %%", avg)
        use_alt_ability("Divine Arbitration", mq.TLO.Me.ID())
        delay(800)
        return true
    end

    if have_item("Aegis of Superior Divinity") and is_item_clicky_ready("Aegis of Superior Divinity") then
        all_tellf("\ayHeal balance (EPIC) at %d %%", avg)
        local res = castSpellAbility(nil, "Aegis of Superior Divinity")
        delay(800)
        return res
    end

    if have_item("Harmony of the Soul") and is_item_clicky_ready("Harmony of the Soul") then
        all_tellf("\ayHeal balance (EPIC) at %d %%", avg)
        local res = castSpellAbility(nil, "Harmony of the Soul")
        delay(800)
        return res
    end

    return false
end

-- tries to defend myself using settings.healing.life_support
function Heal.performLifeSupport()
    --log.Debug("Heal.performLifeSupport")

    if have_buff("Resurrection Sickness") then
        return
    end

    if mq.TLO.Me.PctHPs() >= 98 and mq.TLO.Me.PctMana() >= 98 then
        return
    end

    if botSettings.settings.healing == nil or botSettings.settings.healing.life_support == nil then
        return
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
            -- if we got the buff/song listed in CheckFor on, then skip.
            --cmd("/dgtell all performLifeSupport skip ", spellConfig.Name, ", I have buff ", spellConfig.CheckFor, " on me")
            skip = true
        elseif have_buff(spellConfig.Name) or have_song(spellConfig.Name) then
            -- if we got the buff/song named on, then skip (eg. HoT heals)
            --log.Debug("performLifeSupport skip %s, I have it on me", spellConfig.Name)
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
            --log.Debug("performLifeSupport skip %s, Ability is not ready", spellConfig.Name)
            skip = true
        elseif have_item_inventory(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
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
        elseif not matches_filter(row, mq.TLO.Me.Name()) then
            all_tellf("performLifeSupport skip %s, not matching filter %s", spellConfig.Name, row)
            skip = true
        end

        --print(" skip = ", skip, " spellConfig = ", spellConfig.Name)

        if not skip then
            if is_ability_ready(spellConfig.Name) then
                all_tellf("USING LIFE SUPPORT ability %s at %d%%", spellConfig.Name, mq.TLO.Me.PctHPs())
                cmdf("/doability %s", spellConfig.Name)
                return
            end

            if not have_ability(spellConfig.Name) then
                local spell = getSpellFromBuff(spellConfig.Name)
                if spell ~= nil then
                    local spellName = spell.RankName()
                    if have_item_inventory(spellConfig.Name) or have_alt_ability(spellConfig.Name) then
                        spellName = spellConfig.Name
                    end

                    if spell.TargetType() ~= "Self" and spell.TargetType() ~= "Group v2" then
                        if spell.TargetType() ~= "Single" then
                            all_tellf("XXX LIFE SUPPORT targetType is %s (%s)", spell.TargetType(), spellConfig.Name)
                        end
                        cmd("/target myself")
                    end

                    local mana = mq.TLO.Me.PctMana()
                    local hp = mq.TLO.Me.PctHPs()
                    if castSpellAbility(nil, row) then
                        if spellConfig.MaxMana ~= nil then
                            log.Info("USED LIFE SUPPORT \ay%s\ax at %d%% Mana (was %d%%)", spellName, mq.TLO.Me.PctMana(), mana)
                        else
                            all_tellf("USED LIFE SUPPORT \ay%s\ax at %d%% HP (was %d%%)", spellName, mq.TLO.Me.PctHPs(), hp)
                        end
                    end

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

    local spawn = spawn_from_peer_name(peer)
    if spawn == nil or spawn() == nil then
        log.Error("Cant heal peer \ar%s\ax, no such spawn", peer)
        return false
    end

    for k, heal in ipairs(spell_list) do

        local spellConfig = parseSpellLine(heal)
        if not spawn() then
            -- peer died
            return false
        elseif spawn.Distance() > 200 then
            return false
        elseif spellConfig.MinMana ~= nil and mq.TLO.Me.PctMana() < spellConfig.MinMana then
            --log.Debug("SKIP HEALING %s, my mana %d vs required %d", peer, mq.TLO.Me.PctMana(), spellConfig.MinMana)
        elseif spellConfig.HealPct ~= nil and pct > spellConfig.HealPct then
            -- remove, dont meet heal criteria
            --log.Debug("Skip using of heal, heal pct for %s is %d. dont need heal at %d for %s", spellConfig.Name, spellConfig.HealPct, pct, peer)
        elseif not have_spell(spellConfig.Name) and not have_item_inventory(spellConfig.Name) then
            -- SKIP clickes that is not on me
            log.Warn("Skip using of heal to heal %s at %d, I do not have item on me: %s", peer, pct, spellConfig.Name)
        elseif not have_spell(spellConfig.Name) and have_item_inventory(spellConfig.Name) and not is_item_clicky_ready(spellConfig.Name) then
            -- SKIP clickies that is not ready
            log.Debug("Skip using of heal to heal %s at %d, clicky %s is not ready", peer, pct, spellConfig.Name)
        elseif peer_has_buff(peer, spellConfig.Name) or peer_has_song(peer, spellConfig.Name) then
            -- if target got the buff/song named on, then skip (eg. HoT heals)
            log.Debug("healPeer skip %s, spell on them", spellConfig.Name)
        elseif not matches_filter(heal, mq.TLO.Me.Name()) then
            --log.Debug("healPeer skip heal %s (%s), not matching ONLY filter %s", peer, spellConfig.Name, heal)
        elseif peer_hp(peer) >= 98 then
            log.Info("Skipping heal! \ag%s\ax was %d %%, is now %d %%", peer, pct, peer_hp(peer))
        else
            log.Info("Healing \ag%s\ax at %d%% with \ay%s\ax", peer, pct, spellConfig.Name)
            mq.cmd("/target id %d", spawn.ID())

            local check = castSpellAbility(spawn.ID(), heal, function()
                if not is_casting() then
                    log.Info("Done casting heal, breaking")
                    return true
                end
                if mq.TLO.Target.ID() ~= spawn.ID() then
                    all_tellf("target changed in heal callback from %s to %s, breaking", spawn.Name(), mq.TLO.Target.Name())
                    return true
                end
                if mq.TLO.Target() ~= nil and mq.TLO.Target.PctHPs() >= 98 and not is_tank(mq.TLO.Target.Class.ShortName()) then
                    all_tellf("Ducking heal! \ag%s\ax was %d %%, is now %d %%", mq.TLO.Target.Name(), pct, mq.TLO.Target.PctHPs())
                    cmd("/interrupt")
                    return true
                end
                return false
            end)
            return true
        end
    end
    return false
end

return Heal
