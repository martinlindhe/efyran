require('e4_Spells')

queue = require('Queue')

local Heal = {
    queue = queue.new(), -- holds toons that requested a heal
}

-- returns the name of the heal channel for the current zone
function Heal.CurrentHealChannel()
    return string.lower(mq.TLO.MacroQuest.Server() .. "_" .. mq.TLO.Zone.ShortName() .. "_healme")
end

function Heal.Init()
    mq.event("dannet_chat", "[ #1# (#2#) ] #3#", function(text, peer, channel, msg)
        --print("-- dannet_chat: chan ", channel, " msg: ", msg)

        if me_healer() and channel == Heal.CurrentHealChannel() and botSettings.settings.healing ~= nil then
            if string.sub(msg, 1, 1) ~= "/" then
                -- XXX ignore text starting with a  "/"
                handleHealmeRequest(msg)
            end
        end
    end)

    mq.event("zoned", "You have entered #1#.", function(text, zone)
        if zone ~= "an area where levitation effects do not function" then
            print("I zoned into ", zone)
            mq.delay(2000)
            pet.ConfigureTaunt()

            joinCurrentHealChannel()
            memorizeListedSpells()
        end
    end)

    mq.bind("/rezit", function(spawnID)
        print("rezit", spawnID)

        if is_orchestrator() then
            if not has_target() then
                print("/rezit ERROR: No corpse targeted.")
                return
            end
            local spawn = target()
            spawnID = tostring(spawn.ID())
            if spawn.Type() ~= "Corpse" then
                print("/rezit ERROR: Target is not a corpse (type ", spawn.Type(), ")")
                return
            end

            print("Requesting rez for ", spawn.Name())
            mq.cmd.dgexecute(heal.CurrentHealChannel(), "/rezit "..spawn.ID())
        end

        if botSettings.settings.healing == nil or botSettings.settings.healing.rez == nil then
            return
        end

        -- perform rez
        local spawn = spawn_from_id(spawnID)
        if spawn == nil then
            -- unlikely
            mq.cmd.dgtell("all ERROR: tried to rez spawnid ", spawnID, " which is not found in zone")
            mq.cmd.beep(1)
            return
        end
        print("Performing rez on ", spawnID, " ", type(spawnID), " ", spawn.Name)

        -- find first rez that is ready to use
        for k, rez in pairs(botSettings.settings.healing.rez) do
            -- TODO: chose the best spell for the moment. auto code spells. now we just pick the 1st.
            mq.cmd.dgtell("all Rezzing", spawn.Name, "with", rez)
            castSpell(rez, spawn.ID())
            break
        end

    end)

    joinCurrentHealChannel()
    memorizeListedSpells()
end


-- return true if peer has a target
function has_target()
    return mq.TLO.Target() ~= nil
end

-- return the current target spawn, or nil
function target()
    if not has_target() then
        return nil
    end
    return mq.TLO.Target
end

-- joins/changes to the heal channel for current zone
function joinCurrentHealChannel()
    -- orchestrator only joins to watch the numbers
    local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"

    if orchestrator or me_healer() then
        if heal.CurrentHealChannel() == botSettings.healme_channel then
            return
        end

        if botSettings.healme_channel ~= "" then
            mq.cmd.dleave(botSettings.healme_channel)
        end

        botSettings.healme_channel = heal.CurrentHealChannel()
        mq.cmd.djoin(botSettings.healme_channel) -- new zone
    end
end

local healQueueMaxLength = 10

function parseHealmeRequest(s)
    local name = ""
    local pct = 0
    local i = 1
    for sub in s:gmatch("%S+") do
        if i == 1 then
            name = sub
        else
            pct = tonumber(sub)
        end
        i = i + 1
    end
    return name, pct
end

-- msg is "Avicii 75" (Name/PctHP)
function handleHealmeRequest(msg)

    local peer, pct = parseHealmeRequest(msg)
    print("heal peer ", peer," pct ", pct)

    -- ignore if not in zone
    local spawn = spawn_from_peer_name(peer)
    if tostring(spawn) == "NULL" then
        mq.cmd.dgtell("all Peer is not in zone, ignoring heal request from '"..peer.."'")
        return
    end

    -- if queue don't already contain this bot
    if not Heal.queue:contains(peer) then
        -- if queue is less than 10 requests, always add it
        if table.getn(Heal.queue) >= healQueueMaxLength then
            -- XXX: if queue is >= 10 long, always add if listed as tank or important bot
            -- XXX: if queue is >= 10 long, add with 50% chance ... if >= 20 long, beep and ignore.

            mq.cmd.dgtell("all queue is full ! len is ", table.getn(Heal.queue), ". queue: ", Heal.queue)
            mq.cmd.beep(1)
            return
        end

        Heal.queue:add(peer, pct)
        --print("added ", peer, " to heal queue")
    end

    --print("current heal queue:")
    --tprint(Heal.queue)
end

local askForHealTimer = utils.Timer.new_expired(5 * 1) -- 5s
local askForHealPct = 94 -- at what % HP to start begging for heals

