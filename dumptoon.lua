-- write current char info to a ini file for later consumption by another tool
--
--
-- raw stats: int str etc, hp mana
-- all item slots and content
-- all bags & bank content (so u can search inventories on resulting webpage)

-- TODO: can we record output from /keys to file?



local mq = require("mq")
require("ezmq")


local timeStart = os.time()

local DUMP_KNOWN_AA = true
local DUMP_SPELLBOOK = true


-- rof2 client:
local SPELLBOOK_SIZE = 720      -- size of spellbook: 8 * 90 pages (RoF2)
local MAX_INV_SLOTS  = 10
local MAX_AUG_SLOTS  = 3

local me = mq.TLO.Me

local settingsRoot = "D:/dev-mq/mqnext-e4-lua/dumptoon"
local iniFile = settingsRoot .. "/Dumptoon."..me.Name()..".ini"
local aaMapFile = settingsRoot .. "/AAMap."..current_server()..".ini"



cmd("/lua stop e4")
drop_all_buffs()
delay(1000)

function writeIni(section, key, val)
    mq.cmdf('/ini %s "%s" "%s" "%s"', iniFile, section, key, val)
end


print("--- DUMP TOON ---")

-- Overview
writeIni("Overview", "Name", me.Name())
writeIni("Overview", "Class", me.Class.ID())
writeIni("Overview", "Race", me.Race.ID())
writeIni("Overview", "Gender", me.Gender())
writeIni("Overview", "Deity", me.Deity.ID())

writeIni("Spawn", "Zone", mq.TLO.Zone.ID())
writeIni("Spawn", "X", me.X())
writeIni("Spawn", "Y", me.Y())
writeIni("Spawn", "Z", me.Z())


-- Bind points
for i = 0, 4 do
    writeIni("BindPoints", i, me.BoundLocation(i).Zone.ID().."|"..me.BoundLocation(i).X().."|"..me.BoundLocation(i).Y().."|"..me.BoundLocation(i).Z())
end


-- Tribute/Favor
writeIni("Favor", "Current", me.CurrentFavor())
writeIni("Favor", "Career", me.CareerFavor())

-- XP
writeIni("XP", "Level", me.Level())
writeIni("XP", "Exp", me.Exp())
writeIni("XP", "AAExp", me.AAExp())
writeIni("XP", "AAPoints", me.AAPoints())
writeIni("XP", "AAPointsSpent", me.AAPointsSpent())

-- Group leadership XP
writeIni("GroupXP", "GroupLeaderExp", me.GroupLeaderExp())
writeIni("GroupXP", "GroupLeaderPoints", me.GroupLeaderPoints())
writeIni("GroupXP", "RaidLeaderExp", me.RaidLeaderExp())
writeIni("GroupXP", "RaidLeaderPoints", me.RaidLeaderPoints())

-- points in each Group Leadership ability. XXX raid ones ??
writeIni("GroupXP", "LAMarkNPC", me.LAMarkNPC())
writeIni("GroupXP", "LANPCHealth", me.LANPCHealth())
writeIni("GroupXP", "LADelegateMA", me.LADelegateMA())
writeIni("GroupXP", "LADelegateMarkNPC", me.LADelegateMarkNPC())
writeIni("GroupXP", "LAInspectBuffs", me.LAInspectBuffs())
writeIni("GroupXP", "LASpellAwareness", me.LASpellAwareness())
writeIni("GroupXP", "LAOffenseEnhancement", me.LAOffenseEnhancement())
writeIni("GroupXP", "LAManaEnhancement", me.LAManaEnhancement())
writeIni("GroupXP", "LAHealthEnhancement", me.LAHealthEnhancement())
writeIni("GroupXP", "LAHealthRegen", me.LAHealthRegen())
writeIni("GroupXP", "LAFindPathPC", me.LAFindPathPC())
writeIni("GroupXP", "LAHoTT", me.LAHoTT())


-- LDoN
writeIni("LDoN", "Points", me.LDoNPoints())
writeIni("LDoN", "GukEarned", me.GukEarned())
writeIni("LDoN", "MirEarned", me.MirEarned())
writeIni("LDoN", "MMEarned", me.MMEarned())
writeIni("LDoN", "RujEarned", me.RujEarned())
writeIni("LDoN", "TakEarned", me.TakEarned())

