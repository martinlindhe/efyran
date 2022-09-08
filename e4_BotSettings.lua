-- FIXME: relative path...
local settingsRoot = "D:/dev-mq/mqnext-e4-lua/settings"

local BotSettings = {
    ["healme_channel"] = "", -- healme channel for current zone
    ["toggles"] = {
        ["refresh_buffs"] = true,   -- /buffon, /buffoff
    },
}


-- XXX improve peer template generation
local peerTemplate = [[
local settings = { }

settings.self_buffs = {
}

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
}

return settings
]]

function BotSettings.Init()
    if is_hovering() then
        mq.cmd.dgtell("all FATAL ERROR: cannot start e4 successfully while in HOVERING mode")
        mq.cmd.beep(1)
        return
    end
    local id = mq.TLO.MacroQuest.Server() .. "_" .. mq.TLO.Me.Class.ShortName() .. "_" .. mq.TLO.Me.Name()
    local settingsFile = settingsRoot .. "/" .. id .. ".lua"
    print("Reading peer settings ", settingsFile)

    local settings = loadfile(settingsFile)
    if settings ~= nil then
        BotSettings.settings = settings()
    else
        -- no settings file found
        mq.cmd.dgtell("PEER INI NOT FOUND, CREATING EMPTY ONE. PLEASE EDIT ", settingsFile)
        mq.cmd.beep(1)

        local f = assert(io.open(settingsFile, "w"))
        f:write(peerTemplate)
        f:close()

        -- WE ARE IN A BROKEN STATE
        os.exit()
    end
end

return BotSettings
