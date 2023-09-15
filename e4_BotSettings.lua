local log = require("efyran/knightlinc/Write")

local mq = require("mq")

---@class PeerSettings
---@field public assist PeerSettingsAssist
---@field public gems string[]|nil XXX key is string, val is integer
---@field public self_buffs string[]|nil spellRows of self buffs
---@field public request_buffs string[]|nil spellRows of buff groups to request

---@class PeerSettingsAssist
---@field public type string "melee" or "ranged"
---@field public melee_distance string|integer "auto" or a number

local botSettings = {
    ---@type PeerSettings
    settings = {}
}

-- XXX improve peer template generation
local peerTemplate = [[
---@type PeerSettings
local settings = { }

settings.gems = {
    --["Minor Healing"] = 1,
}

settings.swap = {
    main = "",
}

settings.self_buffs = {
}

settings.healing = {
    life_support = {
        --"Distillate of Divine Healing XI/HealPct|10",
    },
}

settings.assist = {
    type = "Melee",
    engage_percent = 98,
}

return settings
]]

---@param settingsFile string
local function read_settings(settingsFile)
    log.Info("Reading peer settings %s", settingsFile)
    return loadfile(settingsFile)
end

function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f)
        return true
    else
        return false
    end
end


function botSettings.Init()
    local settingsFile = getEfyranRoot() .. "/settings/" .. peer_settings_file()
    local settings = read_settings(settingsFile)
    if settings ~= nil then
        botSettings.settings = settings()
    elseif not file_exists(settingsFile) then
        all_tellf("PEER INI NOT FOUND, CREATING EMPTY ONE. PLEASE EDIT %s", settingsFile)
        cmd("/beep 1")

        local f = assert(io.open(settingsFile, "w"))
        f:write(peerTemplate)
        f:close()

        settings = read_settings(settingsFile)
        botSettings.settings = settings()
    else
        all_tellf("FAILED TO PARSE SETTINGS FROM %s", settingsFile)
        cmd("/beep")
    end
end

-- Returns the current illusion
---@return string|nil
function botSettings.GetCurrentIllusion()
    local key = botSettings.settings.illusions.default
    if key == nil or key == "" then
        return nil
    end

    -- A: The default illusion refers to another key
    local illusion = botSettings.settings.illusions[key]
    if illusion ~= nil then
        return illusion
    end

    -- B: The default illusion refers to a specific clicky/spell
    return key
end

botSettings.Init()

return botSettings
