require("e4_Spells")

local timer = require("Timer")

local Buffs = { aura = findBestAura() }

function Buffs.Init()
    mq.bind("/buffon", function()
        botSettings.toggles.refresh_buffs = true
        if is_orchestrator() then
            mq.cmd.dgzexecute("/buffon")
        end
    end)

    mq.bind("/buffoff", function()
        botSettings.toggles.refresh_buffs = false
        if is_orchestrator() then
            mq.cmd.dgzexecute("/buffoff")
        end
    end)

    mq.bind("/mounton", function()
        if is_orchestrator() then
            mq.cmd.dgzexecute("/mounton")
        end

        if botSettings.settings.mount ~= nil then

            if not mq.TLO.Me.CanMount() then
                mq.cmd.dgtell("all MOUNT ERROR, cannot mount in ", mq.TLO.Zone.Name())
                return
            end

            -- XXX see if mount clicky buff is on us already


            local spell = getSpellFromBuff(botSettings.settings.mount) 
            if spell == nil then
                mq.cmd.dgtell("/mounton: getSpellFromBuff ", buffItem, " FAILED")
                mq.cmd.beep(1)
                return false
            end

            if mq.TLO.Me.Buff(spell.RankName)() ~= nil then
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
            mq.cmd.dgzexecute("/mountoff")
        end
        mq.cmd.dismount() 
    end)

    -- if filter == "all", drop all. else drop partially matched buffs
    mq.bind("/dropbuff", function(filter)
        if filter == nil then
            return
        end
        if is_orchestrator() then
            mq.cmd.dgzexecute("/dropbuff", filter)
        end

        if filter == "all" then
            for i=1,mq.TLO.Me.MaxBuffSlots() do
                if mq.TLO.Me.Buff(i).ID() ~= nil then
                    print("removing buff ", i, "id:",mq.TLO.Me.Buff(i).ID(), ",name:", mq.TLO.Me.Buff(i).Name())
                    mq.cmd.removebuff(mq.TLO.Me.Buff(i).Name())
                    mq.delay(1)
                end
            end
        else
            mq.cmd.removebuff(filter)
        end
    end)

    mq.bind("/buffme", function()
        mq.cmd.dgaexecute("/buffit", mq.TLO.Me.ID())
    end)

    -- /buffit: asks bots to cast level appropriate buffs on current target
    mq.bind("/buffit", function(spawnID)
        --mq.cmd.dgtell("all buffit ", spawnID)
        if is_orchestrator() then
            spawnID = mq.TLO.Target.ID()
            if spawnID ~= 0 then
                mq.cmd.dgzexecute("/buffit", spawnID)
            end
        end

        if botSettings.settings.group_buffs == nil then
            return
        end

        local spawn = mq.TLO.Spawn("id " .. spawnID)
        mq.cmd("/target id "..spawnID)
        mq.delay(1000, function()
            print("... targetig id ...")
            return mq.TLO.Target.ID() == tonumber(spawnID)
        end)

        if tostring(spawn) == "NULL" then
            mq.cmd.dgtell("all BUFFIT FAIL, cannot find target id in zone ", spawnID)
            return false
        end

        local level = spawn.Level()

        for key, buffs in pairs(botSettings.settings.group_buffs) do
            print("/buffit on ",spawn, "  ", type(spawn), ", finding best group buff ", key)

            -- XXX find the one with highest MinLevel
            local minLevel = 0
            local spellName = ""
            if type(buffs) ~= "table" then
                mq.cmd.dgtell("all FATAL ERROR, group buffdata ", buffs, " should be a table")
                return
            end

            for k, buff in pairs(buffs) do
                local spellConfig = parseSpellLine(buff)  -- XXX do not parse here, cache and reuse
                local n = tonumber(spellConfig.MinLevel)
                if n == nil then
                    mq.cmd.dgtell("all FATAL ERROR, group buff ", buff, " does not have a MinLevel setting")
                    return
                end
                if n > minLevel and level >= n then
                    minLevel = n
                    spellName = spellConfig.Name
                    local spell = mq.TLO.Spell(spellName)
                    if spell() == nil then
                        mq.cmd.dgtell("all FATAL ERROR cant lookup ", spellName)
                        return
                    end
                    if is_spell_in_book(spellName) then
                        spellName = spell.RankName()
                        if not spell.StacksTarget() then
                            mq.cmd.dgtell("all ERROR cannot buff ", spawn.Name(), " with ", spellName, " (dont stack with current buffs)")
                            return
                        end
                    end

                    --print("Best ", key, " buff so far is L",spellConfig.MinLevel, " ", spellConfig.Name, " target ", spawn.Name() ," L", level)
                end
            end

            if minLevel > 0 then
                if spellConfigAllowsCasting(spellName, spawn) then
                    mq.cmd.dgtell("all Buffing \ag", spawn.Name(), "\ax with ", spellName, " (", key, ")")
                    castSpellRaw(spellName, spawnID, "-maxtries|3")

                    -- sleep for the Duration
                    local spell = getSpellFromBuff(spellName)
                    mq.delay(4000 + spell.MyCastTime() + spell.RecastTime()) -- XXX 4s for "memorize spell"
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

        if shrinkClicky == nil or mq.TLO.Group() == nil then
            print("I DONT HAVE A SHRINK CLICKY/SPELL, GIVING UP")
            return
        end

        local item = get_item(spellConfig.Name)
        print("Shrinking group members with ", spellConfig.Name, " item ", item)

        -- make sure shrink is targetable check buff type
        local spell = getSpellFromBuff(spellConfig.Name)
        if spell.TargetType() == "Single" or spell.TargetType() == "Group v1" then
            -- loop over group, shrink one by one
            for n = 1,5 do
                for i = 1, 3 do
                    if mq.TLO.Group.Member(n)() ~= nil and not mq.TLO.Group.Member(n).OtherZone() and mq.TLO.Group.Member(n).Height() > 2.04 then
                        print("shrink member ", mq.TLO.Group.Member(n)(), " from height ", mq.TLO.Group.Member(n).Height())
                        castSpell(spellConfig.Name, mq.TLO.Group.Member(n).ID())
                        -- sleep for the Duration
                        mq.delay(item.Clicky.CastTime() + spell.RecastTime())
                    end
                end
            end
        end

    end)
