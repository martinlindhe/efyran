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

    local currentGem = 1

    local songs = {
        ["Singing"] = "Chant of Battle",                            -- L01
        ["Brass Instruments"] = "McVaxius' Berserker Crescendo",    -- L42 lowest non-detrimental song
        ["Percussion Instruments"] = "Elemental Rhythms",           -- L09
        ["Stringed Instruments"] = "Hymn of Restoration",           -- L06
        ["Wind Instruments"] = "Tarew's Aquatic Ayre",              -- L16
    }

    -- NOTE: Only instruments that go in OFFHAND slot!
    local instruments = {
        ["Brass Instruments"] = {
            "Horn",
            "Combine Horn",
        },
        ["Percussion Instruments"] = {
            "Hand Drum",
            "Combine Hand Drum",
        },
        ["Stringed Instruments"] = {
            "Lute",
            "Mandolin",
            "Combine Lute",
            "Combine Mandolin",
        },
        ["Wind Instruments"] = {
            "Wooden Flute",
            "Combine Wooden Flute",
        },
    }

    -- TODO: check for BRD epic 1.0, 1.5 and 2.0, they have Performance Resonance (all instrument mod)

    local trainSkills = {
        ["Singing"] = true,
    }

    local skipRest = false
    local prevOffhand = nil

    for skill, song in pairs(songs) do
        log.Debug("Considering %s %d/%d", skill, skill_value(skill), skill_cap(skill))
        if not skipRest and skill_value(skill) < skill_cap(skill) then
            if have_spell(song) then
                if skill ~= "Singing" then
                    for _, instrument in pairs(instruments[skill]) do
                        if have_item_inventory(instrument) and not have_item_equipped(instrument) then
                            -- Need to equip proper instruments in order to skill up!
                            -- So equip the first item found for the required instrument skill, and then skip train the other skills.
                            cmdf('/exchange "%s" offhand', instrument)
                            prevOffhand = mq.TLO.Me.Inventory("offhand")
                            skipRest = true -- only train this instrument skill
                            log.Info("OLD OFFHAND %s", prevOffhand.Name())
                            all_tellf("Equipped %s to train %s (had %s)", instrument, skill, tostring(prevOffhand.Name()))
                        end
                    end
                end

                log.Info("Memorizing %s in %d", song, currentGem)
                mq.cmdf('/memorize "%s" %d', song, currentGem)
                currentGem = currentGem + 1
                trainSkills[skill] = true
                mq.delay("6s")
            else
                all_tellf("ERROR: Cannot train [+y+]%s[+x+], missing song [+y+]%s[+x+]", skill, song)
            end
        end
    end

    mq.cmd("/medley start")

    while true do
        local capped = true
        for skill, song in pairs(songs) do
            if trainSkills[skill] == true and skill_value(skill) < skill_cap(skill) and have_spell(song) then
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

    if prevOffhand ~= nil then
        all_tellf("RESTORING OFFHAND SLOT TO %s", prevOffhand.Name())
        cmdf('/exchange "%s" offhand', prevOffhand.Name())
    end

end
