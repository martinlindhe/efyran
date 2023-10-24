
-- TODO read server override from config/efyran/SERVER__ServerSettings.lua file, if it exists
local mq = require("mq")
local serverSettingsFile =  mq.TLO.MacroQuest.Path("config")() .. "\\efyran\\" .. mq.TLO.MacroQuest.Server() .. "__Server Settings.lua"
local settings = loadfile(serverSettingsFile)
if settings ~= nil then
    return settings()
end

-- server setting defaults
local serverSettings = {
    ---@type string valid options are MQ2Nav, MQ2AdvPath
    followMode = "MQ2AdvPath",

    allowStrangers = true,  -- auto accept rez & raid invites from non-peers

    allowBotTells = true,   -- allow sending & receiving of "bot tells" such as "Wait4Rez"

    bigBank = true,         -- FVP uses BankWnd
}

return serverSettings
