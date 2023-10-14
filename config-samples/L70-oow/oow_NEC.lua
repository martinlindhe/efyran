local settings = { }

settings.swap = {
    main = "Deathwhisper|Mainhand",
    fishing = "Fishing Pole|Mainhand",
    melee = "Deathwhisper|Mainhand", -- 1hb
}

settings.gems = {
    ["Dread Pyre"] = 1, -- fire dot
    ["Grip of Mori"] = 2, -- disease nuke + debuff
    ["Acikin"] = 3, -- poison nuke
    ["Fang of Death"] = 4, -- lifetap dod

    ["Dark Salve"] = 6, -- pet heal
    ["Scent of Midnight"] = 7, -- debuff
    ["Mind Flay"] = 8, -- steal mana from target, give to group
    ["Embracing Darkness"] = 9, -- snare
}

settings.illusions = {
    default         = "halfling",
    halfling        = "Fuzzy Foothairs",
}

settings.self_buffs = {
    -- Form of Rejuvenation III (slot 12: 12 hp/tick, slot 6: immunity)
    "Warped Mask of Animosity",

    -- lich (dont stack with clarity line):
    -- L70 Grave Pact (72 mana/tick, cost 60 hp/tick, skeleton, PoR expansion)
    "Grave Pact",
}

settings.healing = {
    life_support = {
        -- invulnerability:
        -- Lxx Harmshield
        -- L58 Quivering Veil of Xarn (invulnerability 0.3 min, +150 hp)
        --"Quivering Veil of Xarn/Gem|7/HealPct|33",

        -- feign death:
        -- Lxx Feign Death (87% success, 12 sec recast)
        -- L52 Comatose (87% success, 8 sec recast)
        -- L60 Death Peace (98% success, 4s recast)
        -- L6x Death Peace AA Rank 1 (???)
        -- L76 Death Peace AA Rank 2 (???)
        "Death Peace/HealPct|35",

        "Distillate of Divine Healing XI/HealPct|10",
    }
}

settings.assist = {
    nukes = {
        main = {
            -- poison nukes:
            -- L21 Shock of Poison (171-210 dmg)
            -- L32 Torbas' Acid Blast (314-332 dmg)
            -- L54 Torbas' Venom Blast (688 dmg, cost 251 mana)
            -- L60 Ancient: Lifebane (1050 dmg)
            -- L61 Neurotoxin (1325 hp, cost 445 mana)
            -- L66 Acikin (1823 hp, cost 556 mana)
            -- L68 Call for Blood (1770 dmg, cost 568 mana) - adjusts dot dmg randomly
            -- L?? Ancient: Touch of Orshilak XXXXXX
            "Acikin/NoAggro/MinMana|70",

            -- mana drain:
            -- L58 Mind Wrack (-300 mana)
            -- L70 Mind Flay (-360 mana)
            "Mind Flay/MaxMana|95",

            -- snare dots:
            -- L04 Clinging Darkness (8 hp/tick, 24-30% snare, 0.8 min, cost 20 mana)
            -- L11 Engulfing Darkness (11 hp/tick, 40% snare, 1.0 min, cost 60 mana)
            -- L27 Dooming Darkness (20 hp/tick, 48-59% snare, 1.5 min, cost 120 mana)
            -- L47 Cascading Darkness (72 hp/tick, 60% snare, 1.6 min, cost 300 mana)
            -- L59 Devouring Darkness (123 hp/tick, 69-75% snare, 1.3 min, cost 400 mana)
            -- L63 Embracing Darkness (resist adj -20, 68-70 hp/tick, 75% snare, 2.0 min, cost 200 mana)
            -- L68 Desecrating Darkness (resist adj -20, 96 hp/tick, 75% snare, 2.0 min, cost 248 mana)
            -- Lxx Encroaching Darkness AA (damage free snare) (SoD)
            "Embracing Darkness/Gem|2/MaxHP|15/Not|raid",
        }
    },

    dots = {
        -- poison dots:
        -- L04 Poison Bolt (10 hp/tick, poison)
        -- L34 Venom of the Snake (x)
        -- L36 Chilling Embrace (100-114 hp/tick, poison)
        -- L65 Blood of Thule (350-360 hp/tick, resist adj -50, poison)
        -- L69 Corath Venom (611 hp/tick, POISON,  resist adj -50, cost 655 mana)
        -- L70 Chaos Venom (473 hp/tick, POISON, resist adj -50, cost 566 mana)

        -- disease dots:
        -- L01 Disease Cloud (x)
        -- L13 Heart Flutter (18-22 hp/tick, -13-20 str, -7-9 ac)
        -- L35 Scrounge (x)
        -- L40 Asystole (x)
        -- L61 Dark Plague (182-190 hp/tick, resist adj -50, disease, cost 340 mana)
        -- L66 Chaos Plague (247-250 hp/tick, resist adj -50, disease)
        -- L67 Grip of Mori (194-197 hp/tick, -63-65 str, -35-36 ac, cost 325 mana)
        "Grip of Mori",

        -- magic dots:
        -- L39 Dark Soul (x)
        -- L51 Splurt (x)
        -- L63 Horror (432-450 hp/tick, resist adj -30, magic, cost 450 mana)
        -- L67 Dark Nightmare (591 hp/tick, resist adj -30, magic, cost 585 mana)
        -- L70 Ancient: Curse of Mori (639 hp/tick, resist adj -30, magic, cost 625 mana)
        "Dagger of Death", -- tacvi class clicky with Horror dot

        -- fire dots:
        -- L10 Heat Blood (28-43 hp/tick)
        -- L28 Boil Blood (67 hp/tick)
        -- L47 Ignite Blood (X)
        -- L58 Pyrocruor (156-166 hp/tick)
        -- L65 Night Fire (335 hp/tick, resist adj -100)
        -- L69 Pyre of Mori (419 hp/tick, resist adj -100, cost 560 mana)
        -- L70 Dread Pyre (956 hp/tick, resist adj -100, cost 1093 mana)
        "Dread Pyre/MaxTries|2/MinMana|40",

        -- duration taps (dot + heal):
        -- L09 Leech (8 hp/tick, MAGIC, resist adj -200)
        -- L29 Vampiric Curse (21 hp/tick, MAGIC, resist adj -200)
        -- L45 Auspice (30 hp/tick, DISEASE, resist adj -200)
        -- L62 Saryrn's Kiss (191-200 hp/tick, MAGIC, resist adj -200, magic, cost 550 mana)
        -- L65 Night Stalker (122 hp/tick, DISEASE, resist adj -200, cost 950 mana)
        -- L65 Night's Beckon (220 hp/tick, MAGIC resist adj -200, cost 605 mana)
        -- L68 Fang of Death (370 hp/tick, MAGIC, resist adj -200, cost 750 mana)
    },

    debuffs = {
        -- scent debuff:  -- XXX should be debuffs_on_command
        -- L10 Scent of Dusk (-6-9 fr, -6-9 pr, -6-9 dr)
        -- L37 Scent of Darkness (-23-27 fr, -23-27 pr, -23-27 dr)
        -- L52 Scent of Terris (-33-36 fr, -33-36 pr, -33-36 dr, poison)
        -- L68 Scent of Midnight (-55 dr, -55 pr, disease, resist adj -200)
        "Scent of Midnight/MaxTries|2",
    },

    quickburns = {
        -- Wake the Dead Rank 1-3 (60, 75, 90 sec)
        -- Army of the Dead Rank 1-x (3 for 60 sec, 4 for 75 sec, 5 for 90 sec)
        "Army of the Dead", -- XXX "MinCorpses|4" filter to not use it when no corpses around.

        -- oow tier 1 bp (increase dot dmg)
        "Deathcaller's Robe",

        -- epic 1.5: Soulwhisper (Servant of Blood, swarm pet)
        -- epic 2.0: Deathwhisper (Guardian of Blood, swarm pet)
        "Deathwhisper",

        "Swarm of Decay", -- 30 min reuse
    },

    -- L20 Word of Shadow (MAGIC, 52-58 hp, aerange 20, recast 9s, cost 85 mana)
    -- L27 Word of Spirit (MAGIC, 91-104 hp, aerange 20, recast 9s, cost 133 mana)
    -- L36 Word of Souls (MAGIC, 138-155 hp, aerange 20, recast 9s, cost 171 mana)
    pbae = {
        "Word of Souls/Gem|9",
        "Word of Spirit/Gem|8",
        "Word of Shadow/Gem|7",
    },
}

