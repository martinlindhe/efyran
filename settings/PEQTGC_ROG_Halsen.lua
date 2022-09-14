local settings = { }

settings.swap = {
}

settings.self_buffs = {
    "Fuzzy Foothairs",

    --"Veil of Intense Evolution", -- Furious Might (slot 5: 40 atk)

    "Bite of the Shissar XII/Reagent|Bite of the Shissar XII",

    --"Necklace of the Steadfast Spirit", -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DON'T STACK WITH Form of Defense
}

settings.combat_buffs = { -- XXX combat buffs:
    "Thief's Eyes/Kniven/MinEnd|10",        -- XXX MinEnd
}

settings.healing = {
    ["life_support"] = {
        "Nimble Discipline/HealPct|45", -- L55 Nimble Discipline (avoid most attacks, 21 min reuse)

        "Distillate of Divine Healing XI/HealPct|8",

        --"Stealthy Getaway/HealPct|10",         -- L70 Stealthy Getaway AA
    }
}

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
    ["abilities"] = {
        --"Escape/PctAggro|99", -- L59 Escape AA
        "Backstab",
    },
    ["quickburns"] = {
        -- oow T2 bp: (increase all melee taken by 20% for 24s, 5 min reuse) Whispering Tunic of Shadows
        --"Whispering Tunic of Shadows",

        -- EPIC 2.0: Nightshade, Blade of Entropy (45% triple backstab, Deceiver's Blight Strike proc)
        --"Nightshade, Blade of Entropy",

        -- timer 5:
        -- L70 Frenzied Stabbing Discipline (15 min reuse)
        "Frenzied Stabbing Discipline",

        -- timer 2:
        -- L59 Duelist Discipline (22 min reuse, 14 min reuse with epic 2.0)
        "Duelist Discipline",

        -- timer 3:
        -- L65 Twisted Chance Discipline (22 min reuse)
        "Twisted Chance Discipline",
    },
    ["longburns"] = {},
    ["fullburns"] = {},
}

return settings