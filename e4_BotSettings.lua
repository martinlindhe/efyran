local log = require("knightlinc/Write")

-- FIXME: relative path...
local settingsRoot = "D:/dev-mq/mqnext-e4-lua/settings"

---@class PeerSettings
---@field public assist PeerSettingsAssist

---@class PeerSettingsAssist
---@field public type string "melee" or "ranged"
---@field public melee_distance string|integer "auto" or a number

local botSettings = {
    ---@type PeerSettings
    settings = {}
}

-- XXX improve peer template generation
local peerTemplate = [[
local settings = { }

settings.swap = {
    ["main"] = "",
}

settings.self_buffs = {
}

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
}

return settings
]]

---@param settingsFile string
local function read_settings(settingsFile)
    log.Info("Reading peer settings %s", settingsFile)
    return loadfile(settingsFile)
end

function botSettings.Init()
    if is_hovering() then
        all_tellf("ERROR: cannot start e4 successfully while in HOVERING mode")
        cmd("/beep 1")
        return
    end

    local settingsFile = settingsRoot .. "/" .. peer_settings_file()
    local settings = read_settings(settingsFile)
    if settings ~= nil then
        botSettings.settings = settings()
    else
        -- no settings file found
        all_tellf("PEER INI NOT FOUND, CREATING EMPTY ONE. PLEASE EDIT %s", settingsFile)
        cmd("/beep 1")

        local f = assert(io.open(settingsFile, "w"))
        f:write(peerTemplate)
        f:close()

        settings = read_settings(settingsFile)
        botSettings.settings = settings()
    end
end

return botSettings
