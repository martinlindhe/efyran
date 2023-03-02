local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local botSettings = require("efyran/e4_BotSettings")

local defaultMelody = "general"

local Bard = { currentMelody = "" }

function Bard.resumeMelody()
    if is_brd() then
        if Bard.currentMelody == "" then
            Bard.PlayMelody(defaultMelody)
        elseif Bard.currentMelody ~= "" and not is_casting() then
            Bard.PlayMelody(Bard.currentMelody)
        end
    end
end

-- memorizes and sings a set of songs defined in peer settings.songs
function Bard.PlayMelody(name)

    if botSettings.settings.songs == nil then
        all_tellf("ERROR no bard songs declared")
        return
    end

    if window_open("MerchantWnd") then
        return
    end

    local songSet = botSettings.settings.songs[name:lower()]
    if songSet == nil then
        all_tellf("ERROR no such song set %s", name)
        cmd("/beep 1")
        return
    end

    log.Info("Scribing bard song set %s", name)

    local gemSet = ""
    for v, songRow in pairs(songSet) do
        local gem = memorize_spell(songRow)
        if gem ~= nil then
            gemSet = gemSet .. gem .. " "
        end
    end

    cmdf("/twist %s", gemSet)
    all_tellf("Playing melody \ay%s\ax.", name)

    Bard.currentMelody = name
end

return Bard
