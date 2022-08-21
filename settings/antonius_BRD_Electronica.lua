local settings = { }

settings.gems = {
    ["Cantata of Restoration"] = 12,
}

settings.mount = "Glowing Black Drum"

settings.self_buffs = {
}

settings.songs = {
    ["general"] = {
        -- TANK SONGS (Niv's Harmonic): Spela, Sophee

        -- PERCUSSION - Selo's Accelerating Chorus
        "Selo's Accelerating Chorus/Gem|8",

        -- SINGING - resists + ac + ds
        "Psalm of Veeshan/Gem|2",

        -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "Verse of Vesagran/Gem|3",

        -- BRASS - atk, ds
        "War March of Muram/Gem|4",

        -- SINGING - spellshield, ac
        "Niv's Harmonic/Gem|6",

        -- STRINGED - mana regen (AE 60 range)
        "Cantata of Restoration/Gem|1",
    },

    ["levitate"] = {
        -- tank levitate
        "Agilmente's Aria of Eagles/Gem|7",
        "Psalm of Veeshan/Gem|2",
        "Verse of Vesagran/Gem|3",
        "War March of Muram/Gem|4",
        "Niv's Harmonic/Gem|6",
        --"Chorus of Life/Gem|1",
    },

    ["nods"] = {
        "Selo's Accelerating Chorus/Gem|8",
        -- magic, poison, disease & ac buff instead of Psalm of Veeshan
        "Purifying Chorus/Gem|2",
        "Niv's Harmonic/Gem|6",
        "Verse of Vesagran/Gem|3",
        -- "Chorus of Life/Gem|1",
    },

    ["eb"] = {
        -- for powater, grey, ssra ...
        "Tarew's Aquatic Ayre/Gem|7",
        "Selo's Accelerating Chorus/Gem|8",
        "Psalm of Veeshan/Gem|2",
        "Verse of Vesagran/Gem|3",
        "Niv's Harmonic/Gem|6",
        -- "Chorus of Life/Gem|1",
    },

    ["da"] = {
        -- L60 Kazumi's Note of Preservation
        "Kazumi's Note of Preservation/Gem|7",
    },

    ["fear"] = {
        -- L26 Angstlich's Appalling Screech (ae range 25, fear to L52)
        -- L56 Song of Midnight (ae range 35, fear to L52, sow mobs)
        -- L62 Angstlich's Echo of Terror (ae range 25, fear to L60)
        -- L67 Angstlich's Wail of Panic (ae range 25, fear to L65)
        "Angstlich's Wail of Panic/Gem|7",
    },

    ["travel"] = {
        -- L05 Selo's Accelerando (20-65% speed, 0.3 min, slower than SoW at level 14)
        -- L49 Selo's Accelerating Chorus (64-65% speed, 2.5 min)
        -- L51 Selo's Song of Travel (65% speed, invis, levi, 0.3 min)
        "Selo's Song of Travel/Gem|9",
    },

    ["invis"] = {
        -- for no-levi zones like potime
        -- L19 Shauri's Sonorous Clouding
        "Shauri's Sonorous Clouding/Gem|7",
    },
}

return settings
