local mq = require("mq")

local log = require("knightlinc/Write")

-- Train Begging and Pick Pockets on a nearby pet
-- WHY:
-- * Need Begging 151+ for GoD BiC quest
-- * Need Pick Pockets for ROG epic
return function()
    log.Info("Begging training started")

    local trackCount = 0
    local maxTries = 800

    if not have_ability("Begging") then
        all_tellf("ERROR: Do not have Begging. Cannot train.")
        return
    end

    if skill_value("Begging") >= skill_cap("Begging") then
        log.Info("Begging skill capped. Will not train.")
        return
    end

    if spawn_count("pet radius 50") == 0 then
        all_tellf("No pet nearby. Giving up Train Begging")
        return
    end

    if is_sitting() then
        mq.cmd("/stand")
    end

    mq.cmd("/squelch /target clear")

    while true do
        if not have_target() or mq.TLO.Target.Type() ~= "Pet" then
            mq.cmd("/target pet")
            mq.delay("1s")
            move_to(mq.TLO.Target.ID())
        end

        if skill_value("Begging") >= skill_cap("Begging") then
            all_tellf("Begging capped, level %d/%d", skill_value("Begging"), skill_cap("Begging"))
            break
        end

        if is_ability_ready("Begging") and not obstructive_window_open() then
            if not is_casting() or is_brd() then
                trackCount = trackCount + 1
                print("Begging ", trackCount, " of ", maxTries, ", level ", skill_value("Begging"), "/",skill_cap("Begging"))
                mq.cmd('/doability "Begging"')
                mq.delay(10)
                if trackCount >= maxTries then
                    print("Reached max amount. Ending")
                    break
                end
            end
        end
        if is_ability_ready("Pick Pockets") and skill_value("Pick Pockets") < skill_cap("Pick Pockets") then
            log.Info("Pick Pockets %d / %d", skill_value("Pick Pockets"), skill_cap("Pick Pockets"))
            mq.cmd('/doability "Pick Pockets"')
            mq.delay(10)
        end

        mq.delay(1)
        mq.doevents()
    end
end
