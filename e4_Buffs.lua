local mq = require("mq")
local log = require("knightlinc/Write")

require("e4_Spells")

local timer = require("Timer")

local MIN_BUFF_DURATION = 6 * 6000 -- 6 ticks, each tick is 6s

local Buffs = { aura = find_best_aura(), queue = {} }

function Buffs.Init()
    mq.bind("/buffon", function()
        botSettings.toggles.refresh_buffs = true
        if is_orchestrator() then
            cmd("/dgzexecute /buffon")
        end
    end)

    mq.bind("/buffoff", function()
        botSettings.toggles.refresh_buffs = false
        if is_orchestrator() then
            cmd("/dgzexecute /buffoff")
        end
    end)

    mq.bind("/mounton", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mounton")
        end

        if botSettings.settings.mount ~= nil then

            if not mq.TLO.Me.CanMount() then
                cmdf("/dgtell all MOUNT ERROR, cannot mount in %s", zone_shortname())
                return
            end

            -- XXX see if mount clicky buff is on us already

            local spell = getSpellFromBuff(botSettings.settings.mount)
            if spell == nil then
                cmdf("/dgtell all /mounton: getSpellFromBuff %s FAILED", botSettings.settings.mount)
                cmd("/beep 1")
                return false
            end

            if have_buff(spell.RankName()) then
                log.Error("I am already mounted.")
                return false
            end

            -- XXX dont summon if we are already mounted.
            log.Info("Summoning mount %s ...", botSettings.settings.mount)
            castSpell(botSettings.settings.mount, mq.TLO.Me.ID())
        end
    end)

    mq.bind("/mountoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mountoff")
        end
        log.Info("Dismounting ...")
        cmd("/dismount")
    end)

    -- if filter == "all", drop all. else drop partially matched buffs
    mq.bind("/dropbuff", function(filter)
        if filter == nil then
            return
        end
        if is_orchestrator() then
            cmdf("/dgzexecute /dropbuff %s", filter)
        end

        if filter == "all" then
            drop_all_buffs()
        else
            cmdf("/removebuff %s", filter)
        end
    end)

    mq.bind("/dropinvis", function()
        if is_orchestrator() then
            cmd("/dgzexecute /dropinvis")
        end

        drop_invis()
    end)

    mq.bind("/buffme", function()
        cmdf("/dgzexecute /buffit %d", mq.TLO.Me.ID())
    end)

    -- /buffit: asks bots to cast level appropriate buffs on current target
    mq.bind("/buffit", function(spawnID)
        --cmd("/dgtell all buffit ", spawnID)
        if is_orchestrator() then
            spawnID = mq.TLO.Target.ID()
            if spawnID ~= 0 then
                cmdf("/dgzexecute /buffit %d", spawnID)
            end
        end

        -- XXX group_buffs was nuked
        if botSettings.settings.group_buffs == nil then
            log.Info("Stopping /buffit, no group_buffs configured!")
            return
        end

        log.Debug("Handling /buffit request for spawn %s", spawnID)

        local spawn = spawn_from_query("id "..spawnID)
        if spawn == nil then
            cmdf("/dgtell all BUFFIT FAIL, cannot find spawn ID %d in %s", spawnID, zone_shortname())
            return false
        end

        local level = spawn.Level()

        for key, buffs in pairs(botSettings.settings.group_buffs) do
            log.Debug("/buffit on %s, type %s, finding best group buff %s", spawn, type(spawn), key)

            -- XXX find the one with highest MinLevel
            local minLevel = 0
            local spellName = ""
            if type(buffs) ~= "table" then
                cmdf("/dgtell all FATAL ERROR, buffdata %s should be a table", buffs)
                return
            end

            for k, buff in pairs(buffs) do
                local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
                local n = tonumber(spellConfig.MinLevel)
                if n == nil then
                    cmdf("/dgtell all FATAL ERROR, group buff %s does not have a MinLevel setting", buff)
                    return
                end
                if n > minLevel and level >= n then
                    minLevel = n
                    spellName = spellConfig.Name
                    local spell = get_spell(spellName)
                    if spell == nil then
                        cmdf("/dgtell all FATAL ERROR cant lookup %s", spellName)
                        return
                    end
                    if is_spell_in_book(spellName) then
                        spellName = spell.RankName()
                        if not spell.StacksTarget() then
                            cmdf("/dgtell all ERROR cannot buff %s with %s (dont stack with current buffs)", spawn.Name(), spellName)
                            return
                        end
                    end

                    log.Debug("Best %s buff so far is MinLevel %d, Name %s, target L%d %s", key, spellConfig.MinLevel, spellConfig.Name, level, spawn.Name())
                end
            end

            if minLevel > 0 then
                if spellConfigAllowsCasting(spellName, spawn) then
                    cmdf("/dgtell all Buffing \ag%s\ax with %s (%s)", spawn.Name(), spellName, key)
                    castSpellRaw(spellName, spawnID, "-maxtries|3")

                    -- sleep for the Duration
                    local spell = getSpellFromBuff(spellName)
                    if spell ~= nil then
                        delay(3000 + spell.MyCastTime() + spell.RecastTime()) -- XXX 3s for "memorize spell". need a better "memorize if needed and wait while memorizing"-helper
                    end
                end
            else
                log.Error("Failed to find a matching group buff %s, target L%d %s", key, level, spawn.Name())
            end
        end
    end)

    mq.bind("/shrinkall", function()
        cmd("/dgzexecute /shrinkgroup")
    end)

    mq.bind("/shrinkgroup", function()
        -- find the shrink clicky/spell if we got one
        local shrinkClicky = nil
        local spellConfig
        for key, buff in pairs(botSettings.settings.self_buffs) do
            spellConfig = parseSpellLine(buff)
            if spellConfig.Shrink ~= nil and spellConfig.Shrink then
                shrinkClicky = buff
                break
            end
        end

        if shrinkClicky == nil or not in_group() then
            log.Error("No Shrink clicky declared in self_buffs, giving up.")
            return
        end

        local item = find_item(spellConfig.Name)
        if item == nil then
            cmdf("/dgtell all \arERROR\ax: Did not find Shrink clicky in inventory: %s", spellConfig.Name)
            return
        end
        log.Info("Shrinking group members with %s", item.ItemLink("CLICKABLE")())

        -- make sure shrink is targetable check buff type
        local spell = getSpellFromBuff(spellConfig.Name)
        if spell ~= nil and (spell.TargetType() == "Single" or spell.TargetType() == "Group v1") then
            -- loop over group, shrink one by one starting with yourself
            for n = 0, 5 do
                for i = 1, 3 do
                    if mq.TLO.Group.Member(n)() ~= nil and not mq.TLO.Group.Member(n).OtherZone() and mq.TLO.Group.Member(n).Height() > 2.04 then
                        log.Info("Shrinking member %s from height %d", mq.TLO.Group.Member(n)(), mq.TLO.Group.Member(n).Height())
                        castSpell(spellConfig.Name, mq.TLO.Group.Member(n).ID())
                        -- sleep for the Duration
                        delay(item.Clicky.CastTime() + spell.RecastTime())
                    end
                end
            end
        end
    end)

    -- enqueues a buff to be cast on a peer
    -- is normally called from another peer, to request a buff
    mq.bind("/queuebuff", function(buff, peer)
        --print("queuebuff buff=", buff, ", peer=", peer)
        table.insert(Buffs.queue, {
            ["Peer"] = peer,
            ["Buff"] = buff,
        })
    end)
