-- Tell mage to summon their group with Call of the Hero

local mq = require("mq")
local log = require("efyran/knightlinc/Write")
require("efyran/ezmq")

local cothMinDistance = 50

if mq.TLO.Me.Class.Name() ~= "Magician" then
    all_tellf("ERROR: I am not a Magician, so I cannot Call of the Hero")
    return
end

if not in_group() then
    all_tellf("CoTH ERROR: I am not grouped")
    return
end

while true do

    local done = true

    if mq.TLO.Me.PctMana() < 25 and not is_casting() then
        log.Info("Medding ...")
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
                all_tellf("I am out of Pearls! I need to be re-stocked before I can cast Call of the Hero.")
                return
            end

            log.Info("Want to coh group member %d %s, distance %f", n,  spawn.Name(), spawn.Distance())
            if is_alt_ability_ready("Call of the Hero") then
                all_tellf("CoTH:ing (AA) \ag%s\ax ...", spawn.Name())
                cmdf('/casting "Call of the Hero|alt" -targetid|%d', spawn.ID())
            elseif is_spell_ready("Call of the Hero") then
                all_tellf("CoTH:ing (spell) \ag%s\ax ...", spawn.Name())
                cmdf('/casting "Call of the Hero|gem5" -targetid|%d', spawn.ID())
            end

            doevents()
            delay(2000)
            delay(20000, function() return not is_casting() end)
        end
    end

    if done then
        all_tellf("GROUP COTH DONE")
        return
    end

    doevents()
    delay(1)

end
