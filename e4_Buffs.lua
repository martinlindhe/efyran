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

local MIN_BUFF_DURATION = 1 * 6000 -- 1 tick, each tick is 6s

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

    -- known buffers by class (key = class, val = peer name)
    buffers = {},

    -- others available buff groups (key = peer, val = space separated string of buff groups)
    otherAvailable = {},

    ---@type boolean /buffon, /buffoff
    refreshBuffs = true,

    ---@type integer in seconds
    timeZoned = os.time(),

    -- timers
    resumeTimer = timer.new_expired(2), -- 2s   - interval after end of fight to resume buffing

    requestAvailabiliyTimer = timer.new_random(20), -- 20s  - interval to wait before checking buff availability

    -- clickies
    manaRegenClicky       = nil,
    manaPoolClicky        = nil,
    attackClicky          = nil,

    allResistsClicky      = nil,
    formOfEnduranceClicky = nil,
    formOfDefenseClicky   = nil,
}

function buffs.Init()

    buffs.UpdateClickies()

    -- enqueues a buff to be cast on a peer
    -- is normally called from another peer, to request a buff
    mq.bind("/buff", function(peer, buff, force)
        table.insert(buffs.queue, {
            Peer = peer,
            Buff = buff,
            Force = force == "force",
        })
    end)

    -- INTERNAL: for requesting buff state (is sent from `peer`. We will respond with a /set_others_buffs to `peer`
    mq.bind("/request_buffs", function(peer)
        cmdf("/squelch /bct %s //set_others_buffs %s %s", peer, mq.TLO.Me.Name(), buffs.getAvailableGroupBuffs())
        --log.Debug("Told %s my buffs are %s", peer, buffs.getAvailableGroupBuffs())
    end)
    
    -- INTERNAL: for updating buff state (is sent from `peer` to this instance)
    mq.bind("/set_others_buffs", function(peer, ...)
        local arg = trim(args_string(...))
        buffs.otherAvailable[peer] = arg
        --log.Debug("%s told me their buffs are: %s", peer, arg)
    end)

    mq.bind("/reportclickies", function()
        local s = ""
        if me_caster() or me_priest() then
            if buffs.manaRegenClicky == nil then
                s = s .. "\arMISSING: Mana regen clicky\ax, "
            else
                s = s .. "ManaRegen:" .. buffs.manaRegenClicky .. ", "
            end
            if buffs.manaPoolClicky == nil then
                s = s .. "\arMISSING: Mana pool clicky\ax, "
            else
                s = s .. "ManaPool:" .. buffs.manaPoolClicky .. ", "
            end
        end
        if me_melee() then
            if buffs.attackClicky == nil then
                s = s .. "\arMISSING: Attack clicky\ax, "
            else
                s = s .. "Attack:" .. buffs.attackClicky .. ", "
            end
        end
        if buffs.allResistsClicky == nil then
            s = s .. "\arMISSING: AllResists clicky\ax, "
        else
            s = s .. "AllResists:" .. buffs.allResistsClicky .. ", "
        end
        if s ~= "" then
            all_tellf("REPORT: %s", s)
        end
    end)

    bard.UpdateMQ2MedleyINI()
    bard.resumeMelody()
end

local refreshBuffsTimer = timer.new_expired(10) -- 10s

local requestBuffsTimer = timer.new_random(60 * 1) -- 60s

local handleBuffsTimer = timer.new_random(2 * 1) -- 2s

local checkDebuffsTimer = timer.new_random(15 * 1) -- 15s   -- interval for auto cure requests

local refreshCombatBuffsTimer = timer.new_random(10 * 1) -- 10s

local refreshIllusionTimer = timer.new_random(10 * 1) -- 10s

local refreshAutoClickiesTimer = timer.new(3) -- 3s (duration of a song, so bards wont chain-queue clickies)

---@return string
function buffs.getAvailableGroupBuffs()
    local classBuffGroups = groupBuffs[class_shortname()]
    if classBuffGroups == nil then
        return ""
    end

    local s = ""
    for groupIdx, buffGroup in pairs(classBuffGroups) do
        for rowIdx, row in pairs(buffGroup) do
            local spellConfig = parseSpellLine(row)
            if have_spell(spellConfig.Name) then
                s = s .. " " .. groupIdx
                break
            end
        end
    end
    return trim(s)
end

-- update status of worn clickies
function buffs.UpdateClickies()
    buffs.manaRegenClicky       = FindBestManaRegenClicky()
    buffs.manaPoolClicky        = FindBestManaPoolClicky()
    buffs.attackClicky          = FindBestAttackClicky()

    buffs.allResistsClicky      = FindBestAllResistsClicky()
    buffs.formOfEnduranceClicky = FindBestFormOfEnduranceClicky()
    buffs.formOfDefenseClicky   = FindBestFormOfDefenseClicky()
end

-- announce buff availability, handle debuffs, refresh buffs/auras/pets/pet buffs, request buffs and handle buff requests
function buffs.Tick()

    if is_hovering() or is_moving() or is_invisible() then
        return
    end

    if not is_brd() and is_casting() then
        return
    end

    if is_naked() then
        return
    end

    if checkDebuffsTimer:expired() then
        buffs.HandleDebuffs()
        checkDebuffsTimer:restart()
    end

    if refreshCombatBuffsTimer:expired() then
        buffs.RefreshCombatBuffs()
        refreshCombatBuffsTimer:restart()
    end

    if not buffs.resumeTimer:expired()  then
        --log.Debug("Buff tick: resumeTimer not ready")
        return
    end

    if not is_standing() or not allow_buff_in_zone() then
        return
    end

    if obstructive_window_open() then
        return
    end

    if refreshIllusionTimer:expired() then
        refreshIllusionTimer:restart()
        if buffs.RefreshIllusion() then
            return
        end
    end

    if in_combat() then
        return
    end

    if refreshAutoClickiesTimer:expired() then
        buffs.RefreshAutoClickies()
        refreshAutoClickiesTimer:restart()
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

    if buffs.requestAvailabiliyTimer:expired() then
        buffs.RequestAvailabiliy()
        buffs.requestAvailabiliyTimer:restart()
    end

    if is_casting() or is_hovering() or is_sitting() or is_moving() or mq.TLO.Me.SpellInCooldown() or obstructive_window_open() then
        return
    end

    if #buffs.queue > 0 and not in_combat() and handleBuffsTimer:expired() then
        -- process up  to 10 requests per tick, until at least one is handled.
        for i = 1, 10 do
            local req = table.remove(buffs.queue, 1)
            if req ~= nil then
                if handleBuffRequest(req) then
                    handleBuffsTimer:restart()
                    return
                end
            end
        end
    end

    if follow.IsFollowing() then
        return
    end

    if buffs.refreshBuffs and not in_combat() and requestBuffsTimer:expired() then
        buffs.RequestBuffs()
        requestBuffsTimer:restart()
    end
end

function buffs.RefreshCombatBuffs()
    if botSettings.settings.combat_buffs == nil or not in_combat() or is_stunned() then
        return
    end

    -- Refresh on me (WAR, ROG, BST, MNK, BER)
    -- BER L68 Cry Havoc (id 8003: group 100% melee crit chance. 1 min. works with TGB) DoDH
    -- WAR L68 Commanding Voice (20% dodge to group, 100 range, disc, 200 endurance, 1 min duration) DoDH
    -- ROG L68 Thief's Eyes (+5% hit chance with all skills to group, 1 min, cost 200 endurance) DoDH
    -- MMK L68 Fists of Wu (group: increase double attack by 6%, 1.0 min) DoDH
    for _, buff in pairs(botSettings.settings.combat_buffs) do
        local spellConfig = parseSpellLine(buff)

        if matches_filter(buff, mq.TLO.Me.Name()) and is_spell_ability_ready(spellConfig.Name) then
            local spell = getSpellFromBuff(spellConfig.Name)
            if spell ~= nil then
                local spellName = spell.RankName()
                if have_buff(spellName) or have_song(spellName) then
                    return
                end
                if spell.TargetType() ~= "Self" and spell.TargetType() ~= "Group v1" then
                    all_tellf("XXX RefreshCombatBuffs targetType is %s (%s)", spell.TargetType(), spellName)
                    cmd("/target myself")
                end
                if castSpellAbility(nil, buff) then
                    log.Info("RefreshCombatBuffs refreshed \ay%s\ax (self)", spellName)
                    return
                end
            end

        end
    end

    if not is_dru() and not is_shm() and not is_enc() and not is_bst() and not is_mag() then
        return
    end

    -- XXX is there similar buffs for RNG ? or more classes?

    -- TODO Skin of the Reptile should be castable on a non-grouped peer ...

    -- Refresh on group (DRU, SHM, ENC, BST)
    -- DRU L68 Skin of the Reptile (melee proc heals when hit)
    -- SHM L68 Lingering Sloth (add proc that can slow mobs that hit it, 4 min)
    -- SHM L69 Spirit of the Panther (add proc Panther Maw, rate mod 400, 1 min) DoN
    -- BST L70 Ferocity of Irionu (52 sta, 187 atk, 65 all resists, 6.5 min)
    -- ENC L70 Mana Flare (timer 7, trigger Mana Flare Strike, dmg 700)
    -- MAG L68 Burning Aura (add defensive proc Burning Vengeance, 3 min)
    for i=1,mq.TLO.Group.Members() do
        local dist = mq.TLO.Group.Member(i).Distance()
        local name = mq.TLO.Group.Member(i).Name()
        if dist ~= nil and dist < 100 then

            for key, buff in pairs(botSettings.settings.combat_buffs) do
                local spellConfig = parseSpellLine(buff)

                if matches_filter(buff, name) and is_spell_ability_ready(spellConfig.Name) then
                    local spawn = spawn_from_peer_name(name)
                    if spawn ~= nil and spawn() ~= nil and not peer_has_buff(name, spellConfig.Name) and not peer_has_song(name, spellConfig.Name) and castSpellAbility(spawn.ID(), buff) then
                        all_tellf("COMBAT BUFF \ay%s\ax on \ag%s\ax", spellConfig.Name, name)
                        return
                    end
                end
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

            if matches_filter(spellConfig.Class, mq.TLO.Me.Name()) then

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
                local spawn = spawn_from_peer_name(curer)
                if spawn == nil then
                    all_tellf("UNLIKELY: failed to look up spawn of curer \ar%s\ax", spellConfig.Name)
                    return
                end
                if spawn.Distance() < 200 then
                    all_tellf("Asking \ag%s\ax to cure \ar%s\ax (\ay%s\ax)", curer, spellConfig.Name, spellConfig.Cure)
                    cmdf("/dex %s /cure %s %s", curer, mq.TLO.Me.Name(), spellConfig.Cure)
                else
                    all_tellf("ERROR: Want to ask \ag%s\ax to cure \ar%s\ax (\ay%s\ax). Distance %.2f", curer, spellConfig.Name, spellConfig.Cure, spawn.Distance())
                end

            else
                all_tellf("I have \ar%s\ax but not asking for cure (not %s)", spellConfig.Name, spellConfig.Class)
            end
        end
    end

end

---@param spawnID integer
function buffs.BuffIt(spawnID)

    local available = buffs.getAvailableGroupBuffs()
    if available == nil then
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

    log.Debug("handleBuffRequest: Peer %s, buff \ay%s\ax, queue len \ay%d\ax, force = %s", req.Peer, req.Buff, #buffs.queue, tostring(req.Force))

    local buffRows = groupBuffs[class_shortname()][req.Buff]
    if buffRows == nil then
        all_tellf("ERROR: handleBuffRequest: did not find groupBuffs.%s entry %s", class_shortname(), req.Buff)
        return false
    end

    local spawn = spawn_from_peer_name(req.Peer)
    if spawn == nil then
        -- happens when zoning
        --log.Error("handleBuffRequest: Spawn not found %s", req.Peer)
        return false
    end

    -- find the one with highest MinLevel
    local minLevel = 0
    local spellName = ""

    local level = spawn.Level()
    if level == nil then
        all_tellf("\arFATAL level is nil, from peer %s, buff %s", req.Peer, req.Buff)
    end

    if type(level) ~= "number" then
        all_tellf("\arFATAL level is not a number: %s: %s, from peer %s, buff %s, input %s", type(level), tostring(level), req.Peer, req.Buff, checkRow)
        return false
    end

    wait_until_not_casting()

    -- see if we have any rank of this buff
    for idx, checkRow in pairs(buffRows) do
        -- XXX same logic as /buffit. do refactor

        local spellConfig = parseSpellLine(checkRow)
        local n = tonumber(spellConfig.MinLevel)
        if n == nil then
            all_tellf("FATAL ERROR, group buff %s does not have a MinLevel setting", checkRow)
            return false
        end
        -- XXX debug source of nil
        if type(n) ~= "number" then
            all_tellf("DEBUG: n is not a number, from peer %s, buff %s", req.Peer, req.Buff)
            return false
        end
        if type(n) == "number" and n > minLevel and level >= n then
            spellName = spellConfig.Name
            local spell = get_spell(spellName)
            if spell == nil then
                all_tellf("FATAL ERROR cant lookup %s", spellName)
                return false
            end
            if have_spell(spellName) then
                spellName = spell.RankName()
                --if spell.StacksTarget() then
                    minLevel = n
                    --print("minLevel = ", n)
                --else
                    -- XXX look into: seems spell.StacksTarget() checks vs myself instead of my target... is it a mq2-lua bug ????  cant cast Symbol of Naltron from CLR with higher sytmbol on a naked WAR.
                --    cmd("/bc ERROR cannot buff ", spawn.Name(), " with ", spellName, ", MinLevel ", n, " (dont stack with current buffs)")
                --end
                --log.Debug("Best %s buff so far is MinLevel %d, Name %s, target L%d %s", req.Peer, spellConfig.MinLevel, spellConfig.Name, level, spawn.Name())
            end
        end
    end

    if minLevel > 0 and spellConfigAllowsCasting(spellName, spawn) then
        if not req.Force and peer_has_buff(req.Peer, spellName) then
            log.Info("handleBuffRequest: Skip \ag%s\ax %s (%s), they have buff already.", spawn.Name(), spellName, req.Buff)
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
            if not req.Force and peer_has_buff(req.Peer, spellName) then
                -- abort if they got the buff while we are casting
                log.Info("handleBuffRequest: My target %s has buff %s for %f sec, ducking.", mq.TLO.Target.Name(), spellName, mq.TLO.Target.Buff(spellName).Duration() / 1000)
                cmdf("/interrupt")
                return true
            end
        end)
        return true
    end
    return false
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

-- Only refresh illusion if fading or missing
-- returns true if a buff *with cast time* was casted
function buffs.RefreshIllusion()
    if botSettings.settings.illusions == nil then
        return false
    end

    local illusion = botSettings.GetCurrentIllusion()
    if illusion == nil then
        return false
    end
    return refreshBuff(illusion, mq.TLO.Me)
end

-- refreshes the auto-detected clickies (mana regen, mana pool, attack, resists)
function buffs.RefreshAutoClickies()
    if (me_caster() or me_priest() or me_hybrid()) and refresh_buff_clicky(buffs.manaRegenClicky) then
        return
    end

    if (me_caster() or me_priest() and free_buff_slots() > 1) and refresh_buff_clicky(buffs.manaPoolClicky) then
        return
    end

    if me_melee() and refresh_buff_clicky(buffs.attackClicky) then
        return
    end

    if not capped_resists() and not in_raid() and refresh_buff_clicky(buffs.allResistsClicky) then
        return
    end
end

local shortToLongClass = {
    CLR = "Cleric",
    DRU = "Druid",
    SHM = "Shaman",
    WAR = "Warrior",
    PAL = "Paladin",
    SHD = "Shadow Knight",
    BRD = "Bard",
    ROG = "Rogue",
    BER = "Berserker",
    MNK = "Monk",
    RNG = "Ranger",
    BST = "Beastlord",
    WIZ = "Wizard",
    MAG = "Magician",
    ENC = "Enchanter",
    NEC = "Necromancer",
}

local buffClasses = { "CLR", "DRU", "SHM", "PAL", "RNG", "BST", "MAG", "ENC", "NEC" }

-- queries other peers for their available buffs by class using /request_buffs
function buffs.RequestAvailabiliy()

    for i = 1, #buffClasses do
        if class_shortname() ~= buffClasses[i] then
            local found = false

            if buffs.buffers[buffClasses[i]] == nil or not is_peer_in_zone(buffs.buffers[buffClasses[i]]) then
                -- 1. find peer of needed class in my group
                for j = 1, mq.TLO.Group.Members() do
                    if mq.TLO.Group.Member(j).ID() ~= nil and mq.TLO.Group.Member(j).Class.ShortName() == buffClasses[i] then
                        if is_peer(mq.TLO.Group.Member(j).Name()) then
                            --log.Debug("found class buffer in group: %s %s", buffClasses[i], mq.TLO.Group.Member(j).Name())
                            buffs.buffers[buffClasses[i]] = mq.TLO.Group.Member(j).Name()
                            found = true
                            break
                        end
                    end
                end

                -- 2. find any peer
                if not found then
                    local spawnQuery = "pc notid " .. mq.TLO.Me.ID() .. ' class "'.. shortToLongClass[buffClasses[i]] ..'"'
                    for j = 1, spawn_count(spawnQuery) do
                        local spawn = mq.TLO.NearestSpawn(j, spawnQuery)
                        if spawn ~= nil and is_peer(spawn.Name()) then
                            log.Debug("found class buffer nearby: %s %s, peer id = %s", buffClasses[i], spawn.Name(), tostring(mq.TLO.NetBots(spawn.Name()).ID()))
                            buffs.buffers[buffClasses[i]] = spawn.Name()
                            found = true
                            break
                        end
                    end
                end
            end

            if found then
                -- request available buffs from them
                log.Info("Found buffer %s \ag%s\ax", buffClasses[i], buffs.buffers[buffClasses[i]])
                cmdf("/squelch /bct %s //request_buffs %s", buffs.buffers[buffClasses[i]], mq.TLO.Me.Name())
            end

        end
    end
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

    local availableClasses = find_available_classes() -- XXX list should be known locally already

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

        if spellConfig.CheckFor ~= nil then
            local tokens = split_str(spellConfig.CheckFor, ",")
            for key, value in pairs(tokens) do
                if have_buff(value) then
                    log.Debug("RequestBuffs CheckFor \ag%s\ax found, skipping", value)
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
                        cmdf("/squelch /bct %s //buff %s %s", peer, mq.TLO.Me.Name(), spellConfig.Name)
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
        if availableGroups:find(buffGroup) and is_peer_in_zone(peer) then
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

