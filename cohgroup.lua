-- Tell mage to summon their group with Call of the Hero

local mq = require("mq")
local log = require("knightlinc/Write")
require("ezmq")

local cothMinDistance = 50

if mq.TLO.Me.Class.Name() ~= "Magician" then
    all_tellf("ERROR: I am not a Magician, so I cannot Call of the Hero")
    return
end

if not is_memorized("Call of the Hero") then
    log.Info("Memorizing Call of the Hero")
    cmd("/memorize 1771 5")
end

if not in_group() then
    all_tellf("CoTH ERROR: I am not grouped")
    return
end

while true do

    local done = true

    for n = 1, 5 do
        local spawn = mq.TLO.Group.Member(n)
        if spawn() ~= nil and not spawn.OtherZone() and spawn.Distance() > cothMinDistance then
            done = false

            if getItemCountExact("Pearl") == 0 then
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