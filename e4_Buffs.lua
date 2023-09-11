local mq = require("mq")
local log = require("efyran/knightlinc/Write")

require("efyran/e4_Spells")
local follow  = require("efyran/e4_Follow")
local pet     = require("efyran/e4_Pet")
local cure    = require("efyran/e4_Cure")
local botSettings = require("efyran/e4_BotSettings")
local groupBuffs  = require("efyran/e4_GroupBuffs")
local bard        = require("efyran/Class_Bard")

local timer = require("efyran/Timer")

local MIN_BUFF_DURATION = 6 * 6000 -- 6 ticks, each tick is 6s

---@class buffQueueValue
---@field public Peer string Peer name
---@field public Buff string Name of buff group
---@field public Force boolean Should we force-cast, or respect existing buff timers?

local buffs = {
    -- my aura spell, if any
    aura = find_best_aura(),

    -- queue of incoming buff requests
    ---@type buffQueueValue[]
    queue = {},

    ---@type string my available buff groups (space separated string)
    available = "",

    -- others available buff groups (key = peer, val = space separated string)
    otherAvailable = {},

    ---@type boolean /buffon, /buffoff
    refreshBuffs = true,

    ---@type integer
    lastPlayerCount = 0,

    ---@type integer in seconds
    timeZoned = os.time(),
}

function buffs.Init()
    -- enqueues a buff to be cast on a peer
    -- is normally called from another peer, to request a buff
    mq.bind("/buff", function(peer, buff, force)
        table.insert(buffs.queue, {
            Peer = peer,
            Buff = buff,
            Force = force == "force",
        })
    end)

    bard.resumeMelody()
end

local announceBuffsTimer = timer.new_expires_in(2 * 60, 3) -- announce buffs 3 sec after script start, then every 2 minutes

local refreshBuffsTimer = timer.new_expired(10) -- 10s

local requestBuffsTimer = timer.new_random(60 * 1) -- 60s

local handleBuffsTimer = timer.new_random(2 * 1) -- 2s

local checkDebuffsTimer = timer.new_random(15 * 1) -- 15s   -- interval for auto cure requests

-- broadcasts what buff groups we can cast
function buffs.AnnounceAvailablity()
    -- see what class group buffs I have and prepare a list of them so I can announce availability.
    local classBuffGroups = groupBuffs[class_shortname()]
    if classBuffGroups == nil then
        return
    end

    if mq.TLO.DanNet.PeerCount() <= 1 then
        return
    end

    -- only announce if number of players in zone changes (less spam)
    local playerCount = spawn_count("pc")
    if playerCount == buffs.lastPlayerCount then
        return
    end
    buffs.lastPlayerCount = playerCount

    local availableBuffGroups = ""
    for groupIdx, buffGroup in pairs(classBuffGroups) do
        -- see if we have any rank of this buff
        for rowIdx, checkRow in pairs(buffGroup) do
            local spellConfig = parseSpellLine(checkRow)
            if have_spell(spellConfig.Name) then
                availableBuffGroups = availableBuffGroups .. " " .. groupIdx
                break
            end
        end
    end
    buffs.available = trim(availableBuffGroups)
    if string.len(buffs.available) > 0 then
        -- log.Info("My available buff groups: %s", buffs.available)
        cmdf("/dgtell %s #available-buffs %s", dannet_zone_channel(), buffs.available)
    end
end

function dannet_zone_channel()
    local name = "zone_" .. current_server() .. "_" .. zone_shortname()
    return name:lower()
end

-- announce buff availability, handle debuffs, refresh buffs/auras/pets/pet buffs, request buffs and handle buff requests
function buffs.Tick()
    if not is_brd() and is_casting() then
        return
    end

    if is_naked() then
        return
    end

    -- XXX combat buffs should be done here (TODO implement combat buffs)

    if is_gm() or is_invisible() or is_hovering() then
        return
    end

    if checkDebuffsTimer:expired() then
        buffs.HandleDebuffs()
        checkDebuffsTimer:restart()
    end

    if in_combat() or not is_standing() or not allow_buff_in_zone() then
        return
    end

    if buffs.refreshBuffs and announceBuffsTimer:expired() then
        buffs.AnnounceAvailablity()
        announceBuffsTimer:restart()
    end

    if obstructive_window_open() then
        return
    end

    if buffs.RefreshIllusion() then
        return
    end

    if not is_moving() and buffs.refreshBuffs and refreshBuffsTimer:expired() then
        if not buffs.RefreshSelfBuffs() then
            if not buffs.RefreshAura() then
                if not pet.Summon() then
                    pet.BuffMyPet()
                end
            end
        end
        refreshBuffsTimer:restart()
    end

    if follow.IsFollowing() then
        return
    end

    if buffs.refreshBuffs and requestBuffsTimer:expired() then
        buffs.RequestBuffs()
        requestBuffsTimer:restart()
    end

    if is_brd() and bard.currentMelody ~= "" and not mq.TLO.Twist.Twisting() then
        all_tellf("WARN: Should be playing %s but am not (should not happen)", bard.currentMelody)
        bard.PlayMelody(bard.currentMelody)
    end

    if is_casting() or is_hovering() or is_sitting() or is_moving() or mq.TLO.Me.SpellInCooldown() or obstructive_window_open() then
        return
    end

    if #buffs.queue > 0 and handleBuffsTimer:expired() then
        local req = table.remove(buffs.queue, 1)
        if req ~= nil then
            if handleBuffRequest(req) then
                handleBuffsTimer:restart()
            end
        end
    end
