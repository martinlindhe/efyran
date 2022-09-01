--- xxx todo:

-- declare set of items to hand in, to specific NPC.

-- cmd to report if toon has any of these items.

-- cmd to auto hand in these items.

-- xxx later: can also be used for L65/l70 spell hand ins ? (if "item reward" is in spell book ?)

-- xxx later: can this replace talos.mac ?

local rules = {
    ["Nerask"] = { --- XXX nearby NPC name
        -- OOW T2 Silk
        ["wiz"] = { -- XXX: class filter

            -- XXX item reward = hand in items
            ["Academic's Robe of the Arcanists"]      = {"Jayruk's Vest",                    "3|Piece of Vrenlar Fruit"}, -- XXX 3x fruit
            ["Academic's Pants of the Arcanists"]     = {"Patorav's Amulet",                 "3|Softened Feran Hide"},
            ["Academic's Slippers of the Arcanists"]  = {"Muramite Cruelty Medal",           "2|Ikaav Tail"},
            ["Academic's Cap of the Arcanists"]       = {"Patorav's Walking Stick",          "2|Bar of Nashtar Berry Soap"},
            ["Academic's Sleeves of the Arcanists"]   = {"Lenarsk's Embossed Leather Pouch", "2|Spool of Balemoon Silk"},
            ["Academic's Gloves of the Arcanists"]    = {"Makyah's Axe",                     "2|Kuuan Whetstone"},
            ["Academic's Wristband of the Arcanists"] = {"Riftseeker Heart",                 "2|Riftseeker Trinket"}, -- XXX also 2x Wrist rewards
        },
    },
}