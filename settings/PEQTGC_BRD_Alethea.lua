local settings = { }

settings.swap = {   -- XXX implement
    ["main"] = "Blade of Vesagran|Mainhand/Notched Blade of Bloodletting|Offhand",

    ["noriposte"] = "Fishing Pole|Mainhand/Shield of the Planar Assassin|Offhand",

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
    ["engage_percent"] = 98,  -- XXX implement!

    ["abilities"] = {
    },

    ["quickburns"] = {-- XXX implememt !!!
        -- epic 2.0: slot 9: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140%
        "Blade of Vesagran",

        -- Lxx Cacophony AA
        "Cacophony",

        -- Lxx Dance of Blades AA
        "Dance of Blades",

        -- Lxx Song of Stone AA
        "Song of Stone",
    },

    ["longburns"] = {-- XXX implememt !!!
        -- L70 Dance of a Thousand Blades (dodh quest, 33 min reuse)
        "Thousand Blades",

        -- L60 Puretone Discipline (timer 3, 1h7min reuse)
        "Puretone Discipline",
    },
}

settings.gems = {
    ["Chorus of Life"] = 1,
    ["Psalm of Veeshan"] = 2,
    ["Verse of Vesagran"] = 3,
    ["War March of Muram"] = 4,

    ["Arcane Aria"] = 6,
    ["Agilmente's Aria of Eagles"] = 7,
    ["Selo's Accelerating Chorus"] = 8,
    ["Selo's Song of Travel"] = 9,
}

settings.songs = {
    ["general"] = {
        -- CASTER SONGS (Arcane Aria): Garotta, Alethea, Moola

        -- PERCUSSION - Selo's Accelerating Chorus
        "Selo's Accelerating Chorus",

        -- SINGING - resists + ac + ds:
        "Psalm of Veeshan",

        -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "Verse of Vesagran",

        -- WIND - spell nuke proc
        "Arcane Aria",

        -- NOTE: Garotta+Alethea does ae mana regen song!
        "Chorus of Life",
    },

    ["levitate"] = {
        -- caster levitate
        "Agilmente's Aria of Eagles",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "Arcane Aria",
        "Chorus of Life",
    },

    ["nods"] = {
        "Selo's Accelerating Chorus",
        "Purifying Chorus/Gem|2",
        "Verse of Vesagran",
        "Arcane Aria",
        "Chorus of Life",
    },

    ["eb"] = {
        "Tarew's Aquatic Ayre/Gem|7",
        "Selo's Accelerating Chorus",
        "Psalm of Veeshan",
        "Arcane Aria",
        "Chorus of Life",
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

    ["pbae"] = {
        "Melody of Mischief/Gem|7",
        "Zuriki's Song of Shenanigans/Gem|8",
        "Selo's Accelerating Chorus",
        "Chorus of Life",
    },
}

return settings
