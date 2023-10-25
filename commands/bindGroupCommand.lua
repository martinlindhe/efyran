local mq = require("mq")
local commandQueue = require("lib/CommandQueue")

local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()
local log = require("knightlinc/Write")

local boundSuccess = false

mq.event("bound-to-area", "#1# is bound to the area.", function(line, name)
    boundSuccess = true
    log.Info("SUCCESS: \ag%s\ax is bound", name)
end)

-- binds all group members using Bind Affinity
local function bind_group()
    log.Info("/bindgroup started")

    local spellName = "Bind Affinity"
    local gem = 5 -- avoid the temporary slot

    if not have_spell(spellName) then
        log.Error("Cannot bind group, I do not have the spell [+r+]%s[+x+]", spellName)
        return
    end

    if is_sitting() then
        cmd("/stand")
    end

    mq.cmdf('/memorize "%s" %d', spellName, gem)

    local spell = mq.TLO.Spell(spellName)

    for i = 1, mq.TLO.Group.Members() do
        mq.doevents()

        if mq.TLO.Group.Member(i).Distance() < 100 then
            mq.delay("30s", function() return is_spell_ready(spellName) end)
            if not is_spell_ready(spellName) then
                all_tellf("UNLIKELY: /bindgroup spell never got ready, aborting")
                cmd("/beep 1")
                return
            end

            if mq.TLO.Me.CurrentMana() < spell.Mana() + 50 then
                if is_standing() then
                    log.Info("/bindgroup: medding for %s", spellName)
                    cmd("/sit")
                end
                mq.delay("300s", function() return mq.TLO.Me.CurrentMana() > spell.Mana() + 50 end)
            end

            log.Info("Binding group member %d \ag%s\ax ...", i, mq.TLO.Group.Member(i).Name())
            castSpell(spellName, mq.TLO.Group.Member(i).ID())
            mq.delay(spell.MyCastTime())
            mq.doevents()
        else
            all_tellf("ERROR: cant bind %s, out of range!", mq.TLO.Group.Member(i).Name())
        end
    end

    log.Info("Group bound, binding self ...")
    mq.doevents()
    castSpell(spellName, mq.TLO.Me.ID())
    mq.doevents()
    all_tellf("/bindgroup DONE")
end


local function execute()
    bind_group()
end

local function createCommand(distance)
    commandQueue.Enqueue(function() execute() end)
end

bind("/bindgroup", createCommand)
