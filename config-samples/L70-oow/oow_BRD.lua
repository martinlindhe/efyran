local settings = { }

settings.debug = true

settings.swap = {   -- XXX implement
    -- Notched Blade of Bloodletting (1hs, 37 dmg, 24 delay, 15 bonus) - anguish amv
    main = "Blade of Vesagran|Mainhand/Notched Blade of Bloodletting|Offhand",

    noriposte = "Lute of False Worship|Mainhand/Shield of the Planar Assassin|Offhand",

    fishing = "Fishing Pole|Mainhand",

    -- for mpg group weaponry:
    slashdmg = "Chaotic Black Scimitar|Mainhand/Edge of Eternity|Offhand",
    piercedmg = "Blade of Vesagran|Mainhand/Blade of Annihilation Anthems|Offhand",
    bluntdmg = "Despair|Mainhand/Frostcaller|Offhand",
}

settings.illusions = {
    default         = "scarecrow",
    halfling        = "Fuzzy Foothairs",
    scarecrow       = "Guise of Horror",
}

settings.self_buffs = {
    "Shadowsong Cloak", -- Harmonize (increase singing skill by 9)
}

settings.healing = {
    life_support = {
        "Shield of Notes/HealPct|30",
        "Deftdance Discipline/HealPct|20",
        "Distillate of Divine Healing XI/HealPct|8",
    }
}

settings.assist = {
    type = "Melee", -- XXX "Ranged",  "Off"
    ranged_distance = 100,
    engage_at = 98,  -- XXX implement!

    abilities = {
        "Boastful Bellow",
    },

    quickburns = {-- XXX implememt !!!
        -- epic 1.5: slot 9: spell crit  8%, slot 10: dot crit  8%, slot 12: accuracy 130% (Prismatic Dragon Blade)
        -- epic 2.0: slot 9: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140% (Blade of Vesagran )
        "Blade of Vesagran",

        -- oow T1 bp: increase double attack by  30% for 12s, 5 min reuse (Traveler's Mail Chestguard)
        -- oow T2 bp: increase double attack by 100% for 24s, 5 min reuse (Farseeker's Plate Chestguard of Harmony)
        "Farseeker's Plate Chestguard of Harmony",

        -- Lxx Dance of Blades AA
        "Dance of Blades",

        --"Cacophony",         -- Lxx Cacophony AA (DODH)

        --"Song of Stone",         -- Lxx Song of Stone AA (DODH)

        -- L70 Dance of a Thousand Blades (dodh quest, 33 min reuse)
        "Thousand Blades",
    },

    longburns = {-- XXX implememt !!!
        -- L60 Puretone Discipline (timer 3, 1h7min reuse)
        "Puretone Discipline",
    },
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
    general = {
        -- TANK SONGS (Niv's Harmonic): Spela, Sophee

        "Selo's Accelerating Chorus", -- PERCUSSION - Selo's Accelerating Chorus
        "Psalm of Veeshan", -- SINGING - resists + ac + ds
        "Verse of Vesagran", -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "War March of Muram", -- BRASS - atk, ds
        "Niv's Harmonic",     -- SINGING - spellshield, ac

        -- STRINGED - mana regen (AE 60 range)
        -- "Chorus of Life",
    },

    levitate = {
        -- tank levitate
        "Agilmente's Aria of Eagles",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "War March of Muram",
        "Niv's Harmonic",
        --"Chorus of Life",
    },

    nods = {
        "Selo's Accelerating Chorus",
        "Purifying Chorus/Gem|2", -- magic, poison, disease & ac buff instead of Psalm of Veeshan
        "Niv's Harmonic",
        "Verse of Vesagran",
        -- "Chorus of Life",
    },

    eb = {
        "Tarew's Aquatic Ayre/Gem|7",
        "Selo's Accelerating Chorus",
        "Psalm of Veeshan",
        "Verse of Vesagran",
        "Niv's Harmonic",
        -- "Chorus of Life",
    },

    da = {
        -- L60 Kazumi's Note of Preservation
        "Kazumi's Note of Preservation/Gem|7",
    },

    fear = {
        -- L26 Angstlich's Appalling Screech (ae range 25, fear to L52)
        -- L56 Song of Midnight (ae range 35, fear to L52, sow mobs)
        -- L62 Angstlich's Echo of Terror (ae range 25, fear to L60)
        -- L67 Angstlich's Wail of Panic (ae range 25, fear to L65)
        "Angstlich's Wail of Panic/Gem|7",
    },

    travel = {
        -- L05 Selo's Accelerando (20-65% speed, 0.3 min, slower than SoW at level 14)
        -- L49 Selo's Accelerating Chorus (64-65% speed, 2.5 min)
        -- L51 Selo's Song of Travel (65% speed, invis, levi, 0.3 min)
        "Selo's Song of Travel",
    },

    invis = {
        -- for no-levi zones like potime
        -- L19 Shauri's Sonorous Clouding
        "Shauri's Sonorous Clouding/Gem|7",
    },

    pbae = {
        -- L02 Chords of Dissonance (stringed, dd if target not moving)
        -- L18 Denon's Disruptive Discord (brass, dd+ac debuff)
        -- L48 Selo's Chords of Cessation (stringed, dd+haste debuff 30%)
        -- L62 Melody of Mischief (stringed, dd+haste debuff 45%)
        -- L67 Zuriki's Song of Shenanigans (stringed, dd+haste debuff 45%)
        "Zuriki's Song of Shenanigans/Gem|7",
        "Melody of Mischief/Gem|8",
        "Selo's Accelerating Chorus",
        "Psalm of Veeshan", -- DS
    },
}

return settings
