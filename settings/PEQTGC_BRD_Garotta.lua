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

settings.healing = {
    ["life_support"] = {
        "Shield of Notes/HealPct|30",
        "Deftdance Discipline/HealPct|20",
        "Distillate of Divine Healing XI/HealPct|8",
    }
}

settings.assist = {
    ["type"] = "Melee",
    ["stick_point"] = "Behind",
    ["ranged_distance"] = 100,
    ["engage_percent"] = 98,

    ["abilities"] = {
        "Boastful Bellow",
    },

    ["quickburns"] = {
        -- (epic 1.5: slot 9: spell crit  8%, slot 10: dot crit  8%, slot 12: accuracy 130%) Prismatic Dragon Blade
        -- (epic 2.0: slot 9: spell crit 12%, slot 10: dot crit 12%, slot 12: accuracy 140%) Blade of Vesagran
        "Blade of Vesagran",

        "Dance of Blades",
        "Cacophony",

        -- oow T2 bp: increase double attack by 100% for 24s, 5 min reuse (Farseeker's Plate Chestguard of Harmony)
        "Farseeker's Plate Chestguard of Harmony",

        "Song of Stone",
    },

    ["longburns"] = {
        "Thousand Blades",
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
