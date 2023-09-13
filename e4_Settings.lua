-- global settings

-- TODO read server override from settings/PEQTGC_Settings.lua file, if it exists

local globalSettings = {
    ---@type string valid options are MQ2Nav, MQ2AdvPath, MQ2MoveUtils
    -- followMode = "MQ2Nav",
    followMode = "MQ2AdvPath",

    allowStrangers = true, -- auto accept rez & raid invites from non-peers
}

return globalSettings
