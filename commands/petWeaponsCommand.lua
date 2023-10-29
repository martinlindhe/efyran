local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")
local botSettings    = require("lib/settings/BotSettings")

local function distributePetWeapons()

    if botSettings.settings.pet == nil or botSettings.settings.pet.weapons == nil then
        log.Error("No pet weapons configured")
        return
    end

    for _, weapon in pairs(botSettings.settings.pet.weapons) do
        log.Info("Distribute pet weapon \ay%s\ax", weapon)

        local o = parseSpellLine(weapon)

        if not is_memorized(o.Name) then
            all_tellf("WARNING: had to memorize pet weapon spell %s, this will slow me down. you should keep pet weapon spells in spell gems", o.Name)
            memorize_spell(o.Name, 5)
        end

        local spell = get_spell(o.Name)
        if spell == nil then
            all_tellf("UNLIKELY: dpw cannot resolve spell %s", o.Name)
            return
        end

        -- find all pets, give them stuff
        if o.Summon == nil then
            all_tellf("ERROR: pet weapon spell %s lacks Summon argument", o.Name)
        end

        clear_cursor(true)

        local finishedPets = {}

        -- find pet
        local query = string.format("pcpet zradius 30 radius %d", 100)
        local petCount = spawn_count(query)
        for i = 1, petCount do
            local pet = mq.TLO.NearestSpawn(i, query)
            --log.Debug("Pet %s", pet.Name())
            if pet() ~= nil and not string.find(pet.Name(), "familiar") and finishedPets[pet.Name()] == nil then

                -- summon weapon
                if not have_item(o.Summon) then
                    castSpellAbility(nil, o.Name)
                    wait_until_not_casting()
                    --log.Debug("Done casting pet weapon... ")
                    if not have_cursor_item() then
                        all_tellf("FAILED to make pet weapon %s", o.Name)
                        return
                    end
                else
                    log.Debug("I already have a %s, skip summoning", o.Name)
                    local item = find_item(o.Summon)
                    if item == nil then
                        all_tellf("FAILED to resolve pet weapon %s", o.Name)
                        return
                    end
                    -- pick up item
                    cmdf("/nomodkey /shiftkey /itemnotify in pack%d %d leftmouseup", item.ItemSlot()-22, item.ItemSlot2() + 1)
                end

                move_to(pet.ID())
                target_id(pet.ID())
                log.Info("Giving weapon %s to pet %s", o.Summon, pet.Name())

                local cursor = mq.TLO.Cursor
                if cursor() ~= nil and cursor.Name() ~= o.Summon then
                    all_tellf("UNLIKELY: wrong item on cursor %s. should be %s, aborting", cursor.Name(), o.Summon)
                    return
                end
                if cursor() == nil then
                    all_tellf("UNLIKELY: no item on cursor, should be %s", o.Summon)
                    return
                end

                -- give to pet
                cmd("/click left target")
                mq.delay("1s", function() return window_open("GiveWnd") end)

                if window_open("GiveWnd") then
                    cmd("/nomodkey /notify GiveWnd GVW_Give_Button leftmouseup")
                else
                    all_tellf("UNLIKELY: pet weapon handin GiveWnd not open")
                end

                log.Info("Armed \ag%s\ax with %s !", pet.Name(), o.Summon)

                mq.delay(spell.RecastTime())

                finishedPets[pet.Name()] = true
            end

        end

    end
end

bind("/dpw", function() commandQueue.Enqueue(function() distributePetWeapons() end) end)
