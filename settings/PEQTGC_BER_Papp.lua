local settings = { }

settings.swap = {   -- XXX implement
    ["main"] = "Vengeful Taelosian Blood Axe|Mainhand",
    --["noks"] = "Crozier of Venom|Mainhand", -- XXX need weak weapon
    ["noriposte"] = "Fishing Pole|Mainhand/Bulwark of Lost Souls|Offhand",
}

settings.self_buffs = {
    "Fuzzy Foothairs",
    "Veil of Intense Evolution", -- Furious Might (slot 5: 40 atk)
    --"Hanvar's Hoop", -- Form of Defense III (slot 6: immunity, slot 10: 81 ac)
}

settings.healing = {
    ["life_support"] = {
        --"Desperation/HealPct|40", -- L70 Desperation AA, 22 min reuse - more dmg the closer to death
        "Reckless Discipline/HealPct|30", -- L56 Reckless Discipline (increase riposte rate)
        "Distillate of Divine Healing XI/HealPct|8",
    }
}


-- XXX IMPL COMBAT BUFFS:
-- L68 Cry Havoc (id 8003: group 100% melee crit chance. 1 min. works with TGB)
--Combat Buff=Cry Havoc/Blod/MinEnd|10

settings.assist = {
    ["type"] = "Melee",
    ["engage_percent"] = 98,
    ["ranged_distance"] = 60,

    ["abilities"] = {
        "Frenzy",
        --"Kick",
        "Disarm",
        "Destroyer's Volley",
        "Baffling Strike/PctAggro|90",
    },

    ["quickburns"] = {
        -- EPIC 2.0: Vengeful Taelosian Blood Axe (+100 str, +100 str cap, 300% melee crit chance, 100 hot heal)
        --"Vengeful Taelosian Blood Axe", -- XXX get epic

        -- oow T1 bp: Ragebound Chain Chestguard (increase melee chance to hit by 40% for 12s)
        -- oow T2 bp: Wrathbringer's Chain Chestguard of the Vindicator
        --"Ragebound Chain Chestguard", -- XXX get t2

        -- L6x Blood Pact AA, 15 min reuse
        --"Blood Pact",

        -- timer 8:
        -- L65 Ancient: Cry of Chaos: +60 atk to group
        "Ancient: Cry of Chaos",

        -- timer 3:
        -- L54 Cleaving Rage Discipline (timer 3) - every hit a critical
        -- L58 Blind Rage Discipline (increase damage)
        -- L60 Burning Rage Discipline (timer 3)
        "Cleaving Rage Discipline",

        -- L70 Vengeful Flurry Discipline (timer 5)
        "Vengeful Flurry Discipline",

        -- L66 Unpredictable Rage Discipline (timer 6)
        "Unpredictable Rage Discipline",
    },

    ["longburns"] = {
        -- L6x Untamed Rage AA, 36 min reuse
        -- L70 Cascading Rage AA, 36 min reuse
        --"Cascading Rage",

        -- L65 Cleaving Anger Discipline (timer 2)
        "Cleaving Anger Discipline",

        -- L68 Unflinching Will Discipline (timer 4)
        "Unflinching Will Discipline",

        -- L6x Savage Spirit Rank 1 AA, 1h reuse
        --"Savage Spirit",
    },

}

-- XXX impl:
--[[

[Berserker]
; L66 Axe of the Destroyer (Balanced Axe Components)
Axe Ability=Axe of the Destroyer/Reagent|Balanced Axe Components/CheckFor|80
]]--


return settings
