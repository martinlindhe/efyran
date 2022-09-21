local settings = { }

settings.swap = {   -- XXX implement
    ["main"] = "Blade of Vesagran|Mainhand/Notched Blade of Bloodletting|Offhand",

    ["noriposte"] = "Fishing Pole|Mainhand/Bulwark of Lost Souls|Offhand",

    ["fishing"] = "Fishing Pole|Mainhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",
    "Shadowsong Cloak", -- Harmonize (increase singing skill by 9)
    "Serrated Dart of Energy", -- Savage Guard (+25 atk, slot 5)
}

settings.healing = {
    ["life_support"] = {
        "Shield of Notes/HealPct|30",
        "Deftdance Discipline/HealPct|20",
        "Distillate of Divine Healing XI/HealPct|8",
    }
}

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
    ["abilities"] = {
    },
    ["quickburns"] = {
        -- epic 2.0: slot 9: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140%
        "Blade of Vesagran",

        -- oow T2 bp: increase double attack by 100% for 24s, 5 min reuse
        --"Farseeker's Plate Chestguard of Harmony",

        -- Lxx Cacophony AA
        "Cacophony",

        -- Lxx Dance of Blades AA
        "Dance of Blades",

        -- Lxx Song of Stone AA
        "Song of Stone",
    },
    ["longburns"] = {
        -- L70 Dance of a Thousand Blades (dodh quest, 33 min reuse)
        "Thousand Blades",

        -- L60 Puretone Discipline (timer 3, 1h7min reuse)
        "Puretone Discipline",
    },
}

settings.gems = {
    ["Cantata of Life"] = 1,
    ["Psalm of Veeshan"] = 2,
    ["Verse of Vesagran"] = 3,
    ["War March of Muram"] = 4,

    ["Storm Blade"] = 6,
    ["Agilmente's Aria of Eagles"] = 7,
    ["Selo's Accelerating Chorus"] = 8,
    ["Selo's Song of Travel"] = 9,
}

settings.songs = {
    ["general"] = {
        -- MELEE SONGS (Storm Blade): Gerwulf, Chancer, Saberku, Lynnmary, Crust, Hypert

        -- PERCUSSION - Selo's Accelerating Chorus
        "Selo's Accelerating Chorus/Gem|8",

        -- SINGING - resists + ac + ds:
        "Psalm of Veeshan",

        -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "Verse of Vesagran",

        -- BRASS - atk, ds
        "War March of Muram",

        -- SINGING - slot 1: proc Storm Blade Strike
        "Storm Blade",

        --"Cantata of Life",
    },

    ["levitate"] = {
        -- melee levitate
        "Agilmente's Aria of Eagles/Gem|7",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "War March of Muram",
        "Storm Blade",
        --"Cantata of Life",
    },

    ["nods"] = {
        -- melee nods
        "Selo's Accelerating Chorus/Gem|8",
        -- magic, poison, disease & ac buff instead of Psalm of Veeshan
        "Purifying Chorus/Gem|2",
        "Verse of Vesagran",
        "Storm Blade",
        -- "Cantata of Life",
    },

    ["eb"] = {
        -- melee eb
        "Tarew's Aquatic Ayre/Gem|7",
        "Selo's Accelerating Chorus/Gem|8",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "Storm Blade",
        -- "Cantata of Life",
    },

    ["da"] = {
        "Kazumi's Note of Preservation/Gem|7",
    },

    ["fear"] = {
        "Angstlich's Wail of Panic/Gem|7",
    },

    ["travel"] = {
        "Selo's Song of Travel",
    },

    ["invis"] = {
        "Shauri's Sonorous Clouding/Gem|7",
    },
}

return settings
