local mq = require("mq")

local log = require("knightlinc/Write")

require("efyran/ezmq")

-- train begging on a nearby pet
-- WHY: need Begging 151+ for GoD BiC quest
return function()
    log.Info("Begging training started")

    local trackCount = 0
    local maxTries = 800

    if not have_ability("Begging") then
        -- TODO: only complain if this class should have Begging.
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

    cmd("/squelch /target clear")

    while true do
        if not has_target() or mq.TLO.Target.Type() ~= "Pet" then
            cmd("/target pet")
            delay("1s")
            move_to(mq.TLO.Target.ID())
        end

        if skill_value("Begging") >= skill_cap("Begging") then
            all_tellf("Begging capped, level %d/%d", skill_value("Begging"), skill_cap("Begging"))
            break
        end

        if is_ability_ready("Begging") and not mq.TLO.Corpse.Open() and mq.TLO.Target.Type() ~= "Begging" then

            if not is_casting() or is_brd() then
                trackCount = trackCount + 1
                delay(3)
                print("Begging ", trackCount, " of ", maxTries, ", level ", skill_value("Begging"), "/",skill_cap("Begging"))
                cmd('/doability "Begging"')
                if trackCount >= maxTries then
                    print("Reached max amount. Ending")
                    break
                end
            end

        end

        delay(1)
        doevents()
    end
end