settings.pet = {
    heals = {
        -- pet heals:
        -- L07 Mend Bones (22-32 hp)
        -- L26 Renew Bones (121-175 hp)
        -- L64 Touch of Death (1190-1200 hp, -24 dr, -24 pr, -24 curse, cost 290 mana)
        -- L69 Dark Salve (1635-1645 hp, -28 dr, -28 pr, -28 curse, cost 358 mana)
        -- L6x Replenish Companion AA Rank 1
        -- L69 Replenish Companion AA Rank 3
        -- L73 Chilling Renewal (2420-2440 hp, -34 dr, -34 pr, -34 curse, -8 corruption, cost 504 mana)

        "Replenish Companion/HealPct|40",

        "Dark Salve/HealPct|60",
    },

    buffs = {
        "Glyph of Darkness/MinMana|30", -- pet haste

        "Algae Covered Stiletto/Shrink", -- XXX farm this clicky in powater
    },
}

-- XXX necromancer settings
--[[
[Necromancer]
; lifetaps:
; L01 Lifetap (4-6 hp, cost 8 mana)
; L03 Lifespike (8-12 hp, cost 13 mana)
; L12 Lifedraw (102-105 hp, cost 86 mana)
; L20 Siphon Life (140-150 hp, cost 115 mana)
; L26 Spirit Tap (202-210 hp, cost 152 mana)
; L39 Drain Spirit (314 hp, cost 213 mana)
; L54 Deflux (535 hp, cost 299 mana)
; L59 Touch of Night (708 hp, cost 382 mana)
; L67 Soulspike (1204 hp, cost 563 mana)
; L70 Ancient: Touch of Orshilak (1300 hp, cost 598 mana)
;LifeTap=Deflux/gem|1/HealPct|70

Mana Dump (On/Off)=On

Who to Mana Dump=Stor/95
Who to Mana Dump=Kamaxia/95
Who to Mana Dump=Maynarrd/95
Who to Mana Dump=Helge/95
Who to Mana Dump=Arriane/95
Who to Mana Dump=Gerrald/95
Who to Mana Dump=Hankie/90
Who to Mana Dump=Hybregee/90
Who to Mana Dump=Trams/80
Who to Mana Dump=Kasper/80

; mana dump:
; L21 Rapacious Subvention (60 mana, cost 200 mana)
; L43 Covetous Subversion (100 mana, cost 300 mana, 8s recast)
; L56 Sedulous Subversion (150 mana, cost 400 mana, 8s recast)
Mana Dump=Sedulous Subversion/MinMana|5/Gem|4
Mana Dump=Covetous Subversion/MinMana|5/Gem|3
Lich Spell=
LifeTap
]]--

return settings
