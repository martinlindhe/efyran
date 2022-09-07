-- write current char info to a ini file for later consumption by another tool
--
--
-- raw stats: int str etc, hp mana
-- all item slots and content
-- all bags & bank content (so u can search inventories on resulting webpage)

-- TODO: can we record output from /keys to file?

require("ezmq")


local timeStart = os.time()

local DUMP_KNOWN_AA = true
local DUMP_SPELLBOOK = true


-- rof2 client:
local SPELLBOOK_SIZE = 720      -- size of spellbook: 8 * 90 pages (RoF2)
local MAX_INV_SLOTS  = 10
local MAX_AUG_SLOTS  = 2

local me = mq.TLO.Me

local settingsRoot = "D:/dev-mq/mqnext-e4-lua/dumptoon"
local iniFile = settingsRoot .. "/Dumptoon."..me.Name()..".ini"
local aaMapFile = settingsRoot .. "/AAMap."..mq.TLO.MacroQuest.Server()..".ini"

-- dump bind point   FIXME never triggers
mq.event("bindpoint", "You are currently bound in: #1#", function(text, where)
	mq.cmd.dgtell("all", "BIND POINT:", where)
    mq.cmd.ini(iniFile, "Overview", "Bindpoint", where)
end)

print("--- DUMP TOON ---")

-- ask for bind point
-- XXX mq2 window shows x,y,z coords too, how to record those?
mq.cmd("/char")
mq.doevents()

-- Overview
mq.cmd.ini(iniFile, "Overview", "Name", me.Name())
mq.cmd.ini(iniFile, "Overview", "Class", me.Class())
mq.cmd.ini(iniFile, "Overview", "Race", me.Race())
mq.cmd.ini(iniFile, "Overview", "Gender", me.Gender())

-- Tribute/Favor
mq.cmd.ini(iniFile, "Favor", "Current", me.CurrentFavor())
mq.cmd.ini(iniFile, "Favor", "Career", me.CareerFavor())

-- XP
mq.cmd.ini(iniFile, "XP", "Level", me.Level())
mq.cmd.ini(iniFile, "XP", "Exp", me.Exp())
mq.cmd.ini(iniFile, "XP", "AAExp", me.AAExp())
mq.cmd.ini(iniFile, "XP", "AAPoints", me.AAPoints())
mq.cmd.ini(iniFile, "XP", "AAPointsSpent", me.AAPointsSpent())
-- XXX not available in peq-mq2 version: ${Me.GroupLeaderExp}, ${Me.GroupLeaderPoints}

-- LDoN
mq.cmd.ini(iniFile, "LDoN", "Points", me.LDoNPoints())
mq.cmd.ini(iniFile, "LDoN", "GukEarned", me.GukEarned())
mq.cmd.ini(iniFile, "LDoN", "MirEarned", me.MirEarned())
mq.cmd.ini(iniFile, "LDoN", "MMEarned", me.MMEarned())
mq.cmd.ini(iniFile, "LDoN", "RujEarned", me.RujEarned())
mq.cmd.ini(iniFile, "LDoN" ,"TakEarned", me.TakEarned())

-- coins
mq.cmd.ini(iniFile, "Coins", "Copper", me.Copper())
mq.cmd.ini(iniFile, "Coins", "CopperBank", me.CopperBank())
mq.cmd.ini(iniFile, "Coins", "Silver", me.Silver())
mq.cmd.ini(iniFile, "Coins", "SilverBank", me.SilverBank())
mq.cmd.ini(iniFile, "Coins", "Gold", me.Gold())
mq.cmd.ini(iniFile, "Coins", "GoldBank", me.GoldBank())
mq.cmd.ini(iniFile, "Coins", "Platinum", me.Platinum())
mq.cmd.ini(iniFile, "Coins", "PlatinumBank", me.PlatinumBank())
mq.cmd.ini(iniFile, "Coins", "PlatinumShared", me.PlatinumShared())


