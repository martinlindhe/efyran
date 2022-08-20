local file = require('e4_File')

-- FIXME: relative path...
local settingsRoot = "D:/dev-mq/mqnext-e4-lua/settings"

local BotSettings = {
    ["healme_channel"] = "", -- healme channel for current zone
    ["toggles"] = {
        ["refresh_buffs"] = true,   -- /buffon, /buffoff
    },
}



function BotSettings.Init()
    local id = mq.TLO.MacroQuest.Server() .. "_" .. mq.TLO.Me.Class.ShortName() .. "_" .. mq.TLO.Me.Name()
    local settingsFile = settingsRoot .. "/" .. id .. ".lua"
    print("reading peer ", mq.TLO.Me.Name(), " settings from ", settingsFile)
    -- XXX dont crash if file not found !
    print(type(loadfile))
    local settings = loadfile(settingsFile)
    if settings ~= nil then
        BotSettings.settings = settings()
        print("Bot settings loaded for ", id)
    else
        -- no settings file found
        mq.cmd.dgtell("FATAL ERROR: File not found: ", settingsFile)
        mq.cmd.beep(1)
        -- GIVE UP, WE ARE IN A BROKEN STATE !
        os.exit()
    end
end

return BotSettings