end

local refreshBuffsTimer = timer.new_random(10 * 1) -- 10s

local handleBuffsTimer = timer.new_random(3 * 1) -- 3s

function Buffs.Tick()
    if not is_brd() and is_casting() then
        return
    end

    if follow.spawn ~= nil or is_gm() or is_hovering() or in_combat() or is_moving() or in_neutral_zone() or window_open("MerchantWnd") or window_open("GiveWnd") or window_open("BigBankWnd") or window_open("SpellBookWnd") or window_open("LootWnd") or spawn_count("pc radius 100") == 1 then
        return
    end

    if botSettings.toggles.refresh_buffs and refreshBuffsTimer:expired() and not is_invisible() then
        log.Debug("Buff tick: refresh buffs at %s", time())
        if not buffs.RefreshSelfBuffs() then
            if not buffs.RefreshAura() then
                if not pet.Summon() then
                    if not pet.BuffMyPet() then
                        buffs.RequestBuffs()
                    end
                end
            end
        end
        refreshBuffsTimer:restart()
    end

    if is_casting() or is_hovering() or is_sitting() or is_moving() or mq.TLO.Me.SpellInCooldown() or window_open("SpellBookWnd") then
        return
    end

    --print("QUEUE LEN = ", table.getn(Buffs.queue))
    if #Buffs.queue > 0 and handleBuffsTimer:expired() then
        local req = table.remove(Buffs.queue, 1)
        if req ~= nil then
            if handleBuffRequest(req) then
                handleBuffsTimer:restart()
            end
        else
            cmd("/dgtell all ERR queue fetch returned NIL")
        end
    end