-- stats as seen by client - XXX can we get raw ones excluding gear and buffs?
-- XXX AC and ATK numbers?
mq.cmd.ini(iniFile, "CurrentStats", "MaxHPs", me.MaxHPs())
mq.cmd.ini(iniFile, "CurrentStats", "MaxMana", me.MaxMana())
mq.cmd.ini(iniFile, "CurrentStats", "MaxEndurance", me.MaxEndurance())
mq.cmd.ini(iniFile, "CurrentStats", "STR", me.STR())
mq.cmd.ini(iniFile, "CurrentStats", "STA", me.STA())
mq.cmd.ini(iniFile, "CurrentStats", "AGI", me.AGI())
mq.cmd.ini(iniFile, "CurrentStats", "DEX", me.DEX())
mq.cmd.ini(iniFile, "CurrentStats", "WIS", me.WIS())
mq.cmd.ini(iniFile, "CurrentStats", "INT", me.INT())
mq.cmd.ini(iniFile, "CurrentStats", "CHA", me.CHA())
mq.cmd.ini(iniFile, "CurrentStats", "svPoison", me.svPoison())
mq.cmd.ini(iniFile, "CurrentStats", "svMagic", me.svMagic())
mq.cmd.ini(iniFile, "CurrentStats", "svDisease", me.svDisease())
mq.cmd.ini(iniFile, "CurrentStats", "svFire", me.svFire())
mq.cmd.ini(iniFile, "CurrentStats", "svCold", me.svCold())
mq.cmd.ini(iniFile, "CurrentStats", "svCorruption", me.svCorruption())
mq.cmd.ini(iniFile, "CurrentStats", "svChromatic", me.svChromatic())
mq.cmd.ini(iniFile, "CurrentStats", "svPrismatic", me.svPrismatic())
mq.cmd.ini(iniFile, "CurrentStats", "CurrentWeight", me.CurrentWeight())
mq.cmd.ini(iniFile, "CurrentStats", "AttackSpeed", me.AttackSpeed())
mq.cmd.ini(iniFile, "CurrentStats", "Haste", me.Haste())

-- bonuses from gear as seen by client
mq.cmd.ini(iniFile, "Bonuses", "HPBonus", me.HPBonus())
mq.cmd.ini(iniFile, "Bonuses", "HPRegenBonus", me.HPRegenBonus())
mq.cmd.ini(iniFile, "Bonuses", "ManaBonus", me.ManaBonus())
mq.cmd.ini(iniFile, "Bonuses", "ManaRegenBonus", me.ManaRegenBonus())
mq.cmd.ini(iniFile, "Bonuses", "EnduranceBonus", me.EnduranceBonus())
mq.cmd.ini(iniFile, "Bonuses", "EnduranceRegenBonus", me.EnduranceRegenBonus())

mq.cmd.ini(iniFile, "Bonuses", "AccuracyBonus", me.AccuracyBonus())
mq.cmd.ini(iniFile, "Bonuses", "AttackBonus", me.AttackBonus())
mq.cmd.ini(iniFile, "Bonuses", "AvoidanceBonus", me.AvoidanceBonus())
mq.cmd.ini(iniFile, "Bonuses", "ClairvoyanceBonus", me.ClairvoyanceBonus())
mq.cmd.ini(iniFile, "Bonuses", "CombatEffectsBonus", me.CombatEffectsBonus())
mq.cmd.ini(iniFile, "Bonuses", "DamageShieldBonus", me.DamageShieldBonus())
mq.cmd.ini(iniFile, "Bonuses", "DamageShieldMitigationBonus", me.DamageShieldMitigationBonus())
mq.cmd.ini(iniFile, "Bonuses", "DoTShieldBonus", me.DoTShieldBonus())
mq.cmd.ini(iniFile, "Bonuses", "HealAmountBonus", me.HealAmountBonus())
mq.cmd.ini(iniFile, "Bonuses", "ShieldingBonus", me.ShieldingBonus())
mq.cmd.ini(iniFile, "Bonuses", "SpellDamageBonus", me.SpellDamageBonus())
mq.cmd.ini(iniFile, "Bonuses", "SpellShieldBonus", me.SpellShieldBonus())
mq.cmd.ini(iniFile, "Bonuses", "StrikeThroughBonus", me.StrikeThroughBonus())
mq.cmd.ini(iniFile, "Bonuses", "StunResistBonus", me.StunResistBonus())

mq.doevents()

-- skills ... 1-78 is in use
for i = 1, 78 do
    if me.Skill(i)() then
        if mq.TLO.Skill(i).Name() ~= "None" then
            local skillDesc = mq.TLO.Skill(i).Name().."|"..me.Skill(i)().."/"..me.SkillCap(i)()
            mq.cmd.ini(iniFile, "Skill", i, '"'..skillDesc..'"')
        end
    end
end


-- languages (numbered 1-25)
for i = 1, 25 do
    mq.cmd.ini(iniFile, "LanguageSkill", i, '"'..me.Language(i)().."|"..tostring(me.LanguageSkill(i)())..'"')
end



-- spell book content
if DUMP_SPELLBOOK then
    for i = 1, SPELLBOOK_SIZE do
        if me.Book(i).ID() then
            mq.cmd.ini(iniFile, "Spells", i, '"'..tostring(me.Book(i).ID()).."|"..me.Book(i).RankName()..'"')
        end
    end
end

mq.doevents()


