-- train_tracking.lua by gimp

require("ezmq")

print("train_tracking.lua started")

local trackCount = 0
local maxTries = 800

if not is_ability_ready("Tracking") then
    mq.cmd.dgtell("all ERROR: Do not have Tracking. Cannot train.")
    return
end


while true do

    if mq.TLO.Me.Skill("Tracking")() >= mq.TLO.Skill("Tracking").SkillCap() then
        mq.cmd.dgtell("skillup", "Tracking capped")
        mq.cmd.beep(1)
        break
    end

    --print("1 ", is_ability_ready("Tracking"), "  ",  mq.TLO.Corpse.Open(), not (mq.TLO.Target.Type() == "Corpse"))

    if is_ability_ready("Tracking") and not mq.TLO.Corpse.Open() and not (mq.TLO.Target.Type() == "Corpse") then

        if not is_casting() or is_brd() then
            trackCount = trackCount + 1
            mq.delay(3)
            print("Tracking ", trackCount, " of ", maxTries, ", level ", mq.TLO.Me.Skill("Tracking"), "/", mq.TLO.Skill("Tracking").SkillCap())
            mq.cmd('/doability "Tracking"')
            if trackCount >= maxTries then
                print("Reached max amount. Ending")
                break
            end
        end

    end

    mq.delay(1)
    mq.doevents()

end