function Heal.Tick()

    if mq.TLO.Me.PctHPs() <= askForHealPct and askForHealTimer:expired() then
        -- ask for heals if i take damage
        local s = mq.TLO.Me.Name().." "..mq.TLO.Me.PctHPs() -- "Avicii 82"
        --print(mq.TLO.Time, "HELP HEAL ME, ", s)
        mq.cmd.dgtell(Heal.CurrentHealChannel(), s)
        askForHealTimer:restart()

        -- life support check is also controlled by the askForHealTimer, every 5s
        Heal.performLifeSupport()
    end

    -- check if heals need to be casted
    if Heal.queue:size() > 0 and botSettings.settings.healing ~= nil then
        print("heal tick. queue is ", Heal.queue:size(), ": ", Heal.queue:describe())

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
                print("healing ", peer.name, " at pct ", pct)
                if healPeer(botSettings.settings.healing.all_heal, peer, pct) then
                    return
                end
            end
        end
    end

    Heal.acceptRez()

    Heal.medCheck()
end

function Heal.acceptRez()
    if window_open("ConfirmationDialogBox") then
        local s = mq.TLO.Window("ConfirmationDialogBox").Child("CD_TextOutput").Text()
        if string.find(s, "wants to cast") ~= nil then
            -- grab first word from sentence
            local i = 1
            local peer = ""
            for w in s:gmatch("%S+") do
                if i == 1 then
                    name = w
                    break
                end
                i = i + 1
            end

            local spawn = spawn_from_peer_name(peer)
            --print("got a rez from", peer, " ( ", spawn.Name() , ")")
            if not is_peer(spawn) then
                mq.cmd.dgtell("all WARNING: got a rez from (NOT A PEER)", spawn.Name(), ": ", s)
                mq.cmd.beep(1)
                mq.delay(1000) -- XXX
                -- XXX should we decline the rez?
                return
            end
            mq.cmd.dgtell("all Accepting rez from", spawn.Name())
            mq.cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
        end
    end
end

function Heal.medCheck()

    if botSettings.settings.healing ~= nil and botSettings.settings.healing.automed ~= nil and not botSettings.settings.healing.automed then
        --print("wont med. healing.automed is false")
        return
    end

    if is_brd() or is_hovering() or mq.TLO.Window("SpellBookWnd").Open() then
        return
    end

    if mq.TLO.Me.MaxMana() > 0 and not mq.TLO.Me.Moving() then
        if mq.TLO.Me.PctMana() < 70 and mq.TLO.Me.Standing() then
            mq.cmd.dgtell("all Low mana, medding at ", mq.TLO.Me.PctMana().."%")
            mq.cmd.sit("on")
        elseif mq.TLO.Me.PctMana() >= 100 and not mq.TLO.Me.Standing() then
            mq.cmd.dgtell("all Ending medbreak, full mana.")
            mq.cmd.sit("off")
        end
    end
end

-- returns true if we are in hovering state (just died, waiting for rez in the same zone)
function is_hovering()
    return mq.TLO.Me.State() == "HOVER"
end

-- returns true if a window `name` is open
function window_open(name)
    return mq.TLO.Window(name).Open() == true
end

-- tries to defend myself using settings.healing.life_support
function Heal.performLifeSupport()
    --print("Heal.performLifeSupport")

    -- XXX checkfor Resurrection Sickness should be automatic here !!!

    if botSettings.settings.healing == nil or botSettings.settings.healing.life_support == nil then
        mq.cmd.dgtell("all performLifeSupport ERROR I dont have healing.life_support configured. Current HP is "..mq.TLO.Me.PctHPs().."%")
        return
    end

    for k, row in pairs(botSettings.settings.healing.life_support) do
        --print("k ", k, " v ", row)
        local spellConfig = parseSpellLine(row)

        local skip = false
        if spellConfig.HealPct ~= nil and tonumber(spellConfig.HealPct) < mq.TLO.Me.PctHPs() then
            -- remove, dont meet heal criteria
            --print("performLifeSupport skip use of ", spellConfig.Name, ", my hp ", mq.TLO.Me.PctHPs, " vs required ", spellConfig.HealPct)
            skip = true
        end

        if spellConfig.CheckFor ~= nil then
            -- if we got this buff on, then skip.
            if mq.TLO.Me.Buff(spellConfig.CheckFor)() ~= nil then
                mq.cmd.dgtell("all performLifeSupport skip ", spellConfig.Name, ", I have buff ", spellConfig.CheckFor, " on me")
                skip = true
            end
        end

        if not skip then
            mq.cmd.dgtell("all USING LIFE SUPPORT ", spellConfig.Name, " AT ", mq.TLO.Me.PctHPs(), " % HP")
            castSpell(spellConfig.Name, mq.TLO.Me.ID())
        end

    end
end

-- uses healing.tank_heal, returns true if spell was cast
function healPeer(spell_list, peer, pct)
    
    print("Heal: ", peer, " is in my queue, at ", pct, " want heal!!!")

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
            print("removing from heal queue, dont need heal: ", peer)
            Heal.queue:remove(peer)
            return false
        else
            mq.cmd.dgtell("all Healing ", peer, " at ", pct, " % HP with spell ", spellConfig.Name)
            castSpell(spellConfig.Name, spawn.ID())
            Heal.queue:remove(peer)
            return true
        end
    end

    return false
end




function table.contains(table, element)
    for _, value in pairs(table) do
      if value == element then
        return true
      end
    end
    return false
  end
  

return Heal