-- slot names: https://www.macroquest2.com/wiki/index.php/Slot_Names
-- equipment: 0-22 is worn gear, 23-32 is inventory top level (usually 10 backpacks)
-- Inventory ini section format: key is slot id, val is: item.ID|item.Stack|item.Name
for i = 0, 32 do
    local key = "inv"..tostring(i)
    if me.Inventory(i).ID() then
        mq.cmd.ini(iniFile, "Inventory", key, '"'..tostring(me.Inventory(i).ID()).."|"..me.Inventory(i).Stack().."|"..me.Inventory(i).Name()..'"')
        for a = 1, MAX_AUG_SLOTS do
            local sub = key.."_aug"..tostring(a)
            if me.Inventory(i).AugSlot(a)() ~= nil then
                mq.cmd.ini(iniFile, "Inventory", sub, '"'..me.Inventory(i).AugSlot(a).Item.ID().."|"..me.Inventory(i).AugSlot(a).Item.Stack().."|"..me.Inventory(i).AugSlot(a)()..'"')
            else
                mq.cmd.ini(iniFile, "Inventory", sub, "NULL")
            end
        end
    else
        mq.cmd.ini(iniFile, "Inventory", key, "NULL")
        for a = 1, MAX_AUG_SLOTS do
            local sub = key.."_aug"..tostring(a)
            mq.cmd.ini(iniFile, "Inventory", sub, "NULL")
        end
    end
end

mq.doevents()

-- backpack content
for i = 1, MAX_INV_SLOTS do
    local key = "pack"..tostring(i)
    if mq.TLO.InvSlot(key).Item.Container() > 0 then
        for slot = 1, mq.TLO.InvSlot(key).Item.Container() do
            local sub = key.."_slot"..tostring(slot)
            if mq.TLO.InvSlot(key).Item.Item(slot)() ~= nil then
                mq.cmd.ini(iniFile, "Inventory", sub, '"'..mq.TLO.InvSlot(key).Item.Item(slot).ID().."|"..mq.TLO.InvSlot(key).Item.Item(slot).Stack().."|"..mq.TLO.InvSlot(key).Item.Item(slot)()..'"')
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    if mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a)() ~= nil then
                        mq.cmd.ini(iniFile, "Inventory", aug, '"'..mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a).Item.ID().."|"..mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a).Item.Stack().."|"..mq.TLO.InvSlot(key).Item.Item(slot).AugSlot(a)()..'"')
                    else
                        mq.cmd.ini(iniFile, "Inventory", aug, "NULL")
                    end
                end
            else
                mq.cmd.ini(iniFile, "Inventory", sub, "NULL")
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    mq.cmd.ini(iniFile, "Inventory", aug, "NULL")
                end
            end
        end
    end
end

mq.doevents()

-- bank top level slots: 1-24 is bank bags, 25-26 is shared bank
for i = 1, 26 do
    if me.Bank(i)() ~= nil then
        local key = "bank"..tostring(i)
        if me.Bank(i).Container() > 0 then
            for e = 1, me.Bank(i).Container() do
                local sub = key.."_slot"..tostring(e)
                if me.Bank(i).Item(e)() ~= nil then
                    mq.cmd.ini(iniFile, "Inventory", sub, '"'..me.Bank(i).Item(e).ID().."|"..me.Bank(i).Item(e).Stack().."|"..me.Bank(i).Item(e)()..'"')
                else
                    mq.cmd.ini(iniFile, "Inventory", sub, "NULL")
                end
                for a = 1, MAX_AUG_SLOTS do
                    local aug = sub.."_aug"..tostring(a)
                    if me.Bank(i).Item(e).AugSlot(a)() ~= nil then
                        mq.cmd.ini(iniFile, "Inventory", aug, '"'..me.Bank(i).Item(e).AugSlot(a).Item.ID().."|"..me.Bank(i).Item(e).AugSlot(a).Item.Stack().."|"..me.Bank(i).Item(e).AugSlot(a)()..'"')
                    else
                        mq.cmd.ini(iniFile, "Inventory", aug, "NULL")
                    end
                end
            end
        else
            mq.cmd.ini(iniFile, "Inventory", key, '"'..me.Bank(i).ID().."|"..me.Bank(i).Stack().."|"..me.Bank(i).Name()..'"')
        end
    end
end

mq.doevents()

-- all purchased AA:s with rank
if DUMP_KNOWN_AA then
    for i = 1, 16000 do
        if me.AltAbility(i)() ~= nil then
            --print(me.AltAbility(i).ID(), ": ", me.AltAbility(i).Name())
            -- maps ID => rank|maxrank|purchased points
            mq.cmd.ini(iniFile, "AARank", me.AltAbility(i).ID(), '"'..me.AltAbility(i).Rank().."|"..me.AltAbility(i).MaxRank().."|"..me.AltAbility(i).PointsSpent()..'"')

            -- if aa missing in aamap.ini, write it
            if mq.TLO.Ini(aaMapFile, "AAMap", me.AltAbility(i).ID(), "-")() == "-" then
                mq.cmd.dgtell("FOUND NEW AA", me.AltAbility(i).ID(), me.AltAbility(i).Name())
                mq.cmd.ini(aaMapFile, "AAMap", me.AltAbility(i).ID(), '"'..me.AltAbility(i).Name()..'"')
            end
        end
    end
end

local seondsElapsed = os.time() - timeStart
mq.cmd.dgtell("all", "DUMPTOON DONE AFTER ", seondsElapsed, "s")

