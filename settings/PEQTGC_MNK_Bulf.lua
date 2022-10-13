local settings = { }

settings.swap = { -- XXX impl
    --["main"] = "Transcended Fistwraps of Immortality|Mainhand/Flayed Flesh Handwraps|Offhand/Symbol of the Overlord|Ranged",
    ["noks"] = "Death's Head Mace|Mainhand",
    ["noriposte"] = "Fishing Pole|Mainhand/Bulwark of Lost Souls|Offhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",
    "Veil of Intense Evolution", -- Furious Might (slot 5: 40 atk)

    --"Necklace of the Steadfast Spirit", -- Chaotic Ward (20 all resists, 67 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense
}

settings.healing = {
    life_support = {
        "Mend/HealPct|50",
        "Distillate of Divine Healing XI/HealPct|10",
        --"Imitate Death/HealPct|6",
        "Feign Death/HealPct|5",
    },
}

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,

    ["abilities"] = {
        "Flying Kick", -- kick
        "Tiger Claw", -- punch

        -- timer 8:
        -- L05 Elbow Strike
        "Elbow Strike",

        -- L6x Eye Gouge Rank 3 AA (id:6075, resist adj -31, 1 hate, -90 atk)
        --"Eye Gouge",

        "Disarm", -- skillup
    },

    ["quickburns"] = {
        -- epic 2.0: Transcended Fistwraps of Immortality
        "Transcended Fistwraps of Immortality",

        -- timer 10, 22 min reuse:
        "Speed Focus Discipline",

        -- timer 3, 10 min reuse:
        "Thunderkick Discipline",

        -- timer 5:
        -- L70 Heel of Kanji disc (flying kicks will do more dmg)
        "Heel of Kanji",

        -- timer 2, 22 min reuse:
        "Innerflame Discipline",
    },
}

return settings
