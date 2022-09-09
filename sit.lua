-- pl macro: auto sit if mobs nearby

require("ezmq")

print("sit.lua - pl started.")

local npcQuery = "npc radius 40 zradius 50"

while true do

    if mq.TLO.Me.Standing() and not is_casting() and spawn_count(npcQuery) > 0 and spawn_count("pc radius 5 zradius 50") > 1 and mq.TLO.Me.PctHPs() >= 50 then
        -- print("sitting")
        mq.cmd.sit()
        mq.delay(200)
    end

    if is_sitting() and not mq.TLO.Window("SpellBookWnd").Open() and spawn_count(npcQuery) == 0 then
        if mq.TLO.Me.MaxMana()  == 0 or (mq.TLO.Me.MaxMana() > 0 and mq.TLO.Me.PctMana() == 100) then
            print("standing")
            mq.cmd.stand()
            mq.delay(200)
        end
    end

    mq.delay(1)
    mq.doevents()

    if in_neutral_zone() then
        mq.cmd.dgtell("all ERROR: Ending sit.lua in neutral zone")
        os.exit()
    end

end
