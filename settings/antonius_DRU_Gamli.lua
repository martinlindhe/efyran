local settings = { }

settings.gems = {
    -- XXX
    ["Puravida Rk. II"] = 1,            -- fast heal 3.75s
    ["Adrenaline Surge Rk. III"] = 2,   -- quick heal 1.8s

    ["Succor"] = 10,
    ["Flight of Eagles"] = 11,
    ["Second Life"] = 12,
}

settings.mount = "Glowing Black Drum"

settings.self_buffs = {
    --"Guise of the Deceiver", -- 6s cast. XXX get general AA 'Persistent Illusions (L75, 30 aa cost)
    --"Thick Ice Studded Collar", -- 3s cast,
    --"Ball of Golem Clay",
    "Amulet of Necropotence",

    -- L80 Mask of the Shadowcat (SELF, slot 2: 9 mana/tick)
    "Mask of the Shadowcat",

    -- L78 Viridithorn Coat (SELF, slot 2: 86 AC, slot 3: 23 ds)
    -- L78 Viridithorn Coat Rk. II (SELF, slot 2: 98 AC, slot 3: 26 ds)
    "Viridithorn Coat",

    -- L75 Second Life (SELF, increase divine save by 25%)
    -- L75 Second Life Rk. II (SELF, increase divine save by 29%)
    "Second Life",

    -- L80 Blessing of the Ironwood Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 3371 mana, group)
    "Blessing of the Ironwood",

    "Protection of Seasons",

    "Forbear Corruption",

    -- Geomantra III
    "Crimson Mask of Triumph",

    -- Form of Endurance V
    "Frost-Scarred Giant Hide Bracer/CheckFor|Shadow of Endurance",

    -- Symbol of Vitality (slot 3: increase max hp by 700)
    --"Orb of Duskmold", -- do not stack with CLR symbol

    "Earring of Pain Deliverance/CheckFor|Shadow of Knowledge",

    -- slot 2: 8 ds
    "Coldain Hero's Insignia Ring",

    -- slot 3: block if spell is slot 3 and "All Resists" < 1050, slot 10: 50 fire resist
    "Fractured Werewolf Jawbone",

    "Bracelet of the Shadow Hive/Shrink",
}

settings.group_buffs = {

    -- hp buff:
    -- L49 Protection of Nature (16 ac, 248-25 hp, 2 hp/tick, group)
    -- L59 Protection of the Cabbage (24 ac, 467-485 hp, 6 mana/tick)
    -- L60 Protection of the Glades (24 ac, 470-485 hp, 6 mana/tick, group)
    -- L63 Protection of the Nine (32 ac, 618 hp, 8 mana/tick, cost 725 mana)
    -- L65 Blessing of the Nine (32 ac, 618 hp, 8 mana/tick, cost 1700 mana, group)
    -- L68 Steeloak Skin (43 ac, 772 hp, 9 mana/tick, cost 906 mana)
    -- L70 Blessing of Steeloak (43 ac, 772 hp, 9 mana/tick, cost 2210 mana, group)
    -- L72 Direwild Skin Rk. II (54 ac, 965 hp, 10 mana/tick, cost 1133 mana)
    -- L75 Blessing of the Direwild Rk. II (56 ac, 1004 hp, 10 mana/tick, cost 2873 mana, group)
    -- L77 Ironwood Skin Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 1382 mana)
    -- L80 Blessing of the Ironwood Rk. II (66 ac, 1255 hp, 14 mana/tick, cost 3371 mana, group)
    ["skin"] = {
        "Protection of Nature/MinLevel|1",
        "Protection of the Nine/MinLevel|46",
        "Blessing of the Nine/MinLevel|47",
        "Blessing of Steeloak/MinLevel|62",
        "Blessing of the Direwild/MinLevel|71",     -- XXX unsure of minlevel
        "Blessing of the Ironwood/MinLevel|76",     -- XXX unsure of minlevel
    },

    -- cold & fire resists:
    -- L20 Resist Fire (slot 1: 30-40 fr)
    -- L30 Resist Cold (slot 1: 39-40 cr)
    -- L51 Circle of Winter (slot 1: 45 fr) - don't stack with Protection of Seasons
    -- L52 Circle of Summer (slot 4: 45 cr) - stack with Protection of Seasons
    -- L58 Circle of Seasons (slot 1: 55 fr, slot 4: 55 cr)
    -- L64 Protection of Seasons (slot 1: 72 fr, slot 2: 72 cr)
    ["dru_resists"] = {-- XXX unused
        "Resist Fire/MinLevel|1",
        "Resist Cold/MinLevel|1",
        "Circle of Seasons/MinLevel|44",
        "Protection of Seasons/MinLevel|47",
    },

    -- corruption resists (CLR/DRU):
    -- L73 Resist Corruption Rk. III (slot 1: 20 corruption resist, 36 min, 50 mana)
    -- L78 Forbear Corruption Rk. II (slot 1: 23 corruption resist, 36 min, 50 mana)
    ["corruption"] = { -- XXX unused
        "Resist Corruption/MinLevel|71",    -- XXX unsure of minlevel
        "Forbear Corruption/MinLevel|76",   -- XXX unsure of minlevel
    },

    ["regen"] = {
        -- L34 Regeneration (5-9 hp/tick)
        -- L39 Pack Regeneration (9 hp/tick)
        -- L42 Chloroplast (10-19 hp/tick)
        -- L45 Pack Chloroplast (13-19 hp/tick)
        -- L54 Regrowth (20-38 hp/tick, 18.4 min, cost 300 mana)
        -- L58 Regrowth of the Grove (32-38 hp/tick, 18.4 min, cost 600 mana, group)
        -- L61 Replenishment (40-58 hp/tick, 19.6 min, cost 275 mana)
        -- L63 Blessing of Replenishment (44-58 hp/tick, 19.6 min, cost 650 mana, group)
        -- L66 Oaken Vigor (60-70 hp/tick, 21 min, cost 343 mana)
        -- L69 Blessing of Oak (66-70 hp/tick, 21 min, cost 845 mana, group)
        -- L76 Spirit of the Stalwart Rk. II (105-144 hp/tick, 21 min, cost 523 mana)
        -- L79 Talisman of the Stalwart Rk. II (111-144 hp/tick, 21 min, cost 1238 mana)
        "Chloroplast/MinLevel|1",
        "Regrowth/MinLevel|42",
        "Replenishment/MinLevel|45",
        "Oaken Vigor/MinLevel|62",
        "Spirit of the Stalwart/MinLevel|76", -- XXX unsure of minlevel
    },

    ["ds"] = {
        -- L07 Shield of Thistles (4-6 ds, 15 min)
        -- L17 Shield of Barbs (7-9 ds, 15 min)
        -- L27 Shield of Brambles (10-12 ds, 15 min)
        -- L37 Shield of Spikes (14 ds, 15 min)
        -- L47 Shield of Thorns (24 ds, 15 min) - lands on LV1
        -- L49 Legacy of Spike (24 ds, 15 min, group) - lands on LV1
        -- L58 Shield of Blades (32 ds, 15 min)
        -- L59 Legacy of Thorn (32 ds, 15 min, group)
        -- L63 Shield of Bracken (40 ds, 15 min)
        -- L65 Legacy of Bracken (40 ds, 15 min, group)
        -- L67 Nettle Shield (55 ds, 15 min)
        -- L70 Legacy of Nettles (55 ds, 15 min, group)
        -- L72 Viridfloral Shield Rk. II (69 ds, 15 min)
        -- L75 Legacy of Viridiflora Rk. II (69 ds, 15 min, group)
        -- L77 Viridfloral Bulwark Rk. II (86 ds, 15 min)
        -- L80 Legacy of Viridithorns Rk. II (86 ds, 15 min, group)
        -- NOTE: MAGE DS IS STRONGER
        "Shield of Thorns/MinLevel|1",
        "Shield of Blades/MinLevel|44",
        "Shield of Bracken/MinLevel|46",
        "Nettle Shield/MinLevel|62", -- XXX unsure of minlevel
        "Viridfloral Shield/MinLevel|71",  -- XXX unsure of minlevel
        "Viridfloral Bulwark/MinLevel|76", -- XXX unsure of minlevel
    }

}