-- coins
writeIni("Coins", "Copper", me.Copper())
writeIni("Coins", "CopperBank", me.CopperBank())
writeIni("Coins", "Silver", me.Silver())
writeIni("Coins", "SilverBank", me.SilverBank())
writeIni("Coins", "Gold", me.Gold())
writeIni("Coins", "GoldBank", me.GoldBank())
writeIni("Coins", "Platinum", me.Platinum())
writeIni("Coins", "PlatinumBank", me.PlatinumBank())
writeIni("Coins", "PlatinumShared", me.PlatinumShared())


-- stats as seen by client - XXX can we get raw ones excluding gear and buffs?
-- XXX AC and ATK numbers?
writeIni("CurrentStats", "MaxHPs", me.MaxHPs())
writeIni("CurrentStats", "MaxMana", me.MaxMana())
writeIni("CurrentStats", "MaxEndurance", me.MaxEndurance())
writeIni("CurrentStats", "STR", me.STR())
writeIni("CurrentStats", "STA", me.STA())
writeIni("CurrentStats", "AGI", me.AGI())
writeIni("CurrentStats", "DEX", me.DEX())
writeIni("CurrentStats", "WIS", me.WIS())
writeIni("CurrentStats", "INT", me.INT())
writeIni("CurrentStats", "CHA", me.CHA())
writeIni("CurrentStats", "svPoison", me.svPoison())
writeIni("CurrentStats", "svMagic", me.svMagic())
writeIni("CurrentStats", "svDisease", me.svDisease())
writeIni("CurrentStats", "svFire", me.svFire())
writeIni("CurrentStats", "svCold", me.svCold())
writeIni("CurrentStats", "svCorruption", me.svCorruption())
writeIni("CurrentStats", "svChromatic", me.svChromatic())
writeIni("CurrentStats", "svPrismatic", me.svPrismatic())
writeIni("CurrentStats", "CurrentWeight", me.CurrentWeight())
writeIni("CurrentStats", "AttackSpeed", me.AttackSpeed())
writeIni("CurrentStats", "Haste", me.Haste())

-- bonuses from gear as seen by client
writeIni("Bonuses", "HPBonus", me.HPBonus())
writeIni("Bonuses", "HPRegenBonus", me.HPRegenBonus())
writeIni("Bonuses", "ManaBonus", me.ManaBonus())
writeIni("Bonuses", "ManaRegenBonus", me.ManaRegenBonus())
writeIni("Bonuses", "EnduranceBonus", me.EnduranceBonus())
writeIni("Bonuses", "EnduranceRegenBonus", me.EnduranceRegenBonus())

writeIni("Bonuses", "AccuracyBonus", me.AccuracyBonus())
writeIni("Bonuses", "AttackBonus", me.AttackBonus())
writeIni("Bonuses", "AvoidanceBonus", me.AvoidanceBonus())
writeIni("Bonuses", "ClairvoyanceBonus", me.ClairvoyanceBonus())
writeIni("Bonuses", "CombatEffectsBonus", me.CombatEffectsBonus())
writeIni("Bonuses", "DamageShieldBonus", me.DamageShieldBonus())
writeIni("Bonuses", "DamageShieldMitigationBonus", me.DamageShieldMitigationBonus())
writeIni("Bonuses", "DoTShieldBonus", me.DoTShieldBonus())
writeIni("Bonuses", "HealAmountBonus", me.HealAmountBonus())
writeIni("Bonuses", "ShieldingBonus", me.ShieldingBonus())
writeIni("Bonuses", "SpellDamageBonus", me.SpellDamageBonus())
writeIni("Bonuses", "SpellShieldBonus", me.SpellShieldBonus())
writeIni("Bonuses", "StrikeThroughBonus", me.StrikeThroughBonus())
writeIni("Bonuses", "StunResistBonus", me.StunResistBonus())

doevents()

-- skills ... 1-78 is in use
-- IMPORTANT: skill ID:s do not match between rof2 client and eqemu server, so export skill names. rof2 id 50 = Stringed Instruments, eqemu id 50 = Swimming
for i = 1, 78 do
    if me.Skill(i)() then
        if mq.TLO.Skill(i).Name() ~= "None" then
            writeIni("Skill", mq.TLO.Skill(i).Name(), me.Skill(i)())
        end
    end
end


-- languages (numbered 1-25)
for i = 1, 25 do
    writeIni("LanguageSkill", me.Language(i)(), me.LanguageSkill(i)())
end



-- spell book content
if DUMP_SPELLBOOK then
    for i = 1, SPELLBOOK_SIZE do
        if me.Book(i).ID() then
            writeIni("Spells", i, me.Book(i).ID())
        end
    end
end

doevents()


