-- Tell mage to summon their group with Call of the Hero

require("ezmq")

local cothMinDistance = 50

if mq.TLO.Me.Class.Name() ~= "Magician" then
    mq.cmd.dgtell("all ERROR: I am not a Magician, so I cannot Call of the Hero")
    return
end

if mq.TLO.Me.Gem("Call of the Hero")() == nil then
    print("Memorizing Call of the Hero")
    mq.cmd("/memorize 1771 5")
end

if mq.TLO.Group.Members() == 0 then
    mq.cmd.dgtell("all CoTH ERROR: I am not grouped")
    return
end

while true do

    local done = true

    for n = 1, 5 do
        local spawn = mq.TLO.Group.Member(n)
        if spawn() ~= nil and not spawn.OtherZone() and spawn.Distance() > cothMinDistance then
            done = false

            if getItemCountExact("Pearl") == 0 then
                mq.cmd.dgtell("all I am out of Pearls! I need to be re-stocked before I can cast Call of the Hero.")
                return
            end

            print("Want to coh group member ", n , " ", spawn.Name(), " dist ", spawn.Distance() )
            if is_alt_ability_ready("Call of the Hero") then
                mq.cmd.dgtell("all CoTH:ing (AA) \ay", spawn.Name(), "\ax ...")
                mq.cmd('/casting "Call of the Hero|alt" -targetid|'.. tostring(spawn.ID()) .. ' ')
            elseif is_spell_ready("Call of the Hero") then
                mq.cmd.dgtell("all CoTH:ing (spell) \ay", spawn.Name(), "\ax ...")
                mq.cmd('/casting "Call of the Hero|gem5" -targetid|'.. tostring(spawn.ID()) .. ' ')
            end

            --print("Waiting")
            mq.doevents()
            mq.delay(2000)
            mq.delay(20000, function() return not is_casting() end)
            --print("done waiting")
            mq.delay(1000)
        end
    end

    if done then
        mq.cmd.dgtell("all GROUP COTH DONE")
        return
    end

    mq.doevents()
    mq.delay(1)

end