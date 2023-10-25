local mq = require("mq")
local log = require("knightlinc/Write")

require("ezmq")

return function()

    if not is_brd() then
        return
    end

    log.Info("Bard Song trainer started")

    if is_sitting() then
        cmd("/stand")
    end

    mq.cmd("/medley stop")

    -- TODO: need to equip proper instruments in order to skill up!

    local currentGem = 1

    local songs = {
        ["Singing"] = "Chant of Battle",                            -- L01
        ["Brass Instruments"] = "McVaxius' Berserker Crescendo",    -- L42 lowest non-detrimental song
        ["Percussion Instruments"] = "Elemental Rhythms",           -- L09
        ["Stringed Instruments"] = "Hymn of Restoration",           -- L06
        ["Wind Instruments"] = "Tarew's Aquatic Ayre",              -- L16
    }

    -- memorize training songs
    for skill, song in pairs(songs) do
        if skill_value(skill) < skill_cap(skill) then
            if have_spell(song) then
                log.Info("Memorizing %s in %d", song, currentGem)
                mq.cmdf('/memorize "%s" %d', song, currentGem)
                currentGem = currentGem + 1
                all_tellf("Training %s %d/%d", skill, skill_value(skill), skill_cap(skill))
                mq.delay("6s")
                mq.cmdf('/medley queue "%s"', song)
            else
                all_tellf("ERROR: Cannot train %s, missing song %s", skill, song)
            end
        end
    end

    mq.cmd("/medley start")

    while true do
        local capped = true
        for skill, song in pairs(songs) do
            if skill_value(skill) < skill_cap(skill) and have_spell(song) then
                capped = false
                log.Info("Training %s %d/%d", skill, skill_value(skill), skill_cap(skill))
                mq.cmdf('/medley queue "%s"', song)
                mq.delay("3s")
                mq.doevents()
            end
        end

        if capped then
            all_tellf("Bard training finished!")
            break
        end
    end

end