end

--- Find debuffs to handle, in order to cure myself
function buffs.HandleDebuffs()

    if mq.TLO.Debuff.Count() > 0 then
        log.Info("Debuffed: %d poison, %d disease, %d curse, %d corruption. hp drain %d, mana drain %d, end drain %s, slowed %s, spell slowed %s, snared %s, casting level %s, healing eff %s, spell dmg eff %s",
            mq.TLO.Debuff.Poisons(), mq.TLO.Debuff.Diseases(), mq.TLO.Debuff.Curses(), mq.TLO.Debuff.Corruptions(),
            mq.TLO.Debuff.HPDrain(), mq.TLO.Debuff.ManaDrain(), mq.TLO.Debuff.EnduranceDrain(),
            tostring(mq.TLO.Debuff.Slowed()), tostring(mq.TLO.Debuff.SpellSlowed()), tostring(mq.TLO.Debuff.Snared()),
            tostring(mq.TLO.Debuff.CastingLevel()), tostring(mq.TLO.Debuff.HealingEff()), tostring(mq.TLO.Debuff.SpellDmgEff()))
    end

    --log.Debug("buffs.HandleDebuffs()")

    -- see if we have a recognized debuff
    for idx, row in pairs(cure.debuffs) do
        local spellConfig = parseSpellLine(row)
        if mq.TLO.Me.Buff(spellConfig.Name).ID() ~= nil then

            if matches_filter(spellConfig.Class) then

                log.Info("I have debuff \ar%s\ax, need \ay%s\ax cure.", spellConfig.Name, spellConfig.Cure)

                if me_priest() and  cure_player(mq.TLO.Me.Name(), spellConfig.Cure) then
                    return
                end

                -- if we cannot cure, ask a group memebr who can cure
                local curer = get_group_curer()
                if curer == nil then
                    -- TODO: in this case, just ask any curer nearby
                    all_tellf("FATAL: cant find a curer in my group: \ar%s\ax.", spellConfig.Name)
                    return
                end
                all_tellf("Asking \ag%s\ax to cure \ar%s\ax (\ay%s\ax)", curer, spellConfig.Name, spellConfig.Cure)
                cmdf("/dex %s /cure %s %s", curer, mq.TLO.Me.Name(), spellConfig.Cure)

            else
                all_tellf("I have \ar%s\ax but not asking for cure (not %s)", spellConfig.Name, spellConfig.Class)
            end
        end
    end

end

---@param spawnID integer
function buffs.BuffIt(spawnID)

    if buffs.available == nil then
        log.Debug("Stopping /buffit, no group_buffs available!")
        return
    end

    if not is_peer_id(spawnID) then
        log.Info("WARNING got a BuffIt request from unknown spawn %s", spawnID)
    end

    local spawn = spawn_from_id(spawnID)
    if spawn == nil then
        all_tellf("BUFFIT FAIL, cannot find spawn ID %d in %s", spawnID, zone_shortname())
        return
    end

    log.Debug("Handling /buffit request for spawn %s", spawnID)

    -- get the buffs for my class from the class defaults for `spawn`.
    for idx, key in pairs(groupBuffs.Default[spawn.Class.ShortName()]) do
        local spellConfig = parseSpellLine(key)
        if spellConfig.Class == class_shortname() then
            cmdf("/buff %s %s force", spawn.Name(), spellConfig.Name)
        end
    end
end

function getClassBuffGroup(classShort, buffGroup)
    local buffRows = groupBuffs[classShort][buffGroup]
    if buffRows == nil then
        all_tellf("FATAL ERROR: did not find groupBuffs.%s entry %s", classShort, buffGroup)
        return false
    end
end

