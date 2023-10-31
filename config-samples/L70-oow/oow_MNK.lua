local settings = { }

settings.swap = { -- XXX impl
    main = "Transcended Fistwraps of Immortality|Mainhand/Hammer of Rancorous Thoughts|Offhand/Symbol of the Overlord|Ranged",
    noks = "Earthen Fist|Mainhand",
    noriposte = "Fishing Pole|Mainhand/Bulwark of Lost Souls|Offhand",
}

settings.illusions = {
    default         = "halfling",
    halfling        = "Fuzzy Foothairs",
}

settings.self_buffs = {
    "Timestone Adorned Ring", -- proc buff: Soul Claw Strike (slot 1: proc)
    --"Symbol of the Planemasters", -- (slot 1: Pestilence Shock buff, potime)
    "Shimmering Bauble of Trickery/Shrink", -- 1s cast x 5 times for 0.62 height
}

settings.healing = {
    life_support = {
        "Mend/HealPct|50",
        "Distillate of Divine Healing XI/HealPct|10",
        "Feign Death/HealPct|5",
    },
}


settings.assist = {
    type = "Melee",
    engage_at = 98,  -- XXX implement!

    abilities = {
        -- kicks:
        -- L20 Eagle Strike
        -- L25 Dragon Punch (aka Tail Rake but ability name is still Dragon Punch)
        -- L30 Flying Kick
        "Dragon Punch",
        --"Flying Kick",

        -- punch:
        -- L10 ??? Tiger Claw
        "Tiger Claw",

        -- timer 8:
        -- L05 Elbow Strike
        "Elbow Strike",

        -- L6x Eye Gouge Rank 3 AA (id:6075, resist adj -31, 1 hate, -90 atk)
        "Eye Gouge",

        -- oow bp t1: Stillmind Tunic (cancel beneficial buffs)
        -- oow bp t2: Fiercehand Shroud of the Focused (cancel beneficial buffs)
        -- NOTE: only Laser+Azoth uses this on each fight
        "Fiercehand Shroud of the Focused",

        "Crippling Strike/MaxHP|15", -- snare

        "Imitate Death/PctAggro|99/HealPct|70",
    },

    quickburns = {
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
