-- pl macro: auto sit if mobs nearby

require("ezmq")
local log = require("knightlinc/Write")

print("sit.lua - pl started.")

local npcQuery = "npc radius 40 zradius 50"

while true do

    if mq.TLO.Me.Standing() and not is_casting() and spawn_count(npcQuery) > 0 and spawn_count("pc radius 5 zradius 50") > 1 and mq.TLO.Me.PctHPs() >= 50 then
        -- log.Info("Sitting")
        cmd("/sit")
        delay(200)
    end

    if is_sitting() and not window_open("SpellBookWnd") and spawn_count(npcQuery) == 0 then
        if mq.TLO.Me.MaxMana()  == 0 or (mq.TLO.Me.MaxMana() > 0 and mq.TLO.Me.PctMana() == 100) then
            log.Info("Standing")
            cmd("/stand")
            delay(200)
        end
    end

    delay(1)
    doevents()

    if in_neutral_zone() then
        all_tellf("ERROR: Ending sit.lua in neutral zone")
        os.exit()
    end

end
