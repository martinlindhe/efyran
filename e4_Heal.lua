local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'

require("e4_Spells")

local follow  = require("e4_Follow")
local globalSettings = require("e4_Settings")
local botSettings = require("e4_BotSettings")
local timer = require("Timer")

local timeZonedDelay = 10 -- seconds
local bci = broadCastInterfaceFactory()

local Heal = {
    ---@type boolean
    autoMed = true,

    -- Are we currently medding?
    ---@type boolean
    medding = false,

    ---@type integer in seconds
    timeZoned = os.time(),
}

function Heal.Init()
    mq.bind("/medon", function()
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/medon")
        end
        Heal.autoMed = true
        Heal.medCheck()
    end)

    mq.bind("/medoff", function()
        if is_orchestrator() then
            bci.ExecuteZoneCommand("/medoff")
        end
        Heal.autoMed = false
        Heal.medCheck()
    end)
end

local lifeSupportTimer = timer.new_expired(5 * 1) -- 5s

local groupBalanceTimer = timer.new_expired(30 * 1) -- 30s

local medTimer = timer.new_expired(1 * 5) -- 5s

function Heal.Tick()

    if is_hovering() or is_moving() or is_invisible() or is_feigning() then
        return
    end

    if os.time() - timeZonedDelay <= Heal.timeZoned then
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

function Heal.medCheck()

    if botSettings.settings.healing ~= nil and botSettings.settings.healing.automed ~= nil and not botSettings.settings.healing.automed then
        return
    end

    if is_sitting() and not window_open("SpellBookWnd") then
        -- make sure to proecss events in order to not stand up in case of "/camp" command, which would end the macro
        doevents()

        if mq.TLO.Me.MaxMana() > 1 and mq.TLO.Me.PctMana() >= 100 then
            all_tellf("Ending medbreak, [+g+]full mana[+x+].")
            cmd("/sit off")
            Heal.medding = false
            return
        end
        if mq.TLO.Me.MaxMana() == 0 and mq.TLO.Me.PctEndurance() >= 100 then
            all_tellf("Ending medbreak, [+g+]full endurance[+x+].")
            cmd("/sit off")
            Heal.medding = false
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

    if Heal.autoMed and not follow.IsFollowing() and medTimer:expired() and is_standing() and not is_moving() then
        local pct = botSettings.settings.meditate
        if pct == nil then
            if is_caster() or is_priest() or is_hybrid() then
                pct = 70
            else
                pct = 50
            end
        end
        if mq.TLO.Me.MaxMana() > 0 and mq.TLO.Me.PctMana() < pct then
            all_tellf("[+y+]Low mana[+x+], medding at [+y+]%d%%", mq.TLO.Me.PctMana())
            cmd("/sit on")
            Heal.medding = true
            medTimer:restart()
        end
        if mq.TLO.Me.MaxMana() == 0 and mq.TLO.Me.PctEndurance() < pct then
            all_tellf("[+y+]Low endurance[+x+], medding at [+y+]%d%%\ax", mq.TLO.Me.PctEndurance())
            cmd("/sit on")
            Heal.medding = true
            medTimer:restart()
        end
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
        log.Debug("performGroupBalanceHeal: not needed, average is %d%%", avg)
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

    if have_buff("Resurrection Sickness") or in_neutral_zone() then
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
            medTimer:restart()
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
                            all_tellf("USED LIFE SUPPORT [+y+]%s[+x+] at %d%% HP (was %d%%)", spellName, mq.TLO.Me.PctHPs(), hp)
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
        elseif spawn ~= nil and spawn.Distance() > 200 then
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
        elseif have_spell(spellConfig.Name) and not have_mana_for_spell(spellConfig.Name) then
            log.Debug("Want to heal %s with %s but OOM (have %d mana)", peer, spellConfig.Name, mq.TLO.Me.CurrentMana())
        elseif is_memorized(spellConfig.Name) and not is_spell_ready(spellConfig.Name) then
            log.Debug("Want to heal %s with %s but spell not ready!", peer, spellConfig.Name)
        else
            if not in_raid() then
                all_tellf("Healing [+g+]%s[+x+] at %d%% with [+y+]%s[+x+]", peer, pct, spellConfig.Name)
            else
                log.Info("Healing [+g+]%s[+x+] at %d%% with [+y+]%s[+x+]", peer, pct, spellConfig.Name)
            end
            mq.cmdf("/target pc =%s", peer)

            medTimer:restart()

            if not is_standing() then
                cmd("/stand")
                delay(300)
            end

            local check = castSpellAbility(spawn.ID(), heal, function()
                if not is_casting() then
                    log.Info("Done casting heal, breaking")
                    return true
                end
                if mq.TLO.Target.ID() ~= spawn.ID() then
                    all_tellf("target changed in heal callback from %s to %s, breaking", spawn.Name(), mq.TLO.Target.Name())
                    return true
                end
                if mq.TLO.Target() ~= nil and mq.TLO.Target.PctHPs() >= 98 and not class_tank(mq.TLO.Target.Class.ShortName()) then
                    log.Info("Ducking heal! \ag%s\ax was %d %%, is now %d %%", mq.TLO.Target.Name(), pct, mq.TLO.Target.PctHPs())
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
