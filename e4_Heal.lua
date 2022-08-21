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
            handleHealmeRequest(msg)
        end
    end)
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
    local spawn = mq.TLO.Spawn("pc =" .. peer)
    if tostring(spawn) == "NULL" then
        mq.cmd.dgtell("all peer not in zone, ignoring heal request ", peer)
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
        print("added ", peer, " to heal queue")
    end

    print("current heal queue:")
    tprint(Heal.queue)
end

local askForHealTimer = utils.Timer.new_expired(5 * 1) -- 5s

function Heal.Tick()

    if mq.TLO.Me.PctHPs() <= 98 and askForHealTimer:expired() then
        -- ask for heals if i take damage
        local s = mq.TLO.Me.Name().." "..mq.TLO.Me.PctHPs() -- "Avicii 82"
        print("HELP HEAL ME, ", s)
        mq.cmd.dgtell(Heal.CurrentHealChannel(), s)
        askForHealTimer:restart()
    end

    -- check if heals need to be casted
    if Heal.queue:size() > 0 then
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
        if  botSettings.settings.healing.all_heal ~= nil then
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

end


-- uses healing.tank_heal, returns true if spell was cast
function healPeer(spell_list, peer, pct)
    
    print("Heal: ", peer, " is in my queue, at ", pct, " want heal!!!")

    for k, heal in pairs(spell_list) do

        local spawnID = spawnIdFromCharacterName(peer)

        local spellConfig = parseSpellLine(heal)

        if spawnID == nil then
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
            print("heal ", peer, " with spell ", spellConfig.SpellName)
            castSpell(spellConfig.SpellName, spawnID)
            Heal.queue:remove(peer)
            return true
        end
    end

    return false
end


-- nil if not found
function spawnIdFromCharacterName(name)
    local id = mq.TLO.Spawn("pc =" .. name).ID()
    if id == 0 then
        return nil
    end
    return id
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