end

local refreshBuffsTimer = timer.new_expired(3 * 1) -- 4s

function Buffs.Tick()
    if not is_brd() and is_casting() then
        return
    end

    if is_hovering() or in_neutral_zone() or window_open("MerchantWnd") or spawn_count("pc radius 100") == 1 then
        return
    end

    bard.resumeMelody()

    if mq.TLO.Me.CombatState() == "COMBAT" then
        -- print("skip buffing, i am in combat!")
        return
    end

    --print("buff tick. refresh_buffs:", botSettings.toggles.refresh_buffs, ", expired:", refreshBuffsTimer:expired(), ", still:", not mq.TLO.Me.Moving(), ", visible:", not mq.TLO.Me.Invis()  )
    if botSettings.toggles.refresh_buffs and refreshBuffsTimer:expired() and not is_moving() and not mq.TLO.Me.Invis() then
        if not buffs.RefreshSelfBuffs() then
            if not buffs.RefreshAura() then
                if not pet.Summon() then
                    if not pet.BuffMyPet() then
                        -- XXX temp disabled bot buffs because its super slow due to dannet queries. rewrite to have bots request buffs in a channel instead.
                        -- XXX orchestrator will decide what toon will cast the requested buff in the end (?)
                        ------buffs.RefreshBotBuffs() -- XXX slow due to dannet queries!
                    end
                end
            end
        end
        refreshBuffsTimer:restart()
    end
end

-- returns true if a buff was casted
function Buffs.RefreshSelfBuffs()
    if botSettings.settings.self_buffs == nil then
        return false
    end
    for k, buffItem in pairs(botSettings.settings.self_buffs) do
        mq.doevents()
        if refreshBuff(buffItem, mq.TLO.Me) then
            -- end after first successful buff
            return true
        end
    end
    return false
end

-- returns true if spell was cast
--[[
function Buffs.RefreshBotBuffs()

    if botSettings.settings.bot_buffs == nil then
        return
    end

    --print("Buffs.RefreshBotBuffs")

    for buff, names in pairs(botSettings.settings.bot_buffs) do
        --print("xxx ",buff)

        local spellConfig = parseSpellLine(buff) -- XXX cache, dont do this all the time!

        local spell = getSpellFromBuff(spellConfig.Name) -- XXX parse this once on script startup too, dont evaluate all the time !
        if spell == nil then
            mq.cmd.dgtell("Buffs.RefreshBotBuffs: getSpellFromBuff ", buff, " FAILED")
            mq.cmd.beep(1)
            return false
        end

        for k, bot in pairs(names) do
            if refreshBuff(buff, bot) then
                return true
            end
        end
    end

    return false
end
]]--

-- returns true if a buff was casted
function Buffs.RefreshAura()
    if Buffs.aura == nil or mq.TLO.Me.Aura(1)() ~= nil then
        return false
    end
    castSpell(Buffs.aura, mq.TLO.Me.ID())
    return true
end

return Buffs

