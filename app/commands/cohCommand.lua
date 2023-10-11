local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local commandQueue = require('app/commandQueue')

-- Makes mage summon their group with Call of the Hero spell/AA
local function execute()
    local cothMinDistance = 150

    if mq.TLO.Me.Class.Name() ~= "Magician" then
        all_tellf("\arERROR: I am not a Magician, so I cannot Call of the Hero")
        return
    end

    if not in_group() then
        all_tellf("\arERROR: I am not grouped for Call of the Hero")
        return
    end

    while true do
        local done = true

        if mq.TLO.Me.PctMana() < 25 and not is_casting() then
            log.Info("Medding (CoTH loop) ...")
            cmd("/sit on")
        end

        if not is_memorized("Call of the Hero") then
            log.Info("Memorizing Call of the Hero")
            -- NOTE: we avoid using temporary gem "5" on purpose, so autobuff won't unmemorize CoTH and cause another cooldown
            cmd("/memorize 1771 8")
        end

        for n = 1, 5 do
            local spawn = mq.TLO.Group.Member(n)
            if spawn() ~= nil and not spawn.OtherZone() and spawn.Distance() > cothMinDistance and mq.TLO.Me.PctMana() >= 25 then
                done = false

                if inventory_item_count("Pearl") == 0 then
                    all_tellf("\arERROR: I am out of Pearls! I need to be re-stocked before I can cast Call of the Hero.")
                    return
                end

                log.Info("Want to coh group member %d %s, distance %f", n,  spawn.Name(), spawn.Distance())
                if is_alt_ability_ready("Call of the Hero") then
                    all_tellf("CoTH >>\ag%s\ax<< (AA) ...", spawn.Name())
                    cmdf('/casting "Call of the Hero|alt" -targetid|%d', spawn.ID())
                elseif is_spell_ready("Call of the Hero") then
                    all_tellf("CoTH >>\ag%s\ax<< (spell) ...", spawn.Name())
                    cmdf('/casting "Call of the Hero" -targetid|%d', spawn.ID())
                end

                doevents()
                delay(2000)
                delay(20000, function() return not is_casting() end)
            end
        end

        if done then
            all_tellf("\ayGROUP COTH DONE")
            return
        end

        doevents()
        delay(1)
    end

end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

    -- MAG: use Call of the Hero to summon the group to you
mq.bind("/cohgroup", createCommand)
