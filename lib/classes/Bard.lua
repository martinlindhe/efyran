local mq = require("mq")
local log = require("knightlinc/Write")
local botSettings = require("lib/settings/BotSettings")

local defaultMelody = "general"

local Bard = { currentMelody = "" }

-- sync the MQ2Medley song sets from the character settings to the MQ2Medley INI so they can be used
function Bard.UpdateMQ2MedleyINI()
    if not is_brd() then
        return
    end
    if botSettings.settings.songs == nil then
        all_tellf("ERROR no bard songs declared")
        return
    end

    local filename = mq.TLO.MacroQuest.Path("config")() .. "\\".. current_server() .. "_" .. mq.TLO.Me.Name() .. ".ini"

    log.Info("UpdateMQ2MedleyINI updating %s", filename)

    -- clear medley queue
    cmd("/medley clear")

    -- make MQ2Medley quiet and disable debug
    cmdf('/noparse /ini "%s" "MQ2Medley" "Quiet" "1"', filename)
    cmdf('/noparse /ini "%s" "MQ2Medley" "Debug" "0"', filename)

    for songset, tbl in pairs(botSettings.settings.songs) do
        --log.Debug("UpdateMQ2MedleyINI writing \ay%s\ax ...", songset)

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
            if song == nil or song() == nil or song.Duration() == nil then
                all_tellf("ERROR cant find song %s", songData.Name)
                return
            end
            local duration = song.Duration() * 6 -- ticks to seconds
            local condition = "1"

            if songData.Name == "Selo's Song of Travel" or songData.Name == "Shauri's Sonorous Clouding" then
                -- in order to only refresh when song fades
                condition = "!${Me.Invis}"
            end
            if songData.Name == "Selo's Accelerating Chorus" then
                -- in order to refresh as soon as selo's is dropped on bard
                duration = 6
                condition = "!${Me.Buff[Selo's Accelerating Chorus].ID}"
            end

            local val = songData.Name .. "^" .. string.format("%d", duration) .. "^" .. condition
            cmdf('/noparse /ini "%s" "%s" "%s" "%s"', filename, section, key, val)
        end
    end

    -- reload MQ2Medley for changes to take effect
    cmd("/medley reload")
end

---@param quiet boolean|nil
function Bard.resumeMelody(quiet)
    if not is_brd() then
        return
    end
    if Bard.currentMelody == "" then
        Bard.PlayMelody(defaultMelody, quiet)
    elseif Bard.currentMelody ~= "" and not is_casting() then
        Bard.PlayMelody(Bard.currentMelody, quiet)
    end
end

function Bard.pauseMelody()
    if mq.TLO.Medley.Active() then
        cmd("/medley stop")
        mq.delay(20, function() return not mq.TLO.Me.Casting.ID() end)
    end
end

-- memorizes and sings a set of songs defined in peer settings.songs
---@param name string name of song set
---@param quiet boolean|nil
function Bard.PlayMelody(name, quiet)

    if botSettings.settings.songs == nil then
        all_tellf("ERROR no bard songs declared")
        return
    end

    if window_open("MerchantWnd") then
        return
    end

    name = name:lower()
    local prevMelody = Bard.currentMelody

    Bard.StopMelody()

    if name == "off" or name == "stop" then
        if not quiet then
            all_tellf("Stopping song set [+y+]%s[+x+].", prevMelody)
        end
        return
    end

    local songSet = botSettings.settings.songs[name]
    if songSet == nil then
        all_tellf("[+r+]ERROR[+x+] no such song set [+y+]%s[+x+]", name)
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
    if not quiet then
        all_tellf("Playing song set [+y+]%s[+x+].", name)
    end

    Bard.currentMelody = name
end

function Bard.StopMelody()
    Bard.currentMelody = ""
    cmd("/medley stop")
end

return Bard
