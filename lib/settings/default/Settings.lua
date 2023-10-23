-- global settings

-- TODO read server override from config/efyran/SERVER_Settings.lua file, if it exists

local globalSettings = {
    ---@type string valid options are MQ2Nav, MQ2AdvPath
    followMode = "MQ2Nav",
    --followMode = "MQ2AdvPath",

    allowStrangers = true, -- auto accept rez & raid invites from non-peers

    allowBotTells = true, -- allow sending & receiing of "bot tells" such as "Wait4Rez"
}

return globalSettings
