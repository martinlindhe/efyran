local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local botSettings = require("efyran/e4_BotSettings")

local defaultMelody = "general"

local Bard = { currentMelody = "" }

mq.event("missed_note", "You miss a note, bringing your song to a close!", function(line)
    log.Info("Missed a note, restarting melody!")
    delay(2000)
    Bard.PlayMelody(Bard.currentMelody)
end)

function Bard.resumeMelody()
    if not is_brd() then
        return
    end
    if Bard.currentMelody == "" then
        Bard.PlayMelody(defaultMelody)
    elseif Bard.currentMelody ~= "" and not is_casting() then
        Bard.PlayMelody(Bard.currentMelody)
    end
end

-- memorizes and sings a set of songs defined in peer settings.songs
---@param name string name of song set
function Bard.PlayMelody(name)

    if botSettings.settings.songs == nil then
        all_tellf("ERROR no bard songs declared")
        return
    end

    if window_open("MerchantWnd") then
        return
    end

    name = name:lower()

    if name == "off" or name == "stop" then
        Bard.StopMelody()
        return
    end

    local songSet = botSettings.settings.songs[name]
    if songSet == nil then
        all_tellf("ERROR no such song set %s", name)
        cmd("/beep 1")
        return
    end

    log.Info("Scribing bard song set \ag%s\ax ...", name)

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

function Bard.StopMelody()
    Bard.currentMelody = ""
    cmd("/twist off")
end

return Bard
