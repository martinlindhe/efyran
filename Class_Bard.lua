local defaultMelody = "general"

local Bard = { currentMelody = "" }

function Bard.DoEvents()
    -- print('Bard.DoEvents')
    if Bard.currentMelody == "" then
        Bard.ScribeSongSet(defaultMelody)
    end
end

-- memorize and twist given songset
function Bard.ScribeSongSet(name)

    if botSettings.settings.songs == nil then
        mq.cmd.dgtell("ERROR no bard songs declared")
        mq.cmd.beep(1)
        mq.delay(50000)
        return
    end

    local songSet = botSettings.settings.songs[name]
    if songSet == nil then
        mq.cmd.dgtell("ERROR no such song set", name)
        mq.cmd.beep(1)
        return
    end
    -- tprint(songSet)
    
    print("Scribing bard song set ", name)

    -- XXX only write spell set to ini once (keep track), and only parse it all once

    -- TODO: I dunno how to better use mq2medley. we write song set to mq2medley_character.ini and then /medley reload /medley <name>, can we just tell it with commands?

    local id = mq.TLO.MacroQuest.Server() .. "_" .. mq.TLO.Me.Name()
    local iniFile = mq.TLO.MacroQuest.Path() .. "/config/" .. id .. ".ini"

    for v, songRow in pairs(songSet) do
        -- War March of Muram/Gem|4
        local o = parseSpellLine(songRow) -- XXX parse this once on script startup. dont evaluate all the time !!!

        if mq.TLO.Me.Book(o.SpellName)() == nil then
            mq.cmd.dgtell("ERROR don't know bard song", o.SpellName)
            mq.cmd.beep(1)
            return
        end

        if o["Gem"] ~= nil then
            -- make sure that song is scribed, else scribe it
            if mq.TLO.Me.Gem(o["Gem"]).Name() ~= o.SpellName then
                print("SCRIBE SONG IN GEM ", o["Gem"], ": want:", o.SpellName, ", have:", mq.TLO.Me.Gem(o["Gem"]).Name())
                mq.cmd.memorize('"'..o.SpellName..'"', o["Gem"])
                mq.delay(3000)  -- XXX 3s
            end
        end

        -- write out song to mq2medley section
        mq.cmd.ini(iniFile, "MQ2Medley-"..name, "song"..v, '"'..o.SpellName..'"')
    end

    mq.cmd.medley("reload")
    mq.delay(10)
    mq.cmd.medley(name)

    Bard.currentMelody = name
end

mq.bind("/playmelody", function(name, called)
    if not called then
        --mq.cmd.dgzexecute("/playmelody", name, true) -- everyone in current zone
        mq.cmd.dgexecute("brd", "/playmelody", name, true) -- all bards
    end

    if mq.TLO.Me.Class.ShortName() == "BRD" then
        Bard.ScribeSongSet(name)
    end
end)

return Bard
