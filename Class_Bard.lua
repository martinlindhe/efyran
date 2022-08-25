local defaultMelody = "general"

local Bard = { currentMelody = "" }

-- tells all bards to play given melody name
mq.bind("/playmelody", function(name)
    if is_orchestrator() then
        mq.cmd.dgexecute("brd", "/playmelody", name)
    end
    if is_brd() then
        Bard.PlayMelody(name)
    end
end)

function Bard.resumeMelody()
    if is_brd() then
        if Bard.currentMelody == "" then
            Bard.PlayMelody(defaultMelody)
        elseif Bard.currentMelody ~= "" and not is_casting() then
            Bard.PlayMelody(Bard.currentMelody)
        end
    end
end

-- scribes and sings a melody (set of songs defined in peer settings)
function Bard.PlayMelody(name)

    if botSettings.settings.songs == nil then
        mq.cmd.dgtell("ERROR no bard songs declared")
        mq.cmd.beep(1)
        mq.delay(50000)
        return
    end

    if mq.TLO.Window("MerchantWnd").Open() then
        return
    end

    local songSet = botSettings.settings.songs[name]
    if songSet == nil then
        mq.cmd.dgtell("ERROR no such song set", name)
        mq.cmd.beep(1)
        return
    end

    print("Scribing bard song set ", name)

    local gemSet = ""
    for v, songRow in pairs(songSet) do
        -- War March of Muram/Gem|4
        local o = parseSpellLine(songRow) -- XXX parse this once on script startup. dont evaluate all the time !!!

        local nameWithRank = mq.TLO.Spell(o.Name).RankName()
        --print("considering bard song ... ", o.Name, " ... ", nameWithRank)

        if mq.TLO.Me.Book(nameWithRank)() == nil then
            mq.cmd.dgtell("ERROR don't know bard song", o.Name)
            mq.cmd.beep(1)
            return
        end

        if o["Gem"] ~= nil then
            -- make sure that song is scribed, else scribe it
            if mq.TLO.Me.Gem(o["Gem"]).Name() ~= nameWithRank then
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

    mq.cmd.twist(gemSet)
    mq.cmd.dgtell("all Playing melody", name)

    Bard.currentMelody = name
end

return Bard
