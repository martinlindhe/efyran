local settings = { }

settings.debug = true

settings.swap = {
    ["main"] = "Nightshade, Blade of Entropy|Mainhand/Aneuk Dagger of Eye Gouging|Offhand/Sorrowmourn Stone|Ranged",

    ["bfg"] = "Breezeboot's Frigid Gnasher|Mainhand",

    ["ranged"] = "Plaguebreeze|Ranged",

    ["noriposte"] = "Fishing Pole|Mainhand/Muramite Aggressor's Bulwark|Offhand",

    ["fishing"] = "Fishing Pole|Mainhand",

    -- for mpg group weaponry:
    ["slashdmg"] = "Jagged Blade of Ice|Mainhand/Great Blade of Storms|Offhand", -- FIXME need better 1h slashing
    ["bluntdmg"] = "Mace of Tortured Nightmares|Mainhand/Hammer of Rancorous Thoughts|Offhand",
    ["piercedmg"] = "Nightshade, Blade of Entropy|Mainhand/Aneuk Dagger of Eye Gouging|Offhand",
}

settings.self_buffs = {
    -- "Tiny Bone Bracelet", -- skeleton illusion

    -- poisons:
    -- L65 Bite of the Shissar XI (vendor bought in PoK)
    -- L70 Bite of the Shissar XII (vendor bought in PoK)
    "Bite of the Shissar XII/Zone|anguish",

    -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DON'T STACK WITH Form of Defense
    "Necklace of the Steadfast Spirit",

    --"Hanvar's Hoop", -- Form of Defense III (slot 6: immunity, slot 10: 81 ac)

    -- XXX dont get it to work 22 feb:
    -- 30% haste clicky, 72 min
    -- "Stanos' Wicked Gauntlets",

    "Bracelet of the Shadow Hive/Shrink",
}

settings.combat_buffs = { -- XXX combat buffs:
    "Thief's Eyes/Kniven/MinEnd|10",        -- XXX MinEnd
}

settings.healing = {
    ["life_support"] = {
        -- Lxx Counterattack Discipline (ripostes every blow, 40 min reuse) - XXX does not work
        -- L55 Nimble Discipline (avoid most attacks, 21 min reuse)
        "Nimble Discipline/HealPct|45",

        "Distillate of Divine Healing XI/HealPct|10",

        --"Stealthy Getaway/HealPct|10",         -- L70 Stealthy Getaway AA  (DoDH)

        --"Mind Shock/HealPct|20", -- potion, 15 min, add proc: Mind Shock

        "Glyph of Stored Life/HealPct|5|Zone|anguish", -- Expendable AA
    }
}

settings.assist = {
    ["type"] = "Melee",
    ["ranged_distance"] = 80,
    ["engage_percent"] = 98,
    ["abilities"] = {
        "Escape/PctAggro|99", -- L59 Escape AA
        "Backstab",
    },
    ["quickburns"] = {
        -- oow T1 bp: (increase 1hb dmg   taken by 20% for 12s, 5 min reuse) Darkraider's Vest
        -- oow T2 bp: (increase all melee taken by 20% for 24s, 5 min reuse) Whispering Tunic of Shadows
        "Whispering Tunic of Shadows",

        -- EPIC 1.5: Fatestealer (35% triple backstab, Assassin's Taint Strike proc)
        -- EPIC 2.0: Nightshade, Blade of Entropy (45% triple backstab, Deceiver's Blight Strike proc)
        "Nightshade, Blade of Entropy",

        -- timer 5:
        -- L70 Frenzied Stabbing Discipline (15 min reuse)
        "Frenzied Stabbing Discipline",

        -- timer 2:
        -- L57 Kinesthetics Discipline (5 min reuse)
        -- L59 Duelist Discipline (22 min reuse, 14 min reuse with epic 2.0)
        "Duelist Discipline",

        -- timer 3:
        -- L54 Deadeye Discipline
        -- L58 Blinding Speed Discipline
        -- L63 Deadly Precision Discipline
        -- L65 Twisted Chance Discipline (22 min reuse)
        "Twisted Chance Discipline",
    },
    ["longburns"] = {},
    ["fullburns"] = {
        "Glyph of Courage", -- Expendable AA (increase dmg)
    },
}

settings.rogue = { -- XXX implement and rearrange settings
--[[
Auto-Hide (On/Off)=Off
Auto-Evade (On/Off)=On
Evade PctAggro=75
Sneak Attack Discipline=
PoisonPR=Bite of the Shissar XII
PoisonFR=Solusek's Burn XII
PoisonCR=E`ci's Lament XII

; timer 8 (sneak attack disc):
; L05 Elbow Strike
; L52 Thief's Vengeance
; L65 Kyv Strike
; L65 Ancient: Chaos Strike
; L69 Daggerfall
; L70 Razorarc
;Sneak Attack Discipline=Razorarc/MinEnd|50

; to skill up:
;Sneak Attack Discipline=Pick Pockets
]]--
}

return settings
