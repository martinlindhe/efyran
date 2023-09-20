local mq = require("mq")
local log = require("efyran/knightlinc/Write")
local botSettings = require("efyran/e4_BotSettings")

local defaultMelody = "general"

local Bard = { currentMelody = "" }

-- sync the MQ2Medley song sets from the character settings to the MQ2Medley INI so they can be used
function Bard.UpdateMQ2MedleyINI()
    if not is_brd() then
        return
    end
    --local filename = "D:\dev-mq\macroquest-rof2\build\bin\release\config\server_toon.ini"
    local filename = mq.TLO.MacroQuest.Path("config")() .. "\\".. current_server() .. "_" .. mq.TLO.Me.Name() .. ".ini"

    log.Info("UpdateMQ2MedleyINI filename: %s", filename)

    -- clear medley queue
    cmd("/medley clear")

    for songset, tbl in pairs(botSettings.settings.songs) do
        log.Info("UpdateMQ2MedleyINI writing \ay%s\ax ...", songset)

        local section = "MQ2Medley-efyran-" .. songset

        -- delete old entries. TODO LATER: actually delete the entries, now they are just cleared
        for i = 1, 8 do
            local key = string.format("song%d", i)
            --log.Info("Delete key %s", key)
            cmdf('/ini "%s" "%s" "%s" "%s"', filename, section, key, "")
        end

        -- write current song set
        for i, songRow in pairs(tbl) do
            local key = string.format("song%d", i)
            local songData = parseSpellLine(songRow)
            local song = get_spell(songData.Name)
            local duration = song.Duration() * 6 -- ticks to seconds
            local condition = "1"

            if songData.Name == "Selo's Song of Travel" or songData.Name == "Shauri's Sonorous Clouding" then
                condition = "!${Me.Invis}"
            end

            local val = songData.Name .. "^" .. string.format("%d", duration) .. "^" .. condition
            cmdf('/noparse /ini "%s" "%s" "%s" "%s"', filename, section, key, val)
        end
    end

    -- reload MQ2Medley for changes to take effect
    cmd("/medley reload")

end

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

    cmdf("/medley efyran-%s", name)
    all_tellf("Playing melody \ay%s\ax.", name)

    Bard.currentMelody = name
end

function Bard.StopMelody()
    Bard.currentMelody = ""
    cmd("/medley stop")
end

return Bard