-- returns true if spell is cast
---@param req buffQueueValue
function handleBuffRequest(req)

    log.Info("handleBuffRequest: Peer %s, buff %s, queue len %d, force = %s", req.Peer, req.Buff, #buffs.queue, tostring(req.Force))

    local buffRows = groupBuffs[class_shortname()][req.Buff]
    if buffRows == nil then
        all_tellf("ERROR: handleBuffRequest: did not find groupBuffs.%s entry %s", class_shortname(), req.Buff)
        return false
    end

    local spawn = spawn_from_peer_name(req.Peer)
    if spawn == nil then
        -- happens when zoning
        log.Error("handleBuffRequest: Spawn not found %s", req.Peer)
        return false
    end

    target_id(spawn.ID())
    wait_for_buffs_populated()

    -- find the one with highest MinLevel
    local minLevel = 0
    local spellName = ""

    local level = spawn.Level()
    if level == nil then
        all_tellf("\arFATAL level is nil, from peer %s, buff %s", req.Peer, req.Buff)
    end

    if type(level) ~= "number" then
        all_tellf("\arFATAL level is not a number: %s: %s, from peer %s, buff %s, input %s", type(level), tostring(level), req.Peer, req.Buff, checkRow)
        return
    end

    -- see if we have any rank of this buff
    for idx, checkRow in pairs(buffRows) do
        --print(checkRow)

        -- XXX same logic as /buffit. do refactor

        local spellConfig = parseSpellLine(checkRow)  -- XXX do not parse here, cache and reuse
        local n = tonumber(spellConfig.MinLevel)
        if n == nil then
            all_tellf("FATAL ERROR, group buff %s does not have a MinLevel setting", checkRow)
            return
        end
        -- XXX debug source of nil
        if type(n) ~= "number" then
            log.Error("DEBUG: n is not a number, from peer %s, buff %s", req.Peer, req.Buff)
        end
        if type(n) == "number" and n > minLevel and level >= n then
            spellName = spellConfig.Name
            local spell = get_spell(spellName)
            if spell == nil then
                all_tellf("FATAL ERROR cant lookup %s", spellName)
                return
            end
            if have_spell(spellName) then
                spellName = spell.RankName()
                --if spell.StacksTarget() then
                    minLevel = n
                    --print("minLevel = ", n)
                --else
                    -- XXX look into: seems spell.StacksTarget() checks vs myself instead of my target... is it a mq2-lua bug ????  cant cast Symbol of Naltron from CLR with higher sytmbol on a naked WAR.
                --    cmd("/dgtell all ERROR cannot buff ", spawn.Name(), " with ", spellName, ", MinLevel ", n, " (dont stack with current buffs)")
                --end
                --log.Debug("Best %s buff so far is MinLevel %d, Name %s, target L%d %s", req.Peer, spellConfig.MinLevel, spellConfig.Name, level, spawn.Name())
            end
        end
    end

    if minLevel > 0 and spellConfigAllowsCasting(spellName, spawn) then
        if not req.Force and spawn.Buff(spellName)() ~= nil and spawn.Buff(spellName).Duration() >= MIN_BUFF_DURATION then
            log.Info("handleBuffRequest: Skip \ag%s\ax %s (%s), they have buff already. %d sec", spawn.Name(), spellName, req.Buff, spawn.Buff(spellName).Duration())
            return false
        end

        log.Info("Buffing \ag%s\ax with \ay%s\ax (\ay%s\ax).", spawn.Name(), spellName, req.Buff)
        castSpellRaw(spellName, spawn.ID(), "-maxtries|3")
        delay(100)
        doevents()
        delay(10000, function()
            if not is_casting() then
                return true
            end
            if not req.Force and spawn.Buff(spellName)() ~= nil and spawn.Buff(spellName).Duration() >= MIN_BUFF_DURATION then
                -- abort if they got the buff while we are casting
                -- FIXME: this often triggers when spell had completed casting
                log.Info("handleBuffRequest: My target %s has buff %s for %f sec, ducking.", mq.TLO.Target.Name(), spellName, mq.TLO.Target.Buff(spellName).Duration() / 1000)
                cmdf("/interrupt")
                return true
            end
        end)
        return true
    else
        log.Warn("\arERROR: I do not have any buffs matching %s\ax to cast on L%d %s", req.Buff, level, spawn.Name())
    end
end

-- returns true if a buff was casted
function buffs.RefreshSelfBuffs()
    if botSettings.settings.self_buffs == nil or is_sitting() or is_moving() then
        return false
    end
    --log.Debug("Buffs.RefreshSelfBuffs()")
    for k, buffItem in pairs(botSettings.settings.self_buffs) do
        if refreshBuff(buffItem, mq.TLO.Me) then
            -- end after first successful buff
            return true
        end
    end
    return false
end

-- returns true if a buff *with cast time* was casted
function buffs.RefreshIllusion()
    if botSettings.settings.illusions == nil then
        return false
    end

    local key = botSettings.settings.illusions.default
    if key == nil or key == "" then
        return false
    end

    -- A: The default illusion refers to another key
    local illusion = botSettings.settings.illusions[key]
    if illusion ~= nil then
        return refreshBuff(illusion, mq.TLO.Me)
    end

    -- B: The default illusion refers to a specific clicky/spell
    return refreshBuff(key, mq.TLO.Me)
end

-- returns true if buff was requested
function buffs.RequestBuffs()

    local req = botSettings.settings.request_buffs
    if req == nil then
        req = groupBuffs.Default[class_shortname()]
        if req == nil then
            -- unlikely
            all_tellf("FATAL ERROR class default buffs missing for %s", class_shortname())
            delay(20000)
            return
        end
    end

    --print("Buffs.RequestBuffs")

    local availableClasses = find_available_classes()

    for k, row in pairs(req) do
        -- "aegolism/Class|CLR/NotClass|DRU"
        local spellConfig = parseSpellLine(row)
        --log.Debug("Considering to request \ay%s\ax.", spellConfig.Name)

        local skip = false
        local classes = split_str(spellConfig.Class, ",")
        for classIdx, class in pairs(classes) do
            --log.Debug("- Class: do we have class \ax%s\ay available? %s", class, tostring(availableClasses[class] == true))
            if availableClasses[class] ~= true then
                skip = true
            end
        end

        if spellConfig.NotClass ~= nil then
            local notClasses = split_str(spellConfig.NotClass, ",")
            for classIdx, class in pairs(notClasses) do
                --log.Debug("- NotClass: do we have class \ax%s\ay available? %s", class, tostring(availableClasses[class] == true))
                if availableClasses[class] == true then
                    skip = true
                end
            end
        end

        if not skip then
            local askClass = groupBuffs.Lookup[spellConfig.Name]
            if askClass == nil then
                all_tellf("\arFATAL ERROR\ax: did not find groupBuffs.Lookup entry %s", spellConfig.Name)
                return false
            end

            local buffRows = groupBuffs[askClass][spellConfig.Name]
            if buffRows == nil then
                all_tellf("\arFATAL ERROR\ax: did not find groupBuffs.%s entry %s", askClass, spellConfig.Name)
                return false
            end

            -- see if we have any of this buff form on
            -- XXX assume what spell will be used and see if it will stack on me.
            local found = false
            local refresh = false
            for idx, checkRow in pairs(buffRows) do
                local o = parseSpellLine(checkRow)
                if have_buff(o.Name) then
                    local duration = mq.TLO.Me.Buff(o.Name).Duration()
                    if duration ~= nil and duration >= MIN_BUFF_DURATION then
                        --log.Debug("Will not request \ay%s\ax. I have buff \ay%s\ax for %d more ticks.", spellConfig.Name, o.Name, duration)
                        found = true
                        break
                    else
                        -- only check for free buff slots if we are not refreshing buff
                        refresh = true
                    end
                end
            end

            -- ask proper class for buff
            if not found then
                local peer = buffs.findAvailableBuffer(spellConfig.Name)
                if peer ~= nil then
                    if not refresh and free_buff_slots() <= 0 then
                        all_tellf("\arWARN\ax: Won't ask for \ay%s\ax as I only have %d free buff slots", spellConfig.Name, free_buff_slots())
                        return true
                    else
                        log.Info("Requesting buff \ay%s\ax from \ag%s %s\ax ...", spellConfig.Name, askClass, peer)
                        cmdf("/squelch /dexecute %s /buff %s %s", peer, mq.TLO.Me.Name(), spellConfig.Name)
                    end
                else
                    log.Debug("No peer of required class for buff %s found nearby: %s", spellConfig.Name, askClass)
                end
            end
        else
            --log.Debug("Will not request \ay%s\ax. Required class combo is not met: \ayClass:%s, NotClass:%s\ax.", spellConfig.Name, spellConfig.Class, spellConfig.NotClass or "")
        end
    end

    return false
end

-- Find the closest buffer peer who announced they have the desired buff group available
---@return string|nil
function buffs.findAvailableBuffer(buffGroup)
    for peer, availableGroups in pairs(buffs.otherAvailable) do
        if availableGroups:find(buffGroup) then
            --log.Debug("peer %s, buff groups: %s", peer, buffGroups)
            return peer
        end
    end
    return nil
end

-- returns true if a buff was casted
function buffs.RefreshAura()
    if buffs.aura == nil or mq.TLO.Me.Aura(1)() ~= nil or is_sitting() or is_moving() then
        return false
    end
    if have_combat_ability(buffs.aura) then
        use_combat_ability(buffs.aura)
    else
        castSpellRaw(buffs.aura, nil)
    end
    return true
end

return buffs