end


-- returns true if spell is cast
function handleBuffRequest(req)

    --print("handleBuffRequest: Peer ", req.Peer, ", buff ", req.Buff, ", queue len ", table.getn(Buffs.queue))

    local buffRows = groupBuffs[class_shortname()][req.Buff]
    if buffRows == nil then
        cmdf("/dgtell all FATAL ERROR: /queuebuff did not find groupBuffs.%s entry %s", class_shortname(), req.Buff)
        return false
    end

    local spawn = spawn_from_peer_name(req.Peer)
    if spawn == nil then
        -- happens when zoning
        log.Error("/queuebuff spawn not found %s", req.Peer)
        return false
    end

    target_id(spawn.ID())

    -- wait for buff populared
    delay(3000, function()
        if spawn.BuffsPopulated() then
            log.Info("Buffs populated for %s (%s)!", spawn.Name(), req.Buff)
            return true
        end
    end)
    delay(100)

    -- find the one with highest MinLevel
    local minLevel = 0
    local spellName = ""

    local level = spawn.Level()

    -- see if we have any of this buff form on
    for idx, checkRow in pairs(buffRows) do
        --print(checkRow)

        -- XXX same logic as /buffit. do refactor

        local spellConfig = parseSpellLine(checkRow)  -- XXX do not parse here, cache and reuse
        local n = tonumber(spellConfig.MinLevel)
        if n == nil then
            cmdf("/dgtell all FATAL ERROR, group buff %s does not have a MinLevel setting", checkRow)
            return
        end
        -- XXX debug source of nil
        if type(n) ~= "number" then
            all_tellf("FATAL n is not a number")
        end
        if type(minLevel) ~= "number" then
            all_tellf("FATAL minLevel is not a number")
        end
        if type(level) ~= "number" then
            all_tellf("FATAL level is not a number")
        end
        if n > minLevel and level >= n then
            spellName = spellConfig.Name
            local spell = get_spell(spellName)
            if spell == nil then
                cmdf("/dgtell all FATAL ERROR cant lookup %s", spellName)
                return
            end
            if is_spell_in_book(spellName) then
                spellName = spell.RankName()
                --if spell.StacksTarget() then
                    minLevel = n
                    --print("minLevel = ", n)
                --else
                    -- XXX look into: seems spell.StacksTarget() checks vs myself instead of my target... is it a mq2-lua bug ????  cant cast Symbol of Naltron from CLR with higher sytmbol on a naked WAR.
                --    cmd("/dgtell all ERROR cannot buff ", spawn.Name(), " with ", spellName, ", MinLevel ", n, " (dont stack with current buffs)")
                --end
            end

            if n > minLevel then
                log.Debug("Best %s buff so far is MinLevel %d, Name %s, target L%d %s", req.Peer, spellConfig.MinLevel, spellConfig.Name, level, spawn.Name())
            end
        end
    end

    if minLevel > 0 and spellConfigAllowsCasting(spellName, spawn) then
        if spawn.Buff(spellName)() ~= nil and spawn.Buff(spellName).Duration() >= MIN_BUFF_DURATION then
            log.Info("handleBuffRequest: Skip \ag%s\ax %s (%s), they have buff already. %d sec", spawn.Name(), spellName, req.Buff, spawn.Buff(spellName).Duration())
            return false
        end

        -- XXX is being cast even tho target has the buff... should duck in callback
        all_tellf("Buffing \ag%s\ax with \ay%s\ax (\ay%s\ax).", spawn.Name(), spellName, req.Buff)
        castSpellRaw(spellName, spawn.ID(), "-maxtries|3")
        delay(100)
        delay(10000, function()
            if not is_casting() then
                return true
            end
            if spawn.Buff(spellName)() ~= nil and spawn.Buff(spellName).Duration() >= MIN_BUFF_DURATION then
                -- abort if they got the buff while we are casting
                -- XXX also often triggers when spell had completed casting ... ??!?
                all_tellf("\arERROR MID-BUFFING:\ax my target %s has buff %s for %f sec, ducking.", mq.TLO.Target.Name(), spellName, mq.TLO.Target.Buff(spellName).Duration() / 1000)
                cmdf("/interrupt")
                return true
            end
        end)
        return true
    else
        all_tellf("Failed to find a matching group buff %s, L%d %s", req.Buff, level, spawn.Name())
    end
