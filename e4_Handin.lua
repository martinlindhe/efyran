-- xxx later: can also be used for L65/l70 spell hand ins ? (if "item reward" is in spell book ?)

-- @type mq
local mq = require("mq")

require("ezmq")
local log = require("knightlinc/Write")

local handinRules = {
    ["Nerask/Zone|causeway"] = { -- OOW T2 Silk
        ["Class|WIZ/Academic's Robe of the Arcanists"]         = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
        ["Class|WIZ/Academic's Pants of the Arcanists"]        = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
        ["Class|WIZ/Academic's Sleeves of the Arcanists"]      = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
        ["Class|WIZ/Academic's Cap of the Arcanists"]          = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
        ["Class|WIZ/Academic's Slippers of the Arcanists"]     = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
        ["Class|WIZ/Academic's Gloves of the Arcanists"]       = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
        ["Class|WIZ/Academic's Wristband of the Arcanists"]    = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
        ["Class|MAG/Glyphwielder's Tunic of the Summoner"]     = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
        ["Class|MAG/Glyphwielder's Leggings of the Summoner"]  = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
        ["Class|MAG/Glyphwielder's Sleeves of the Summoner"]   = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
        ["Class|MAG/Glyphwielder's Hat of the Summoner"]       = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
        ["Class|MAG/Glyphwielder's Slippers of the Summoner"]  = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
        ["Class|MAG/Glyphwielder's Gloves of the Summoner"]    = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
        ["Class|MAG/Glyphwielder's Wristband of the Summoner"] = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
        ["Class|ENC/Mindreaver's Vest of Coercion"]            = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
        ["Class|ENC/Mindreaver's Leggings of Coercion"]        = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
        ["Class|ENC/Mindreaver's Armguards of Coercion"]       = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
        ["Class|ENC/Mindreaver's Skullcap of Coercion"]        = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
        ["Class|ENC/Mindreaver's Shoes of Coercion"]           = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
        ["Class|ENC/Mindreaver's Handguards of Coercion"]      = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
        ["Class|ENC/Mindreaver's Bracer of Coercion"]          = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
        ["Class|NEC/Blightbringer's Tunic of the Grave"]       = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
        ["Class|NEC/Blightbringer's Pants of the Grave"]       = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
        ["Class|NEC/Blightbringer's Armband of the Grave"]     = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
        ["Class|NEC/Blightbringer's Cap of the Grave"]         = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
        ["Class|NEC/Blightbringer's Sandals of the Grave"]     = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
        ["Class|NEC/Blightbringer's Handguards of the Grave"]  = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
        ["Class|NEC/Blightbringer's Bracer of the Grave"]      = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
    },
    ["Trelak/Zone|wallofslaughter"] = { -- OOW T2 Plate
        ["Class|WAR/Gladiator's Plate Chestguard of War"]           = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
        ["Class|WAR/Gladiator's Plate Legguards of War"]            = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
        ["Class|WAR/Gladiator's Plate Sleeves of War"]              = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
        ["Class|WAR/Gladiator's Plate Helm of War"]                 = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
        ["Class|WAR/Gladiator's Plate Boots of War"]                = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
        ["Class|WAR/Gladiator's Plate Gloves of War"]               = {"Makyah's Axe",                     "2|Crystal of Yearning"},
        ["Class|WAR/Gladiator's Plate Bracer of War"]               = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        ["Class|CLR/Faithbringers's Breasplate of Conviction"]      = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
        ["Class|CLR/Faithbringers's Leggings of Conviction"]        = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
        ["Class|CLR/Faithbringers's Armguards of Conviction"]       = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
        ["Class|CLR/Faithbringers's Cap of Conviction"]             = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
        ["Class|CLR/Faithbringers's Boots of Conviction"]           = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
        ["Class|CLR/Faithbringers's Gloves of Conviction"]          = {"Makyah's Axe",                     "2|Crystal of Yearning"},
        ["Class|CLR/Faithbringers's Wristband of Conviction"]       = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        ["Class|PAL/Dawnseeker's Chestpiece of the Defender"]       = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
        ["Class|PAL/Dawnseeker's Leggings of the Defender"]         = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
        ["Class|PAL/Dawnseeker's Sleeves of the Defender"]          = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
        ["Class|PAL/Dawnseeker's Coif of the Defender"]             = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
        ["Class|PAL/Dawnseeker's Boots of the Defender"]            = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
        ["Class|PAL/Dawnseeker's Mitts of the Defender"]            = {"Makyah's Axe",                     "2|Crystal of Yearning"},
        ["Class|PAL/Dawnseeker's Wristguard of the Defender"]       = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        ["Class|SHD/Duskbringer's Plate Chestguard of the Hateful"] = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
        ["Class|SHD/Duskbringer's Plate Legguards of the Hateful"]  = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
        ["Class|SHD/Duskbringer's Plate Armguards of the Hateful"]  = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
        ["Class|SHD/Duskbringer's Plate Helm of the Hateful"]       = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
        ["Class|SHD/Duskbringer's Plate Boots of the Hateful"]      = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
        ["Class|SHD/Duskbringer's Plate Gloves of the Hateful"]     = {"Makyah's Axe",                     "2|Crystal of Yearning"},
        ["Class|SHD/Duskbringer's Plate Wristguard of the Hateful"] = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        ["Class|BRD/Farseeker's Plate Chestguard of Harmony"]       = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
        ["Class|BRD/Farseeker's Plate Legguards of Harmony"]        = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
        ["Class|BRD/Farseeker's Plate Armbands of Harmony"]         = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
        ["Class|BRD/Farseeker's Plate Helm of Harmony"]             = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
        ["Class|BRD/Farseeker's Plate Boots of Harmony"]            = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
        ["Class|BRD/Farseeker's Plate Gloves of Harmony"]           = {"Makyah's Axe",                     "2|Crystal of Yearning"},
        ["Class|BRD/Farseeker's Plate Wristguard of Harmony"]       = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
    },
    ["Tibor/Zone|draniksscar"] = { -- OOW T2 Chain
        ["Class|SHM/Ritualchanter's Tunic of the Ancestors"]            = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
        ["Class|SHM/Ritualchanter's Leggings of the Ancestors"]         = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
        ["Class|SHM/Ritualchanter's Armguards of the Ancestors"]        = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
        ["Class|SHM/Ritualchanter's Cap of the Ancestors"]              = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
        ["Class|SHM/Ritualchanter's Boots of the Ancestors"]            = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
        ["Class|SHM/Ritualchanter's Mitts of the Ancestors"]            = {"Makyah's Axe",                     "2|Kyv Whetstone"},
        ["Class|SHM/Ritualchanter's Wristband of the Ancestors"]        = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        ["Class|BER/Wrathbringer's Chain Chestguard of the Vindicator"] = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
        ["Class|BER/Wrathbringer's Chain Leggings of the Vindicator"]   = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
        ["Class|BER/Wrathbringer's Chain Sleeves of the Vindicator"]    = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
        ["Class|BER/Wrathbringer's Chain Helm of the Vindicator"]       = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
        ["Class|BER/Wrathbringer's Chain Boots of the Vindicator"]      = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
        ["Class|BER/Wrathbringer's Chain Gloves of the Vindicator"]     = {"Makyah's Axe",                     "2|Kyv Whetstone"},
        ["Class|BER/Wrathbringer's Chain Wristguard of the Vindicator"] = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        ["Class|ROG/Whispering Tunic of Shadows"]                       = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
        ["Class|ROG/Whispering Pants of Shadows"]                       = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
        ["Class|ROG/Whispering Armguard of Shadows"]                    = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
        ["Class|ROG/Whispering Hat of Shadows"]                         = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
        ["Class|ROG/Whispering Boots of Shadows"]                       = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
        ["Class|ROG/Whispering Gloves of Shadows"]                      = {"Makyah's Axe",                     "2|Kyv Whetstone"},
        ["Class|ROG/Whispering Bracer of Shadows"]                      = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        ["Class|RNG/Bladewhisper Chain Vest of Journeys"]               = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
        ["Class|RNG/Bladewhisper Chain Legguards of Journeys"]          = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
        ["Class|RNG/Bladewhisper Chain Sleeves of Journeys"]            = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
        ["Class|RNG/Bladewhisper Chain Cap of Journeys"]                = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
        ["Class|RNG/Bladewhisper Chain Boots of Journeys"]              = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
        ["Class|RNG/Bladewhisper Chain Gloves of Journeys"]             = {"Makyah's Axe",                     "2|Kyv Whetstone"},
        ["Class|RNG/Bladewhisper Chain Wristband of Journeys"]          = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
    },
    ["Lenarsk/Zone|bloodfields"] = { -- OOW T2 Leather
        ["Class|DRU/Everspring Jerkin of the Tangled Briars"]    = {"Jayruk's Vest",                    "3|Bazu Nail Bracelet"},
        ["Class|DRU/Everspring Pants of the Tangled Briars"]     = {"Patorav's Amulet",                 "3|Discordling Hoof"},
        ["Class|DRU/Everspring Sleeves of the Tangled Briars"]   = {"Lenarsk's Embossed Leather Pouch", "2|Spiked Discordling Collar"},
        ["Class|DRU/Everspring Cap of the Tangled Briars"]       = {"Patorav's Walking Stick",          "2|Muramite Noble's March Award"},
        ["Class|DRU/Everspring Slippers of the Tangled Briars"]  = {"Muramite Cruelty Medal",           "2|Chimera Gut String"},
        ["Class|DRU/Everspring Mitts of the Tangled Briars"]     = {"Makyah's Axe",                     "2|Fine Chimera Hide"},
        ["Class|DRU/Everspring Wristband of the Tangled Briars"] = {"Riftseeker Heart",                 "2|Quality Feran Hide"},
        ["Class|MNK/Fiercehand Shroud of the Focused"]           = {"Jayruk's Vest",                    "3|Bazu Nail Bracelet"},
        ["Class|MNK/Fiercehand Leggings of the Focused"]         = {"Patorav's Amulet",                 "3|Discordling Hoof"},
        ["Class|MNK/Fiercehand Sleeves of the Focused"]          = {"Lenarsk's Embossed Leather Pouch", "2|Spiked Discordling Collar"},
        ["Class|MNK/Fiercehand Cap of the Focused"]              = {"Patorav's Walking Stick",          "2|Muramite Noble's March Award"},
        ["Class|MNK/Fiercehand Tabis of the Focused"]            = {"Muramite Cruelty Medal",           "2|Chimera Gut String"},
        ["Class|MNK/Fiercehand Gloves of the Focused"]           = {"Makyah's Axe",                     "2|Fine Chimera Hide"},
        ["Class|MNK/Fiercehand Wristband of the Focused"]        = {"Riftseeker Heart",                 "2|Quality Feran Hide"},
        ["Class|BST/Savagesoul Jerkin of the Wilds"]             = {"Jayruk's Vest",                    "3|Bazu Nail Bracelet"},
        ["Class|BST/Savagesoul Legguards of the Wilds"]          = {"Patorav's Amulet",                 "3|Discordling Hoof"},
        ["Class|BST/Savagesoul Sleeves of the Wilds"]            = {"Lenarsk's Embossed Leather Pouch", "2|Spiked Discordling Collar"},
        ["Class|BST/Savagesoul Cap of the Wilds"]                = {"Patorav's Walking Stick",          "2|Muramite Noble's March Award"},
        ["Class|BST/Savagesoul Sandals of the Wilds"]            = {"Muramite Cruelty Medal",           "2|Chimera Gut String"},
        ["Class|BST/Savagesoul Gloves of the Wilds"]             = {"Makyah's Axe",                     "2|Fine Chimera Hide"},
        ["Class|BST/Savagesoul Wristband of the Wilds"]          = {"Riftseeker Heart",                 "2|Quality Feran Hide"},
    },

    ["A shimmering presence/Zone|akheva"] = { -- VT key
        ["Shadowed Scepter Frame"]          = {"Summoned: Wisp Stone"},
    },
    ["The Spirit of Akelha`Ra/Zone|akheva"] = { -- VT key
        ["Shadowed Scepter Frame"]          = {"Essence Emerald"},
    },

    ["Tatsujiro the Serene/Zone|lavastorm"] = { -- DoN good
        [""] = {"Norrath's Keepers Token"},
    },
    ["Xeib Darkskies/Zone|lavastorm"] = { -- DoN evil
        [""] = {"Dark Reign Token"},
    },
}

