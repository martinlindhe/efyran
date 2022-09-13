local settings = { }

settings.swap = {
    ["main"] = "",
}

settings.self_buffs = {
}

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
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
        "Selo's Accelerating Chorus", -- PERCUSSION - run speed
        "Psalm of Veeshan", -- SINGING - resists + ac + ds
        "Verse of Vesagran", -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "Arcane Aria", -- WIND - spell nuke proc
        "Chorus of Life", -- NOTE: Garotta+Alethea does ae mana regen song!
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
