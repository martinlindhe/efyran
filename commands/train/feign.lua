

local mq = require("mq")

local log = require("knightlinc/Write")

-- train Feign Death and Mend for monk - fd and stands up for skill ups
return function()

    local skill = "Feign Death"
    if skill_cap(skill) == 0 then
        log.Info("I lack skill %s, ending training", skill)
        return
    end

    log.Info("Training %s %d / %d ...", skill, skill_value(skill), skill_cap(skill))

    if not is_standing() then
        mq.cmd("/stand")
        mq.delay(50)
    end

    while true do
        if skill_value(skill) >= skill_cap(skill) then
            log.Info("Skill %s capped!", skill)
            break
        end

        if not is_standing() then
            mq.cmd("/stand")
            mq.delay(50)
        end

        if is_standing() and is_ability_ready("Mend") and skill_value("Mend") < skill_cap("Mend") then
            mq.cmd('/doability "Mend"')
            log.Info("Mending %d / %d", skill_value("Mend"), skill_cap("Mend"))
            mq.delay(200)
        end

        if is_ability_ready(skill) then
            mq.cmd('/doability "Feign Death"')
            log.Info("Feigning %d / %d", skill_value(skill), skill_cap(skill))
            mq.delay(200)
        end

        mq.doevents()
    end

end
