local settings = { }


settings.swap = {   -- XXX implement
    -- Notched Blade of Bloodletting (1hs, 37 dmg, 24 delay, 15 bonus) - anguish amv
    ["main"] = "Blade of Vesagran|Mainhand/Notched Blade of Bloodletting|Offhand",

    ["fishing"] = "Fishing Pole|Mainhand",

    ["noriposte"] = "Lute of False Worship|Mainhand/Shield of the Planar Assassin|Offhand",

    -- for mpg group weaponry:
    ["slashdmg"] = "Chaotic Black Scimitar|Mainhand/Edge of Eternity|Offhand",
    ["piercedmg"] = "Blade of Vesagran|Mainhand/Blade of Annihilation Anthems|Offhand",
    ["bluntdmg"] = "Despair|Mainhand/Frostcaller|Offhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- Harmonize (increase singing skill by 9)
    "Shadowsong Cloak",

    -- form of endurance:
    -- Form of Endurance III (slot 6: immunity, slot 5: 270 hp) - Ring of the Beast (anguish)
    "Ring of the Beast",

    -- Form of Defense III (slot 6: immunity, slot 10: 81 ac)
    --"Hanvar's Hoop",

    -- Savage Guard (+25 atk, slot 5)
    "Irestone Band of Rage",

    -- mana pool clicky:
    -- Eye of Dreams (slot 4: 400 mana pool, potime)
    --"Eye of Dreams",
}

settings.healing = { -- XXX implement
    ["life_support"] = { -- XXX implement
        "Shield of Notes/HealPct|30/CheckFor|Resurrection Sickness",
        "Deftdance Discipline/HealPct|20/CheckFor|Resurrection Sickness",
        "Distillate of Divine Healing XI/HealPct|8/CheckFor|Resurrection Sickness",
    }
}

settings.assist = {
    ["type"] = "Melee", -- XXX "Ranged",  "Off"
    ["stick_point"] = "Behind",
    ["melee_distance"] = 12,
    ["ranged_distance"] = 100,
    ["engage_percent"] = 98,  -- XXX implement!

    ["abilities"] = { -- XXX implememt !!!
        "Boastful Bellow",
    },

    ["quickburns"] = {-- XXX implememt !!!
        -- (epic 1.5: slot 9: spell crit  8%, slot 10: dot crit  8%, slot 12: accuracy 130%) Prismatic Dragon Blade
        -- (epic 2.0: slot 9: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140%) Blade of Vesagran 
        "Blade of Vesagran",

        "Dance of Blades",
        "Cacophony",

        -- (oow T1: increase double attack by  30% for 12s, 5 min reuse) Traveler's Mail Chestguard 
        -- (oow T2: increase double attack by 100% for 24s, 5 min reuse) Farseeker's Plate Chestguard of Harmony 
        "Farseeker's Plate Chestguard of Harmony",

        "Song of Stone",
    },

    ["longburns"] = {-- XXX implememt !!!
        "Thousand Blades",
        "Puretone Discipline",
    },
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
        -- "Chorus of Life/Gem|1",
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

    ["pbae"] = {
        -- L02 Chords of Dissonance (stringed, dd if target not moving)
        -- L18 Denon's Disruptive Discord (brass, dd+ac debuff)
        -- L48 Selo's Chords of Cessation (stringed, dd+haste debuff 30%)
        -- L62 Melody of Mischief (stringed, dd+haste debuff 45%)
        -- L67 Zuriki's Song of Shenanigans (stringed, dd+haste debuff 45%)
        "Melody of Mischief/Gem|7",
        "Zuriki's Song of Shenanigans/Gem|8",
        "Selo's Accelerating Chorus/Gem|4",
        "Chorus of Life/Gem|1",
    }

}

return settings