end

function all_tellf(...)
    cmdf("/dgtell all [%s] %s", time(), string.format(...))
end

-- returns true if a buff was casted
function Buffs.RefreshSelfBuffs()
    if botSettings.settings.self_buffs == nil or is_sitting() then
        return false
    end
    log.Debug("Buffs.RefreshSelfBuffs() %s", time())
    for k, buffItem in pairs(botSettings.settings.self_buffs) do
        doevents()
        if refreshBuff(buffItem, mq.TLO.Me) then
            -- end after first successful buff
            return true
        end
    end
    return false
end

-- returns true if buff was requested
function Buffs.RequestBuffs()

    local req = botSettings.settings.request_buffs
    if req == nil then
        req = groupBuffs.Default[class_shortname()]
        if req == nil then
            cmdf("/dgtell all FATAL ERROR class default buffs missing for %s", class_shortname())
            delay(20000)
            return
        end
    end

    --print("Buffs.RequestBuffs")

    local availableClasses = find_available_classes()

    for k, row in pairs(req) do
        -- "aegolism/Class|CLR/NotClass|DRU"
        local spellConfig = parseSpellLine(row)
        --print("I want to request \ay"..spellConfig.Name.."\ax.")

        local skip = false
        local classes = split_str(spellConfig.Class, ",")
        for classIdx, class in pairs(classes) do
            --print("- Class: do we have class \ax"..class.."\ay available? ", availableClasses[class] == true)
            if availableClasses[class] ~= true then
                skip = true
            end
        end

        if spellConfig.NotClass ~= nil then
            local notClasses = split_str(spellConfig.NotClass, ",")
            for classIdx, class in pairs(notClasses) do
                --print("- NotClass: do we have class \ax"..class.."\ay available? ", availableClasses[class] == true)
                if availableClasses[class] == true then
                    skip = true
                end
            end
        end

        if not skip then
            local askClass = groupBuffs.Lookup[spellConfig.Name]
            if askClass == nil then
                cmdf("/dgtell all FATAL ERROR: did not find groupBuffs.Lookup entry %s", spellConfig.Name)
                return false
            end

            local buffRows = groupBuffs[askClass][spellConfig.Name]
            if buffRows == nil then
                cmdf("/dgtell all FATAL ERROR: did not find groupBuffs.%s entry %s", askClass, spellConfig.Name)
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
                        --print("Will not request \ay", spellConfig.Name, "\ax. I have buff \ay"..o.Name.."\ax.")
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
                local peer = nearest_peer_by_class(askClass)
                if peer == nil then
                    cmdf("/dgtell all FATAL ERROR: no peer of required class found nearby: %s", askClass)
                    return true
                end

                if not refresh and free_buff_slots() <= 0 then
                    cmdf("/dgtell all \arWARN\ax: Won't ask for \ay%s\ax as I only have %d free buff slots", spellConfig.Name, free_buff_slots())
                    return true
                end

                log.Info("Requesting buff \ax%s\ay from \ag%s %s\ax ...", spellConfig.Name, askClass, peer)
                cmdf("/dexecute %s /queuebuff %s %s", peer, spellConfig.Name, mq.TLO.Me.Name())
            end
        else
            --print("Will not request \ay", spellConfig.Name, "\ax. Not all classes available: \ayClass:"..spellConfig.Class..", NotClass:"..(spellConfig.NotClass or "").."\ax.")
        end
    end

    return false
end

-- returns true if a buff was casted
function Buffs.RefreshAura()
    if Buffs.aura == nil or mq.TLO.Me.Aura(1)() ~= nil or is_sitting() then
        return false
    end
    castSpell(Buffs.aura, mq.TLO.Me.ID())
    return true
end

return Buffs

