local settings = { }

settings.gems = {
    ["Theft of Agony"] = 1,
    ["Theft of Hate"] = 2,
    ["Touch of the Devourer"] = 3,
    ["Ancient: Bite of Muram"] = 4,

    ["Dread Gaze"] = 6,
    ["Decrepit Skin"] = 7,
    ["Terror of Discord"] = 8,
    ["Inruku's Bite"] = 9
}

settings.swap = { -- XXX impl
    ["main"] = "Morguecaller|Mainhand/Shield of the Lightning Lord|Offhand/Screaming Skull of Discontent|Ranged",
    ["bfg"] = "Breezeboot's Frigid Gnasher|Mainhand",
    ["ranged"] = "Plaguebreeze|Ranged",
    ["noriposte"] = "Aged Left Eye of Xygoz|Mainhand/Shield of the Lightning Lord|Offhand",
    ["fishing"] = "Fishing Pole|Mainhand",

    -- for mpg trial of weaponry (group):
    ["slashdmg"] = "Innoruuk's Dark Blessing|Mainhand",
    ["piercedmg"] = "Warspear of Vexation|Mainhand",
    ["bluntdmg"] = "Girplan Hammer of Carnage|Mainhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    "Decrepit Skin", -- shd_combat_innate
    --Combat Buff=Decrepit Skin

    "Ring of the Beast",     -- Form of Endurance III (slot 5: 270 hp)
    "Necklace of the Steadfast Spirit", -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense

    -- PAL/SHD mana regen clicky:
    -- Glyphed Greaves of Conflict ALL/ALL: Aura of Eternity (slot 8: 5 mana regen, slot 10: 5 hp regen)
    -- Pendant of Discord ALL/ALL: Aura of Taelosia (slot 8: 7 mana regen, slot 10: 7 hp regen)
    -- NOTE: NOT ENOUGH BUFF SLOTS
    --"Pendant of Discord",

    --"Pact of Decay", -- shd_lich

    --"Cloak of Retribution", -- ds slot 2
    --"Spined Chain Mail", -- XXX WANT DS slot 3:
    --"Pauldron of Dark Auspices", -- DS slot 4:

    "Shimmering Bauble of Trickery/Shrink",
}

settings.healing = {
    ["life_support"] = {
        "Distillate of Divine Healing XI/HealPct|7",

        -- oow t1 bp: Heartstiller's Mail Chestguard - Lifetap from Weapon Damage (15) for 2 ticks
        -- oow t2: Duskbringer's Plate Chestguard of the Hateful - Lifetap from Weapon Damage (15) for 4 ticks. 5 min reuse
        "Duskbringer's Plate Chestguard of the Hateful/HealPct|35",

        -- timer 3:
        -- L59 Deflection Discipline (12s use, 40m reuse) - block most attacks with shield
        "Deflection Discipline/HealPct|10",

        -- timer 2:
        -- L60 Leechcurse Discipline (42 end upkeep, 24s use, 1h7m reuse) - heal for 100% of all melee dmg
        "Leechcurse Discipline/HealPct|8",

        -- timer 4:
        -- L56 Ichor Guard (absorb 25% melee dmg up to 2500)
        -- L61 Soul Guard (absorb 25% melee dmg up to 6000)
        -- L69 Soul Shield (absorb 25% melee dmg up to 10000, 30s use, 15m reuse)
        "Soul Shield/HealPct|15",

        "Glyph of Stored Life/HealPct|5|Zone|anguish", -- Expendable AA
    },
    ["lifetap"] = { -- XXX implement. was [Shadow Knight].LifeTap in e3
        -- L70 Touch of the Devourer (-740 hp, -200 magic resist, 448 mana, 10s recast)
        "Touch of the Devourer/HealPct|50|MinMana|10",
    },
}

settings.pet = {
    ["auto"] = false,
    ["heals"] = {},
    ["buffs"] = {
        -- pet haste
        -- L69 Rune of Decay (65% haste, 85 str, 22 ac)
        "Rune of Decay/MinMana|50",
    },
}

