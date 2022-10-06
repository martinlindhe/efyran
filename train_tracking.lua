-- train_tracking.lua by gimp

require("ezmq")

print("train_tracking.lua started")

local trackCount = 0
local maxTries = 800

if not is_ability_ready("Tracking") then
    all_tellf("ERROR: Do not have Tracking. Cannot train.")
    return
end


while true do

    if skill_value("Tracking") >= skill_cap("Tracking") then
        cmd("/dgtell skillup Tracking capped")
        break
    end

    --print("1 ", is_ability_ready("Tracking"), "  ",  mq.TLO.Corpse.Open(), not (mq.TLO.Target.Type() == "Corpse"))

    if is_ability_ready("Tracking") and not mq.TLO.Corpse.Open() and mq.TLO.Target.Type() ~= "Corpse" then

        if not is_casting() or is_brd() then
            trackCount = trackCount + 1
            delay(3)
            print("Tracking ", trackCount, " of ", maxTries, ", level ", skill_value("Tracking"), "/",skill_cap("Tracking"))
            cmd('/doability "Tracking"')
            if trackCount >= maxTries then
                print("Reached max amount. Ending")
                break
            end
        end

    end

    delay(1)
    doevents()

end