-- performs item hand ins for quest rewards, etc
function auto_hand_in_items()

    local zone = zone_shortname():lower()

    for npcRow, t in pairs(handinRules) do

        local o = parseSpellLine(npcRow)

        if zone == o.Zone then
            log.Info("Zone %s, %s", o.Zone, o.Name)

            local spawn = spawn_from_query('npc "'..o.Name..'"')
            if spawn ~= nil then

                -- see if we have any of the items
                for rewardRow, components in pairs(t) do
                    local reward = parseSpellLine(rewardRow)
                    --print("reward ", reward.Name, " .. class ", reward.Class, " class type ", type(reward.Class))

                    if reward.Class == nil or class_shortname() == reward.Class then -- TODO more advanced class filter
                        local haveParts = false
                        local needParts = false
                        local needMessage = ""

                        -- See if i have any of the required components
                        for i, componentRow in pairs(components) do
                            -- optional syntax: "2|Item name", where 2 is the required item count
                            local found, _ = string.find(componentRow, "|")
                            local component = componentRow
                            local count = 1
                            if found then
                                local key = ""
                                local subIndex = 0
                                for v in string.gmatch(componentRow, "[^|]+") do
                                    if subIndex == 0 then
                                        key = v
                                    end
                                    if subIndex == 1 then
                                        --print(key, " = ", v)
                                        component = v
                                        count = toint(key)
                                    end
                                    subIndex = subIndex + 1
                                end
                            end
                            log.Info("Looking for component %s", component)

                            if have_item_inventory(component) then
                                haveParts = true
                                local haveCount = inventory_item_count(component)
                                log.Info("I have component %s x %d", component, haveCount)
                                if haveCount < count then
                                    needParts = true
                                    needMessage = needMessage.."NEED "..component.." x "..(count-haveCount).." for "..reward.Name
                                end
                            else
                                needParts = true
                                needMessage = needMessage.."NEED "..component.." x "..count.." for "..reward.Name
                            end

                        end

                        if haveParts and needParts then
                            -- asks for the missing items
                            all_tellf("%s", needMessage)
                        elseif not needParts and haveParts then
                            log.Info("I HAVE ALL NEEDED PIECES, DOING HAND IN")

                            if spawn.Distance() > 50 then
                                log.Error("%s is too far away for hand-in.", o.Name)
                                return
                            end

                            target_npc_name(o.Name)
                            move_to(spawn.ID())
                            delay(2000)

                            for i, componentRow in pairs(components) do
                                -- optional syntax: "2|Item name", where 2 is the required item count
                                local found, _ = string.find(componentRow, "|")
                                local component = componentRow
                                local count = 1
                                if found then
                                    local key = ""
                                    local subIndex = 0
                                    for v in string.gmatch(componentRow, "[^|]+") do
                                        if subIndex == 0 then
                                            key = v
                                        end
                                        if subIndex == 1 then
                                            --print(key, " = ", v)
                                            component = v
                                            count = toint(key)
                                        end
                                        subIndex = subIndex + 1
                                    end
                                end

                                -- pick up and hand over items unstacked
                                for each = 1, count do
                                    log.Info("Picking up %s", component)
                                    local item = find_item(component)
                                    if item == nil then
                                        -- unexpected
                                        all_tellf("ERROR find_item failed on %s", component)
                                        break
                                    end

                                    cmdf("/nomodkey /ctrl /itemnotify in Pack%d %d leftmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)
                                    delay(200)
                                    delay(1000, function() return has_cursor_item() end)

                                    log.Info("Handing in %s", component)
                                    cmd("/click left target")
                                    delay(200)

                                    delay(1000, function() return not has_cursor_item() end)
                                    delay(200)
                                end

                            end

                            random_delay(peer_count() * 10)
                            delay(200)
                            if window_open("GiveWnd") then
                                -- PRESS GIVE BUTTON
                                cmd("/nomodkey /notify GiveWnd GVW_Give_Button leftmouseup")
                            else
                                all_tellf("handin UNLIKELY: GiveWnd not open")
                            end

                            return

                        end

                    end
                end

            else
                log.Error("Expected spawn not found in zone: %s", o.Name)
            end

        end
    end
end
