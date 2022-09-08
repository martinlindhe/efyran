local settings = { }

settings.swap = { -- XXX impl
    ["main"] = "Transcended Fistwraps of Immortality|Mainhand/Hammer of Rancorous Thoughts|Offhand/Symbol of the Overlord|Ranged",
    ["noks"] = "Sap Encrusted Branch|Mainhand",
    ["noriposte"] = "Fishing Pole|Mainhand/Bulwark of Lost Souls|Offhand",
}


settings.self_buffs = {
    "Fuzzy Foothairs",
    "Veil of Intense Evolution", -- Furious Might (slot 5: 40 atk)
    "Timestone Adorned Ring", -- proc buff: Soul Claw Strike (slot 1: proc)
    --"Symbol of the Planemasters", -- (slot 1: Pestilence Shock buff, potime)
    "Prismatic Ring of Resistance", -- Eternal Ward (15 all resists, 45 ac) - stacks with all resist buffs. DONT STACK WITH Form of Defense

    "Ring of the Beast", -- Form of Endurance III (slot 5: 270 hp)

    --"Totem of Elitist Rites/CheckFor|Strength of Tunare", -- Aura of Rage - 20 atk (slot 1)
}

settings.healing = {
    ["life_support"] = {
        "Mend/HealPct|50",
        "Distillate of Divine Healing XI/HealPct|10",
        "Imitate Death/HealPct|6",
        "Feign Death/HealPct|5",
        --"Glyph of Stored Life/HealPct|4", -- Expendable AA
    },
}

-- TODO MNK:
--[[
; L68 Fists of Wu (increase double attack by 6%, 1.0 min)
Combat Buff=Fists of Wu/Azoth/MinEnd|10
Combat Buff=Fists of Wu/Blod/MinEnd|10
Combat Buff=Fists of Wu/Urinfact/MinEnd|10

Cast Aura Combat (On/Off)=On
]]--


settings.assist = {
    ["type"] = "Melee",
    ["melee_distance"] = 12,
    ["engage_percent"] = 98,  -- XXX implement!

    ["abilities"] = {
        "Dragon Punch",
        "Disarm",
        "Tiger Claw",
        "Elbow Strike",

        -- L6x Eye Gouge Rank 3 AA (id:6075, resist adj -31, 1 hate, -90 atk)
        "Eye Gouge",

        -- L69 Dragon Fang disc (cause next attack to do extra magic dmg)
        "Dragon Fang",

        -- NOTE: only Laser+Azoth uses this on each fight
        "Fiercehand Shroud of the Focused",
    },

    ["quickburns"] = {-- XXX implememt !!!
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

    ["fullburns"] = {
        "Glyph of Courage", -- Expendable AA (increase dmg)
    }
}

return settings
