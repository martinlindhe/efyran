local mq = require("mq")
local log = require("knightlinc/Write")

-- Returns the first instrument for given instrument skill.
-- BRD epics have Performance Resonance (all instrument mod)
---@param skill string eg 'Brass Instruments'
---@return string|nil
local function findInstrument(skill)
    local skillFirst = split_str(skill, " ")

    -- 0-22 is worn gear, 23-32 is top level inventory
    for i = 0, 32 do
        local inv = mq.TLO.Me.Inventory(i)
        if inv() ~= nil then
            --log.Debug("inv slot %d: %s", i, inv.Name())
            if inv.Container() > 0 then
                for c = 1, inv.Container() do
                    local item = inv.Item(c)
                    local focusFirst = split_str(item.Focus2() or "", " ")
                    if #focusFirst > 0 then
                        if focusFirst[1] == "Performance" or focusFirst[1] == skillFirst[1] then
                            return item.Name()
                        end
                    end
                end
            else
                local focusFirst = split_str(inv.Focus2() or "", " ")
                if #focusFirst > 0 then
                    if focusFirst[1] == "Performance" or focusFirst[1] == skillFirst[1] then
                        return inv.Name()
                    end
                end
            end
        end
    end
    return nil
end

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
        --["Brass Instruments"] = "McVaxius' Berserker Crescendo",    -- L42 lowest non-detrimental song
        ["Brass Instruments"] = "Denon's Disruptive Discord",       -- L18 PBAE DoT
        ["Percussion Instruments"] = "Elemental Rhythms",           -- L09
        ["Stringed Instruments"] = "Hymn of Restoration",           -- L06
        ["Wind Instruments"] = "Tarew's Aquatic Ayre",              -- L16
    }

    local trainSkills = {
        ["Singing"] = true,
    }

    local skipRest = false
    local prevOffhand = nil

    for skill, song in pairs(songs) do
        --log.Debug("Considering %s %d/%d", skill, skill_value(skill), skill_cap(skill))
        if not skipRest and skill_value(skill) < skill_cap(skill) then
            if have_spell(song) then
                local skipCurrent = false
                if skill ~= "Singing" then
                    local instrument = findInstrument(skill)
                    if instrument ~= nil then
                        -- Need to equip proper instruments in order to skill up!
                        -- So equip the first item found for the required instrument skill, and then skip train the other skills.
                        if not have_item_equipped(instrument) then
                            cmdf('/exchange "%s" offhand', instrument)
                            prevOffhand = mq.TLO.Me.Inventory("offhand")
                            log.Debug("Prev offhand is %s", prevOffhand.Name())
                        end
                        skipRest = true -- only train this instrument skill
                        all_tellf("Using instrument %s to train [+y+]%s[+x+] %d/%d", item_link(instrument), skill, skill_value(skill), skill_cap(skill))
                    else
                        all_tellf("ERROR: cannot train [+r+]%s[+x+], no instrument found", skill)
                        skipCurrent = true
                    end
                end

                if not skipCurrent then
                    log.Info("Memorizing %s in %d", song, currentGem)
                    mq.cmdf('/memorize "%s" %d', song, currentGem)
                    currentGem = currentGem + 1
                    trainSkills[skill] = true
                    mq.delay("6s")
                end
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
                log.Debug("Training %s %d/%d", skill, skill_value(skill), skill_cap(skill))
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