-- slot names: https://www.macroquest2.com/wiki/index.php/Slot_Names
-- equipment: 0-22 is worn gear, 23-32 is inventory top level (usually 10 backpacks)
-- Inventory ini section format: key is slot id, val is: item.ID|item.Stack|item.Name
for i = 0, 32 do
    local key = "inv"..tostring(i)
    if me.Inventory(i).ID() then
        writeIni("Inventory", key, me.Inventory(i).ID().."|"..me.Inventory(i).Charges())
        for a = 1, MAX_AUG_SLOTS do
            local sub = key.."_aug"..tostring(a)
            if me.Inventory(i).AugSlot(a)() ~= nil then
                writeIni("Inventory", sub, me.Inventory(i).AugSlot(a).Item.ID().."|"..me.Inventory(i).AugSlot(a).Item.Charges())
            else
                writeIni("Inventory", sub, "NULL")
            end
        end
    else
        writeIni("Inventory", key, "NULL")
        for a = 1, MAX_AUG_SLOTS do
            local sub = key.."_aug"..tostring(a)
            writeIni("Inventory", sub, "NULL")
        end
    end
end

doevents()

-- backpack content
for i = 1, MAX_INV_SLOTS do
    local key = "pack"..tostring(i)
    if mq.TLO.InvSlot(key).Item() ~= nil and mq.TLO.InvSlot(key).Item.Container() > 0 then
        for slot = 1, mq.TLO.InvSlot(key).Item.Container() do
            local sub = key.."_slot"..tostring(slot)
            if mq.TLO.InvSlot(key).Item.Item(slot)() ~= nil then
                writeIni("Inventory", sub, mq.TLO.InvSlot(key).Item.Item(slot).ID().."|"..mq.TLO.InvSlot(key).Item.Item(slot).Charges())
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    if mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a)() ~= nil then
                        writeIni("Inventory", aug, mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a).Item.ID().."|"..mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a).Item.Charges())
                    else
                        writeIni("Inventory", aug, "NULL")
                    end
                end
            else
                writeIni("Inventory", sub, "NULL")
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    writeIni("Inventory", aug, "NULL")
                end
            end
        end
    end
end

doevents()

-- bank top level slots: 1-24 is bank bags for rof2 (bank1-24), 25-26 is shared bank (shared1-2)
for i = 1, 26 do
    if me.Bank(i)() ~= nil then
        local key = "bank"..tostring(i)
        if i >= 25 then
            key = "shared"..tostring(i - 24)
        end
        writeIni("Inventory", key, me.Bank(i).ID().."|"..me.Bank(i).Stack())

        if me.Bank(i).Container() > 0 then
            for e = 1, me.Bank(i).Container() do
                local sub = key.."_slot"..tostring(e)
                if me.Bank(i).Item(e)() ~= nil then
                    writeIni("Inventory", sub, me.Bank(i).Item(e).ID().."|"..me.Bank(i).Item(e).Stack())
                else
                    writeIni("Inventory", sub, "NULL")
                end
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    if me.Bank(i).Item(e).AugSlot(a)() ~= nil then
                        writeIni("Inventory", aug, me.Bank(i).Item(e).AugSlot(a).Item.ID().."|"..me.Bank(i).Item(e).AugSlot(a).Item.Stack())
                    else
                        writeIni("Inventory", aug, "NULL")
                    end
                end
            end
        end
    end
end

doevents()

-- all purchased AA:s with rank
if DUMP_KNOWN_AA then
    for i = 1, 16000 do
        if me.AltAbility(i)() ~= nil then
            -- maps ID => rank|maxrank|purchased points
            writeIni("AARank", me.AltAbility(i).ID(), me.AltAbility(i).Rank().."|"..me.AltAbility(i).MaxRank().."|"..me.AltAbility(i).PointsSpent())

            -- if aa missing in aamap.ini, write it
            if mq.TLO.Ini(aaMapFile, "AAMap", me.AltAbility(i).ID(), "-")() == "-" then
                cmd("/dgtell all FOUND NEW AA "..me.AltAbility(i).ID().." "..me.AltAbility(i).Name())
                cmd("/ini "..aaMapFile.." AAMap "..me.AltAbility(i).ID()..' "'..me.AltAbility(i).Name()..'"')
            end
        end
    end
end

-- combat abilities
for i = 1, 200 do
    if me.CombatAbility(i)() ~= nil then
        -- maps ID => rank|maxrank|purchased points
        writeIni("CombatAbility", me.CombatAbility(i).ID(), me.CombatAbility(i).Name())
    end
end


local seondsElapsed = os.time() - timeStart
cmd("/dgtell all DUMPTOON DONE AFTER "..seondsElapsed.."s")