--[[
Buff Spell Level   Minimum Target Level
1-50:				Level 1
51: 				Level 40
52-53: 				Level 41
54-55: 				Level 42
56-57: 				Level 43
58-59: 				Level 44
60-61: 				Level 45
62-63: 				Level 46
64-65: 				Level 47
66+: 				Level 62
]]--




settings.healing = { -- XXX implement

    ["life_support"] = { -- XXX implement
        -- L80 Distillate of Divine Healing XIII
        "Distillate of Divine Healing XIII/HealPct|18/CheckFor|Resurrection Sickness",
    },

    ["tanks"] = {
        "Ixtrem", -- SHD
    },

    ["tank_heal"] = {
        "Ancient: Hallowed Light/HealPct|60/MinMana|5",
    },

    ["all_heal"] = {
        -- fast heal:
        -- L29 Greater Healing (280-350 hp, cost 115 mana)
        -- L44 Healing Water (395-425 hp, cost 150 mana)
        -- L51 Superior Healing (500-600 hp, cost 185 mana)
        -- L55 Chloroblast (994-1044 hp, cost 331 mana)
        -- L58 Tunare's Renewal (2925 hp, cost 400 mana - 75% CH)
        -- L60 Nature's Touch (1491 hp, cost 457 mana)
        -- L63 Nature's Infusion (2030-2050 hp, cost 560 mana)
        -- L64 Karana's Renewal (4680 hp, cost 600 mana - 75% CH)
        -- L65 Sylvan Infusion (2441 hp, cost 607 mana, cast time 3.75s)
        -- L68 Chlorotrope (2790-2810 hp, cost 691 mana, cast time 3.75s)
        -- L70 Ancient: Chlorobon (3094 hp, cost 723 mana, cast time 3.75s)
        -- L72 Pure Life Rk. III (3369-3399 hp, cost 794 mana, csat time 3.75s)
        -- L77 Puravida Rk. II (4534-4564 hp, cost 790 mana, cast time 3.75s)
        "Puravida/HealPct|60/MinMana|30",

        -- quick heal:
         -- L75 Adrenaline Surge Rk. III (3681 hp, cost 1050 mana, cast time 1.8s, timer 2. 15s recast)
        "Adrenaline Surge/HealPct|30/MinMana|50",
    },
}

settings.evac = {
    -- L18 Lesser Succor (10.5s cast, cost 150 mana)
    -- L57 Succor (9s cast, cost 100 mana)
    -- Lxx Exodus AA (instant cast, recast time 72 min)
    "Exodus",

    "Succor",
}

return settings
