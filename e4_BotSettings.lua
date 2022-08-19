local file = require('e4_File')

-- FIXME: relative path...
local settingsRoot = "D:/dev-mq/mqnext-e4-lua/settings"

local BotSettings = {
    ["toggles"] = {
        ["refresh_buffs"] = true,   -- /buffon, /buffoff
    },
}



function BotSettings.Init()
    local id = mq.TLO.MacroQuest.Server() .. "_" .. mq.TLO.Me.Class.ShortName() .. "_" .. mq.TLO.Me.Name()
    local settingsFile = settingsRoot .. "/" .. id .. ".lua"
    local settings = loadfile(settingsFile)()
    if settings ~= nil then
        BotSettings.settings = settings
        print("Bot settings loaded for ", id)
    else
        -- give up. no settings file found
        mq.cmd.dgtell("File not found: ", settingsFile)
        mq.cmd.beep(1)
        return
    end
end

return BotSettings
