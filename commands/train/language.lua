-- based on langtrain.mac by Cr4zyb4rd

local mq = require("mq")
local log = require("knightlinc/Write")

require("ezmq")

local maxAttempts = 100 + 10 -- Skill cap is 100

return function()
    if not in_group() then
        log.Error("To train language, first group up!")
        return
    end

    cmdf("/target %s", mq.TLO.Group.Member(1)())

    local maxLanguageID = 25
    if current_server() == "FVP" then
        maxLanguageID = 24 -- 25 "Vah Shir" was added with Luclin
    end

    for i = 1, maxLanguageID do
        local attempts = maxAttempts - mq.TLO.Me.LanguageSkill(i)()

        all_tellf("Training language %s (id %d, skill %d) for %d attempts ...", mq.TLO.Me.Language(i)(), i, mq.TLO.Me.LanguageSkill(i)(), attempts)
        cmdf("/language %d", i)
        delay(10)

        for inner = 0, attempts do
            random_delay(500)
            cmd("/keypress enter chat")
            cmd("/keypress /")
            cmd("/keypress g chat")
            cmd("/keypress s chat")
            cmd("/keypress a chat")
            cmd("/keypress y chat")
            cmd("/keypress space chat")
            cmd("/keypress N chat")
            cmd("/keypress o chat")
            cmd("/keypress w chat")
            cmd("/keypress space chat")
            cmd("/keypress l chat")
            cmd("/keypress e chat")
            cmd("/keypress a chat")
            cmd("/keypress r chat")
            cmd("/keypress n chat")
            cmd("/keypress enter chat")

            delay(4)
            cmd("/keypress enter chat")
            cmd("/keypress /")
            cmd("/keypress g chat")
            cmd("/keypress s chat")
            cmd("/keypress a chat")
            cmd("/keypress y chat")
            cmd("/keypress space chat")
            cmd("/keypress v chat")
            cmd("/keypress e chat")
            cmd("/keypress r chat")
            cmd("/keypress y chat")
            cmd("/keypress space chat")
            cmd("/keypress s chat")
            cmd("/keypress p chat")
            cmd("/keypress e chat")
            cmd("/keypress c chat")
            cmd("/keypress i chat")
            cmd("/keypress a chat")
            cmd("/keypress l chat")
            cmd("/keypress enter chat")
            delay(4)
            mq.doevents()
        end
    end

    -- restore to Common Tongue
    cmdf("/language 1")
end