settings.assist = {
    ["type"] = "Melee",
    ["stick_point"] = "Front",
    --["melee_distance"] = 15,   -- XXX in order to automatically be closer to boss than the rest, allow changing formula "spawn.MaxRangeTo() * 0.75"
    ["taunts"] = { -- XXX impl. used if set
        -- L67 Terror of Discord (1800 hate, instant, unresistable, 60 mana, 6s recast)
        "Terror of Discord",

        -- Lxx Taunt
        -- Lxx Bash
        "Taunt",
        "Bash", -- XXX requires shield equipped.

        -- XXX add taunt spells
    },
    ["ranged_distance"] = 60,
    ["engage_percent"] = 100,  -- XXX implement!

    ["abilities"] = {
        "Disarm",
    },

    ["nukes"] = {
        ["main"] = {
            -- L67 Terror of Discord (1800 hate, 60 mana, instant cast, 6s recast)
            "Terror of Discord",

            -- L70 Theft of Agony (1200 hate, 100 mana, 1.5s cast, 60s recast)
            "Theft of Agony",

            -- duration taps - group heals:
            -- L62 Zevfeer's Bite (-500 disease, 200 hp nuke + group heal)
            -- L65 Ancient: Bite of Chaos (-500 disease, 300 hp nuke + group heal)
            -- L67 Inruku's Bite (-500 disease, 260 hp nuke + group heal)
            -- L70 Ancient: Bite of Muram (-500 disease, 375 hp nuke + group heal, 60s recast)
            "Ancient: Bite of Muram",

            -- L70 Theft of Hate (-130 hp, increase atk)
            "Theft of Hate",
        },
    },

    ["dots"] = { -- XXX implement. was called "DoTs on assist" in e3
        --[[
        [DoTs on Assist]
        ; Encroaching Darkness AA (damage free snare)
        ;Main=Encroaching Darkness/MaxTries|2

        ; duration taps - self heals:
        ; L57 Vampiric Curse (-200 magic, 21 hp/tick self heal)
        ; L62 Bond of Decay (-200 magic, 80 hp/tick self heal)
        ; L66 Bond of Inruku (-200 magic, 135 hp/tick self heal)

        Main=Ancient: Bite of Muram/MinMana|10

        ; disease dots:
        ; L05 Disease Cloud (cost 10, -5 hp/tick)
        ; L36 Heart Flutter (cost 41, -20 str, -9 ac, -22 hp/tick)
        ; L60 Asytole (cost 98, 42s use, -40 str, -18 ac, -62 hp/tick)
        ; L66 Dark Constriction (cost 300, 1m use, -60 str, -27 ac, -100 hp/tick)
        ;Main=Dark Constriction/MaxTries|2/Gem|2/MinMana|10

        Magic=
        Poison=
        Disease=
        ]]--
    },

    ["dots_on_command"] = { -- XXX implement. was called "DoTs on command" in e3
        --[[
        [DoTs on Command]
        Main=
        Magic=
        Poison=
        Disease=
        ]]--
    },

    ["quickburns"] = { -- XXX implememt !!!
        -- oow T2 bp: Duskbringer's Plate Chestguard of the Hateful (Leeching Embrace, melee lifetap 15% heal)
        "Duskbringer's Plate Chestguard of the Hateful",

        -- epic 1.5 (30% accuracy for group, 35% melee lifetap. 10 min reuse) Innoruuk's Voice
        -- epic 2.0 (40% accuracy for group, 50% melee lifetap. 5 min reuse) Innoruuk's Dark Blessing - XXX targets self which makes tanking crap
        "Innoruuk's Dark Blessing"
    },

    ["longburns"] = { -- XXX implememt !!!
        -- timer 1:
        -- L55 Unholy Aura Discipline (cost 900 end, 5m use, 36m reuse) - increase lifetap dmg
        "Unholy Aura Discipline",
    },

    ["pbae"] = {
        "Dread Gaze",
    }
}

return settings
