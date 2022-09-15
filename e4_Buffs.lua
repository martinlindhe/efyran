local mq = require("mq")

require("e4_Spells")

local timer = require("Timer")

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
                cmd("/dgtell all MOUNT ERROR, cannot mount in "..zone_shortname())
                return
            end

            -- XXX see if mount clicky buff is on us already

            local spell = getSpellFromBuff(botSettings.settings.mount)
            if spell == nil then
                cmd("/dgtell all /mounton: getSpellFromBuff "..botSettings.settings.mount.." FAILED")
                cmd("/beep 1")
                return false
            end

            if have_buff(spell.RankName()) then
                print("I am already mounted.")
                return false
            end

            -- XXX dont summon if we are already mounted.
            print("Summoning mount ", botSettings.settings.mount)
            castSpell(botSettings.settings.mount, mq.TLO.Me.ID())
        end
    end)

    mq.bind("/mountoff", function()
        if is_orchestrator() then
            cmd("/dgzexecute /mountoff")
        end
        cmd("/dismount")
    end)

    -- if filter == "all", drop all. else drop partially matched buffs
    mq.bind("/dropbuff", function(filter)
        if filter == nil then
            return
        end
        if is_orchestrator() then
            cmd("/dgzexecute /dropbuff "..filter)
        end

        if filter == "all" then
            for i=1,mq.TLO.Me.MaxBuffSlots() do
                if mq.TLO.Me.Buff(i).ID() ~= nil then
                    print("removing buff ", i, "id:",mq.TLO.Me.Buff(i).ID(), ",name:", mq.TLO.Me.Buff(i).Name())
                    cmd("/removebuff "..mq.TLO.Me.Buff(i).Name())
                end
                delay(1)
            end
        else
            cmd("/removebuff "..filter)
        end
    end)

    mq.bind("/dropinvis", function()
        if is_orchestrator() then
            cmd("/dgzexecute /dropinvis")
        end

        drop_invis()
    end)

    mq.bind("/buffme", function()
        cmd("/dgzexecute /buffit "..mq.TLO.Me.ID())
    end)

    -- /buffit: asks bots to cast level appropriate buffs on current target
    mq.bind("/buffit", function(spawnID)
        --cmd("/dgtell all buffit ", spawnID)
        if is_orchestrator() then
            spawnID = mq.TLO.Target.ID()
            if spawnID ~= 0 then
                cmd("/dgzexecute /buffit "..spawnID)
            end
        end

        if botSettings.settings.group_buffs == nil then
            return
        end

        local spawn = spawn_from_query("id " .. spawnID)
        if spawn == nil then
            cmd("/dgtell all BUFFIT FAIL, cannot find target id in zone "..spawnID)
            return false
        end

        local level = spawn.Level()

        for key, buffs in pairs(botSettings.settings.group_buffs) do
            print("/buffit on ",spawn, "  ", type(spawn), ", finding best group buff ", key)

            -- XXX find the one with highest MinLevel
            local minLevel = 0
            local spellName = ""
            if type(buffs) ~= "table" then
                cmd("/dgtell all FATAL ERROR, group buffdata "..buffs.." should be a table")
                return
            end

            for k, buff in pairs(buffs) do
                local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
                local n = tonumber(spellConfig.MinLevel)
                if n == nil then
                    cmd("/dgtell all FATAL ERROR, group buff "..buff.." does not have a MinLevel setting")
                    return
                end
                if n > minLevel and level >= n then
                    minLevel = n
                    spellName = spellConfig.Name
                    local spell = get_spell(spellName)
                    if spell == nil then
                        cmd("/dgtell all FATAL ERROR cant lookup "..spellName)
                        return
                    end
                    if is_spell_in_book(spellName) then
                        spellName = spell.RankName()
                        if not spell.StacksTarget() then
                            cmd("/dgtell all ERROR cannot buff "..spawn.Name().." with "..spellName.." (dont stack with current buffs)")
                            return
                        end
                    end

                    --print("Best ", key, " buff so far is MinLevel ",spellConfig.MinLevel, " ", spellConfig.Name, " target ", spawn.Name() ," L", level)
                end
            end

            if minLevel > 0 then
                if spellConfigAllowsCasting(spellName, spawn) then
                    cmd("/dgtell all Buffing \ag"..spawn.Name().."\ax with "..spellName.." ("..key..")")
                    castSpellRaw(spellName, spawnID, "-maxtries|3")

                    -- sleep for the Duration
                    local spell = getSpellFromBuff(spellName)
                    if spell ~= nil then
                        delay(4000 + spell.MyCastTime() + spell.RecastTime()) -- XXX 4s for "memorize spell"
                    end
                end
            else
                print("Failed to find a matching group buff ", key, ", target ", spawn.Name(), " L", level)
            end
        end
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
            print("No Shrink clicky declared in self_buffs, giving up.")
            return
        end

        local item = find_item(spellConfig.Name)
        if item == nil then
            cmd("/dgtell all \arERROR\ax: Did not find Shrink clicky in inventory: " .. spellConfig.Name)
            return
        end
        print("Shrinking group members with ", spellConfig.Name, " item ", item.Clicky.Spell.Name())

        -- make sure shrink is targetable check buff type
        local spell = getSpellFromBuff(spellConfig.Name)
        if spell ~= nil and (spell.TargetType() == "Single" or spell.TargetType() == "Group v1") then
            -- loop over group, shrink one by one starting with yourself
            for n = 0, 5 do
                for i = 1, 3 do
                    if mq.TLO.Group.Member(n)() ~= nil and not mq.TLO.Group.Member(n).OtherZone() and mq.TLO.Group.Member(n).Height() > 2.04 then
                        print("Shrinking member ", mq.TLO.Group.Member(n)(), " from height ", mq.TLO.Group.Member(n).Height())
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

local refreshBuffsTimer = timer.new_random(20 * 1) -- 20s

local handleBuffsTimer = timer.new_random(3 * 1) -- 3s

function Buffs.Tick()
    if not is_brd() and is_casting() then
        return
    end

    if follow.spawn ~= nil or is_sitting() or is_hovering() or in_neutral_zone() or window_open("MerchantWnd") or window_open("GiveWnd") or window_open("BigBankWnd") or window_open("SpellBookWnd") or window_open("LootWnd") or spawn_count("pc radius 100") == 1 then
        return
    end

    if mq.TLO.Me.CombatState() == "COMBAT" then
        -- print("skip buffing, i am in combat!")
        return
    end

    --print("buff tick. refresh_buffs:", botSettings.toggles.refresh_buffs, ", expired:", refreshBuffsTimer:expired(), ", still:", not is_moving(), ", visible:", not is_invisible()  )
    if botSettings.toggles.refresh_buffs and refreshBuffsTimer:expired() and not is_moving() and not is_invisible() then
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
        cmd("/dgtell all FATAL ERROR: /queuebuff did not find groupBuffs."..class_shortname().." entry "..req.Buff)
        return false
    end

    local spawn = spawn_from_peer_name(req.Peer)
    if spawn == nil then
        cmd("/dgtell all FATAL ERROR: /queuebuff spawn not found "..req.Peer)
        return false
    end

    target_id(spawn.ID())

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
            cmd("/dgtell all FATAL ERROR, group buff "..checkRow.." does not have a MinLevel setting")
            return
        end
        if n > minLevel and level >= n then
            spellName = spellConfig.Name
            local spell = get_spell(spellName)
            if spell == nil then
                cmd("/dgtell all FATAL ERROR cant lookup "..spellName)
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
                print("Best ", req.Peer, " buff so far is MinLevel ", spellConfig.MinLevel, " ", spellConfig.Name, " target ", spawn.Name() ," L", level)
            end
        end
    end

    if minLevel > 0 and spellConfigAllowsCasting(spellName, spawn) then
        if spawn.Buff(spellName)() ~= nil then
            print("handleBuffRequest: Skip \ag", spawn.Name(), "\ax ", spellName, " (", req.Buff, "), they have buff already.")
            return false
        end

        cmd("/dgtell all Buffing \ag"..spawn.Name().."\ax with \ay"..spellName.."\ax (\ay"..req.Buff.."\ax).")
        castSpellRaw(spellName, spawn.ID(), "-maxtries|3")
        return true
    else
        print("Failed to find a matching group buff ", req.Buff, ", target ", spawn.Name(), " L", level)
    end
end

-- returns true if a buff was casted
function Buffs.RefreshSelfBuffs()
    if botSettings.settings.self_buffs == nil then
        return false
    end
    --print(time().." Buffs.RefreshSelfBuffs()")
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
            cmd("/dgtell all FATAL ERROR class default buffs missing for "..class_shortname())
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
                cmd("/dgtell all FATAL ERROR: did not find groupBuffs.Lookup entry "..spellConfig.Name)
                return false
            end

            local buffRows = groupBuffs[askClass][spellConfig.Name]
            if buffRows == nil then
                cmd("/dgtell all FATAL ERROR: did not find groupBuffs."..askClass.." entry "..spellConfig.Name)
                return false
            end

            -- see if we have any of this buff form on
            -- XXX assume what spell will be used and see if it will stack on me.
            local found = false
            local refresh = false
            for idx, checkRow in pairs(buffRows) do
                local o = parseSpellLine(checkRow)
                if have_buff(o.Name) then
                    local ticks = mq.TLO.Me.Buff(o.Name).Duration.Ticks()
                    if ticks ~= nil and ticks >= 6 then
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
                    cmd("/dgtell all FATAL ERROR: no peer of required class found nearby: "..askClass)
                    return true
                end

                if not refresh and free_buff_slots() <= 0 then
                    cmd("/dgtell all \arWARN\ax: Won't ask for \ay"..spellConfig.Name.."\ax as I only have "..free_buff_slots().." free buff slots")
                    return true
                end

                print("Requesting buff \ax"..spellConfig.Name.."\ay from \ag"..askClass.." "..peer.."\ax ...")
                cmd("/dexecute "..peer.." /queuebuff "..spellConfig.Name.." "..mq.TLO.Me.Name())
            end
        else
            --print("Will not request \ay", spellConfig.Name, "\ax. Not all classes available: \ayClass:"..spellConfig.Class..", NotClass:"..(spellConfig.NotClass or "").."\ax.")
        end
    end

    return false
end

-- returns true if a buff was casted
function Buffs.RefreshAura()
    if Buffs.aura == nil or mq.TLO.Me.Aura(1)() ~= nil then
        return false
    end
    castSpell(Buffs.aura, mq.TLO.Me.ID())
    return true
end

return Buffs

