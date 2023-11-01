-- Sneak skill cap at 70: ROG 200, MNK 113, RNG 75, BRD 75, Halflings 50
-- Hide  skill cap at 70: ROG 200, SHD 75, RNG 75, BRD 40
-- Sense Traps cap at 70: ROG 200, BRD 75

local mq = require("mq")

local log = require("knightlinc/Write")

return function()
    log.Info("Hide, Sneak and Sense Traps trainer started")

    local count = 0
    local maxTries = 800

    log.Info("Sneak: %d / %d", skill_value("Sneak"), skill_cap("Sneak"))

    if (is_shd() or is_rng() or is_brd() or is_rog()) then
        log.Info("Hide: %d / %d", skill_value("Hide"), skill_cap("Hide"))
        if skill_value("Hide") == 0 then
            all_tellf("ERROR: Need to learn Hide")
        end
    end

    if is_rog() or is_brd() then
        log.Info("Sense Traps: %d / %d", skill_value("Sense Traps"), skill_cap("Sense Traps"))
        if skill_value("Sense Traps") == 0 then
            all_tellf("ERROR: Need to learn Sense Traps")
        end
    end

    local train = false
    if skill_value("Hide") > 0 and skill_value("Hide") < skill_cap("Hide") then
        train = true
    end
    if skill_value("Sneak") > 0 and skill_value("Sneak") < skill_cap("Sneak") then
        train = true
    end
    if skill_value("Sense Traps") > 0 and skill_value("Sense Traps") < skill_cap("Sense Traps") then
        train = true
    end

    while train do
        if is_ability_ready("Hide") and not is_casting() and not obstructive_window_open()
        and skill_value("Hide") > 0 and skill_value("Hide") < skill_cap("Hide") then
            count = count + 1
            log.Info("Training Hide %d/%d (try %d)", skill_value("Hide"), skill_cap("Hide"), count)
            mq.cmd('/doability "Hide"')
            mq.delay(20)
            mq.cmd('/doability "Hide"')
        end
        if is_ability_ready("Sneak") and not is_casting() and not obstructive_window_open()
        and skill_value("Sneak") > 0 and skill_value("Sneak") < skill_cap("Sneak") then
            count = count + 1
            log.Info("Training Sneak %d/%d (try %d)", skill_value("Sneak"), skill_cap("Sneak"), count)
            mq.cmd('/doability "Sneak"')
            mq.delay(20)
            mq.cmd('/doability "Sneak"')
        end
        if is_ability_ready("Sense Traps") and not is_casting() and not obstructive_window_open()
        and skill_value("Sense Traps") > 0 and skill_value("Sense Traps") < skill_cap("Sense Traps") then
            count = count + 1
            log.Info("Training Sense Traps %d/%d (try %d)", skill_value("Sense Traps"), skill_cap("Sense Traps"), count)
            mq.cmd('/doability "Sense Traps"')
        end
        if count >= maxTries then
            break
        end
        mq.doevents()
        mq.delay(50)

        if mq.TLO.Me.Sneaking() and have_ability("Sneak") then
            mq.cmd('/doability "Sneak"')
            mq.delay(20)
        end
        if is_invisible() and have_ability("Hide") then
            mq.cmd('/doability "Hide"')
            mq.delay(20)
        end
    end

    log.Info("Finished training")
end
