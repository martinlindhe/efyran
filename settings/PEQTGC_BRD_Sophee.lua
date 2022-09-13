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

    ["Niv's Harmonic"] = 6,
    ["Agilmente's Aria of Eagles"] = 7,
    ["Selo's Accelerating Chorus"] = 8,
    ["Selo's Song of Travel"] = 9,
}

settings.songs = {
    ["general"] = {
        -- TANK SONGS (Niv's Harmonic): Spela, Sophee

        -- PERCUSSION - Selo's Accelerating Chorus
        "Selo's Accelerating Chorus",

        -- SINGING - resists + ac + ds
        "Psalm of Veeshan",

        -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "Verse of Vesagran",

        -- BRASS - atk, ds
        "War March of Muram",

        -- SINGING - spellshield, ac
        "Niv's Harmonic",

        -- STRINGED - mana regen (AE 60 range)
        -- "Chorus of Life",
    },

    ["levitate"] = {
        -- tank levitate
        "Agilmente's Aria of Eagles",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "War March of Muram",
        "Niv's Harmonic",
        --"Chorus of Life",
    },

    ["nods"] = {
        "Selo's Accelerating Chorus",
        "Purifying Chorus/Gem|2", -- magic, poison, disease & ac buff instead of Psalm of Veeshan
        "Niv's Harmonic",
        "Verse of Vesagran",
        -- "Chorus of Life",
    },

    ["eb"] = {
        "Tarew's Aquatic Ayre/Gem|7",
        "Selo's Accelerating Chorus",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "Niv's Harmonic",
        -- "Chorus of Life",
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
        "Selo's Song of Travel",
    },

    ["invis"] = {
        -- for no-levi zones like potime
        -- L19 Shauri's Sonorous Clouding
        "Shauri's Sonorous Clouding/Gem|7",
    },

    ["pbae"] = {
        -- L02 Chords of Dissonance (stringed, dd if target not moving)
        -- L18 Denon's Disruptive Discord (brass, dd+ac debuff)
        -- L48 Selo's Chords of Cessation (stringed, dd+haste debuff 30%)
        -- L62 Melody of Mischief (stringed, dd+haste debuff 45%)
        -- L67 Zuriki's Song of Shenanigans (stringed, dd+haste debuff 45%)
        "Melody of Mischief/Gem|7",
        "Zuriki's Song of Shenanigans/Gem|8",
        "Selo's Accelerating Chorus",
        "Chorus of Life",
    },
}

return settings
