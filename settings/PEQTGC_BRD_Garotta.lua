local settings = { }

settings.swap = { -- XXX impl
    -- Chaotic Black Scimitar (1hs 26 dmg, 21 delay, 15 bonus)
    -- Prismatic Dragon Blade (1hp 24 dmg, 22 delay, 15 bonus)
    ["main"] = "Blade of Vesagran|Mainhand/Notched Blade of Bloodletting|Offhand",

    ["fishing"] = "Fishing Pole|Mainhand",

    ["noriposte"] = "Trithcink|Mainhand/Muramite Aggressor's Bulwark|Offhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    -- Harmonize (increase singing skill by 9)
    "Shadowsong Cloak",

    -- Savage Guard (+25 atk, slot 5)
    "Irestone Band of Rage",

    -- form of endurance:
    -- Form of Endurance III (slot 5: 270 hp) - Ring of the Beast (anguish)
    "Ring of the Beast",

    -- mana pool clicky:
    -- Eye of Dreams (slot 4: 400 mana pool, potime)
    --"Eye of Dreams",
}

settings.healing = { -- XXX implement
    ["life_support"] = {
        "Shield of Notes/HealPct|30/CheckFor|Resurrection Sickness",
        "Deftdance Discipline/HealPct|20/CheckFor|Resurrection Sickness",
        "Distillate of Divine Healing XI/HealPct|8/CheckFor|Resurrection Sickness",
    }
}

settings.assist = {
    ["type"] = "Melee", -- XXX "Ranged",  "Off"
    ["stick_point"] = "Behind",
    --["melee_distance"] = 12,
    ["ranged_distance"] = 100,
    ["engage_percent"] = 98,  -- XXX implement!

    ["abilities"] = {
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
        -- CASTER SONGS (Arcane Aria): Garotta, Alethea, Moola

        -- PERCUSSION - Selo's Accelerating Chorus
        "Selo's Accelerating Chorus/Gem|8",

        -- SINGING - resists + ac + ds:
        "Psalm of Veeshan/Gem|2",

        -- WIND - Verse of Vesagran (mitigate melee & spell by 5% for 450 dmg)
        "Verse of Vesagran/Gem|3",

        -- WIND - spell nuke proc
        "Arcane Aria/Gem|6",

        -- NOTE: Garotta+Alethea does ae mana regen song!
        "Chorus of Life/Gem|1",
    },

    ["levitate"] = {
        -- caster levitate
        "Agilmente's Aria of Eagles/Gem|7",
        "Psalm of Veeshan/Gem|2",
        "Verse of Vesagran/Gem|3",
        "Arcane Aria/Gem|6",
        "Chorus of Life/Gem|1",
    },

    ["nods"] = {
        "Selo's Accelerating Chorus/Gem|8",
        "Purifying Chorus/Gem|2",
        "Verse of Vesagran/Gem|3",
        "Arcane Aria/Gem|6",
        "Chorus of Life/Gem|1",
    },

    ["eb"] = {
        "Tarew's Aquatic Ayre/Gem|7",
        "Selo's Accelerating Chorus/Gem|8",
        "Psalm of Veeshan/Gem|2",
        "Arcane Aria/Gem|6",
        "Chorus of Life/Gem|1",
    },

    ["da"] = {
        "Kazumi's Note of Preservation/Gem|7",
    },

    ["fear"] = {
        "Angstlich's Wail of Panic/Gem|7",
    },

    ["travel"] = {
        "Selo's Song of Travel/Gem|9",
    },

    ["invis"] = {
        "Shauri's Sonorous Clouding/Gem|7",
    },

    ["pbae"] = {
        "Melody of Mischief/Gem|7",
        "Zuriki's Song of Shenanigans/Gem|8",
        "Selo's Accelerating Chorus/Gem|4",
        "Chorus of Life/Gem|1",
    }
}

return settings
