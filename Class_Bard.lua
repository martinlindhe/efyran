local defaultMelody = "general"

local Bard = { currentMelody = "" }

function Bard.DoEvents()
    -- print('Bard.DoEvents')
    if Bard.currentMelody == "" then
        Bard.PlayMelody(defaultMelody)
    elseif Bard.currentMelody ~= "" and mq.TLO.Me.Casting.ID() == nil then
        Bard.PlayMelody(Bard.currentMelody)
    end
end

-- scribes and sings a melody (set of songs defined in peer settings)
function Bard.PlayMelody(name)
    if name == Bard.currentMelody then
        return
    end

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


    local gemSet = ""
    for v, songRow in pairs(songSet) do
        -- War March of Muram/Gem|4
        local o = parseSpellLine(songRow) -- XXX parse this once on script startup. dont evaluate all the time !!!

        local nameWithRank = mq.TLO.Spell(o.SpellName).RankName()
        print("brd check... ", o.SpellName, " ... ", nameWithRank)

        if mq.TLO.Me.Book(nameWithRank)() == nil then
            mq.cmd.dgtell("ERROR don't know bard song", o.SpellName)
            mq.cmd.beep(1)
            return
        end

        if o["Gem"] ~= nil then
            -- make sure that song is scribed, else scribe it
            if mq.TLO.Me.Gem(o["Gem"]).Name() ~= nameWithRank then
                -- XXX proper rank name
                print("SCRIBE SONG IN GEM ", o["Gem"], ": want:", nameWithRank, ", have:", mq.TLO.Me.Gem(o["Gem"]).Name())
                mq.cmd.memorize('"'..nameWithRank..'"', o["Gem"])
                mq.delay(3000)  -- XXX 3s
            end
        else
            mq.cmd.dgtell("all ERROR bard song lacks Gem|x argument: ", songRow)
            mq.cmd.beep(1)
        end

        gemSet = gemSet .. o["Gem"] .. " "

    end

    mq.cmd.melody(gemSet)
    print("Playing bard song set ", name, ": ", gemSet)

    Bard.currentMelody = name
end

mq.bind("/playmelody", function(name)
    local orchestrator = mq.TLO.FrameLimiter.Status() == "Foreground"
    if orchestrator then
        mq.cmd.dgexecute("brd", "/playmelody", name) -- all bards
    end
    Bard.PlayMelody(name)
end)


return Bard
