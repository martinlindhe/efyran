--- xxx todo:

-- declare set of items to hand in, to specific NPC.

-- cmd to report if toon has any of these items.

-- cmd to auto hand in these items.

-- xxx later: can also be used for L65/l70 spell hand ins ? (if "item reward" is in spell book ?)

-- xxx later: can this replace talos.mac ?

local rules = {
    ["Nerask/Zone|causeway"] = {
        -- OOW T2 Silk
        ["wiz"] = { -- XXX: class filter
            -- XXX item reward = hand in items
            ["Academic's Robe of the Arcanists"]         = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"}, -- XXX 3x fruit
            ["Academic's Pants of the Arcanists"]        = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
            ["Academic's Sleeves of the Arcanists"]      = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
            ["Academic's Cap of the Arcanists"]          = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
            ["Academic's Slippers of the Arcanists"]     = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
            ["Academic's Gloves of the Arcanists"]       = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
            ["Academic's Wristband of the Arcanists"]    = {"Riftseeker Heart",                 "2|Riftseeker Trinket"}, -- XXX also 2x Wrist rewards
        },
        ["mag"] = {
            ["Glyphwielder's Tunic of the Summoner"]     = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
            ["Glyphwielder's Leggings of the Summoner"]  = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
            ["Glyphwielder's Sleeves of the Summoner"]   = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
            ["Glyphwielder's Hat of the Summoner"]       = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
            ["Glyphwielder's Slippers of the Summoner"]  = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
            ["Glyphwielder's Gloves of the Summoner"]    = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
            ["Glyphwielder's Wristband of the Summoner"] = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
        },
        ["enc"] = {
            ["Mindreaver's Vest of Coercion"]            = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
            ["Mindreaver's Leggings of Coercion"]        = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
            ["Mindreaver's Armguards of Coercion"]       = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
            ["Mindreaver's Skullcap of Coercion"]        = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
            ["Mindreaver's Shoes of Coercion"]           = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
            ["Mindreaver's Handguards of Coercion"]      = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
            ["Mindreaver's Bracer of Coercion"]          = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
        },
        ["nec"] = {
            ["Blightbringer's Tunic of the Grave"]       = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"},
            ["Blightbringer's Pants of the Grave"]       = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
            ["Blightbringer's Armband of the Grave"]     = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
            ["Blightbringer's Cap of the Grave"]         = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
            ["Blightbringer's Sandals of the Grave"]     = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
            ["Blightbringer's Handguards of the Grave"]  = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
            ["Blightbringer's Bracer of the Grave"]      = {"Riftseeker Heart",                 "2|Riftseeker Trinket"},
        },
    },

    ["Trelak/Zone|wallofslaughter"] = {
        -- OOW T2 Plate
        ["war"] = {
            ["Gladiator's Plate Chestguard of War"]           = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
            ["Gladiator's Plate Legguards of War"]            = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
            ["Gladiator's Plate Sleeves of War"]              = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
            ["Gladiator's Plate Helm of War"]                 = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
            ["Gladiator's Plate Boots of War"]                = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
            ["Gladiator's Plate Gloves of War"]               = {"Makyah's Axe",                     "2|Crystal of Yearning"},
            ["Gladiator's Plate Bracer of War"]               = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        },
        ["clr"] = {
            ["Faithbringers's Breasplate of Conviction"]      = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
            ["Faithbringers's Leggings of Conviction"]        = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
            ["Faithbringers's Armguards of Conviction"]       = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
            ["Faithbringers's Cap of Conviction"]             = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
            ["Faithbringers's Boots of Conviction"]           = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
            ["Faithbringers's Gloves of Conviction"]          = {"Makyah's Axe",                     "2|Crystal of Yearning"},
            ["Faithbringers's Wristband of Conviction"]       = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        },
        ["pal"] = {
            ["Dawnseeker's Chestpiece of the Defender"]       = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
            ["Dawnseeker's Leggings of the Defender"]         = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
            ["Dawnseeker's Sleeves of the Defender"]          = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
            ["Dawnseeker's Coif of the Defender"]             = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
            ["Dawnseeker's Boots of the Defender"]            = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
            ["Dawnseeker's Mitts of the Defender"]            = {"Makyah's Axe",                     "2|Crystal of Yearning"},
            ["Dawnseeker's Wristguard of the Defender"]       = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        },
        ["shd"] = {
            ["Duskbringer's Plate Chestguard of the Hateful"] = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
            ["Duskbringer's Plate Legguards of the Hateful"]  = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
            ["Duskbringer's Plate Armguards of the Hateful"]  = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
            ["Duskbringer's Plate Helm of the Hateful"]       = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
            ["Duskbringer's Plate Boots of the Hateful"]      = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
            ["Duskbringer's Plate Gloves of the Hateful"]     = {"Makyah's Axe",                     "2|Crystal of Yearning"},
            ["Duskbringer's Plate Wristguard of the Hateful"] = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        },
        ["brd"] = {
            ["Farseeker's Plate Chestguard of Harmony"]       = {"Jayruk's Vest",                    "3|Ceremonial Dragorn Candle"},
            ["Farseeker's Plate Legguards of Harmony"]        = {"Patorav's Amulet",                 "3|Blackened Discordling Tail"},
            ["Farseeker's Plate Armbands of Harmony"]         = {"Lenarsk's Embossed Leather Pouch", "2|Noc Right Hand"},
            ["Farseeker's Plate Helm of Harmony"]             = {"Patorav's Walking Stick",          "2|Kyv Food Sack"},
            ["Farseeker's Plate Boots of Harmony"]            = {"Muramite Cruelty Medal",           "2|Kyv Hunter Ring"},
            ["Farseeker's Plate Gloves of Harmony"]           = {"Makyah's Axe",                     "2|Crystal of Yearning"},
            ["Farseeker's Plate Wristguard of Harmony"]       = {"Riftseeker Heart",                 "2|Large Piece of Kuuan Ore"},
        },
    },

    ["Tibor/Zone|draniksscar"] = {
        -- OOW T2 Chain
        ["shm"] = {
            ["Ritualchanter's Tunic of the Ancestors"]            = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
            ["Ritualchanter's Leggings of the Ancestors"]         = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
            ["Ritualchanter's Armguards of the Ancestors"]        = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
            ["Ritualchanter's Cap of the Ancestors"]              = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
            ["Ritualchanter's Boots of the Ancestors"]            = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
            ["Ritualchanter's Mitts of the Ancestors"]            = {"Makyah's Axe",                     "2|Kyv Whetstone"},
            ["Ritualchanter's Wristband of the Ancestors"]        = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        },
        ["ber"] = {
            ["Wrathbringer's Chain Chestguard of the Vindicator"] = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
            ["Wrathbringer's Chain Leggings of the Vindicator"]   = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
            ["Wrathbringer's Chain Sleeves of the Vindicator"]    = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
            ["Wrathbringer's Chain Helm of the Vindicator"]       = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
            ["Wrathbringer's Chain Boots of the Vindicator"]      = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
            ["Wrathbringer's Chain Gloves of the Vindicator"]     = {"Makyah's Axe",                     "2|Kyv Whetstone"},
            ["Wrathbringer's Chain Wristguard of the Vindicator"] = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        },
        ["rog"] = {
            ["Whispering Tunic of Shadows"]                       = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
            ["Whispering Pants of Shadows"]                       = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
            ["Whispering Armguard of Shadows"]                    = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
            ["Whispering Hat of Shadows"]                         = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
            ["Whispering Boots of Shadows"]                       = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
            ["Whispering Gloves of Shadows"]                      = {"Makyah's Axe",                     "2|Kyv Whetstone"},
            ["Whispering Bracer of Shadows"]                      = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        },
        ["rng"] = {
            ["Bladewhisper Chain Vest of Journeys"]               = {"Jayruk's Vest",                    "3|Kyv Short Bow"},
            ["Bladewhisper Chain Legguards of Journeys"]          = {"Patorav's Amulet",                 "3|Shattered Ukun Hide"},
            ["Bladewhisper Chain Sleeves of Journeys"]            = {"Lenarsk's Embossed Leather Pouch", "2|Ikaav Head"},
            ["Bladewhisper Chain Cap of Journeys"]                = {"Patorav's Walking Stick",          "2|Kyv Scout Ring"},
            ["Bladewhisper Chain Boots of Journeys"]              = {"Muramite Cruelty Medal",           "2|Dragorn Muramite Ring"},
            ["Bladewhisper Chain Gloves of Journeys"]             = {"Makyah's Axe",                     "2|Kyv Whetstone"},
            ["Bladewhisper Chain Wristband of Journeys"]          = {"Riftseeker Heart",                 "2|Withered Discordling Tongue"},
        },
    },

    ["Lenarsk/Zone|bloodfields"] = {
        -- OOW T2 Leather
        ["dru"] = {
            ["Everspring Jerkin of the Tangled Briars"]    = {"Jayruk's Vest",                    "3|Bazu Nail Bracelet"},
            ["Everspring Pants of the Tangled Briars"]     = {"Patorav's Amulet",                 "3|Discordling Hoof"},
            ["Everspring Sleeves of the Tangled Briars"]   = {"Lenarsk's Embossed Leather Pouch", "2|Spiked Discordling Collar"},
            ["Everspring Cap of the Tangled Briars"]       = {"Patorav's Walking Stick",          "2|Muramite Noble's March Award"},
            ["Everspring Slippers of the Tangled Briars"]  = {"Muramite Cruelty Medal",           "2|Chimera Gut String"},
            ["Everspring Mitts of the Tangled Briars"]     = {"Makyah's Axe",                     "2|Fine Chimera Hide"},
            ["Everspring Wristband of the Tangled Briars"] = {"Riftseeker Heart",                 "2|Quality Feran Hide"},
        },
        ["mnk"] = {
            ["Fiercehand Shroud of the Focused"]           = {"Jayruk's Vest",                    "3|Bazu Nail Bracelet"},
            ["Fiercehand Leggings of the Focused"]         = {"Patorav's Amulet",                 "3|Discordling Hoof"},
            ["Fiercehand Sleeves of the Focused"]          = {"Lenarsk's Embossed Leather Pouch", "2|Spiked Discordling Collar"},
            ["Fiercehand Cap of the Focused"]              = {"Patorav's Walking Stick",          "2|Muramite Noble's March Award"},
            ["Fiercehand Tabis of the Focused"]            = {"Muramite Cruelty Medal",           "2|Chimera Gut String"},
            ["Fiercehand Gloves of the Focused"]           = {"Makyah's Axe",                     "2|Fine Chimera Hide"},
            ["Fiercehand Wristband of the Focused"]        = {"Riftseeker Heart",                 "2|Quality Feran Hide"},
        },
        ["bst"] = {
            ["Savagesoul Jerkin of the Wilds"]             = {"Jayruk's Vest",                    "3|Bazu Nail Bracelet"},
            ["Savagesoul Legguards of the Wilds"]          = {"Patorav's Amulet",                 "3|Discordling Hoof"},
            ["Savagesoul Sleeves of the Wilds"]            = {"Lenarsk's Embossed Leather Pouch", "2|Spiked Discordling Collar"},
            ["Savagesoul Cap of the Wilds"]                = {"Patorav's Walking Stick",          "2|Muramite Noble's March Award"},
            ["Savagesoul Sandals of the Wilds"]            = {"Muramite Cruelty Medal",           "2|Chimera Gut String"},
            ["Savagesoul Gloves of the Wilds"]             = {"Makyah's Axe",                     "2|Fine Chimera Hide"},
            ["Savagesoul Wristband of the Wilds"]          = {"Riftseeker Heart",                 "2|Quality Feran Hide"},
        },
    },

}