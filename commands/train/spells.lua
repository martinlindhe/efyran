local mq = require("mq")
local log = require("efyran/knightlinc/Write")

require("efyran/ezmq")

local specializationSkills = {
	"Specialize Abjure",
	"Specialize Alteration",
	"Specialize Conjuration",
	"Specialize Divination",
	"Specialize Evocation",
}

-- GetSpecialization returns the highest specialization name and skill level. empty string if not found
---@return string skill name
---@return integer skill level
function GetSpecialization()
	local bestLevel = 0
	local skillName = ""

	for idx, spec in pairs(specializationSkills) do
		if skill_value(spec) > bestLevel then
			bestLevel = skill_value(spec)
			skillName = spec
		end
	end
	return skillName, bestLevel
end

-- GetSecondaryForte  returns the second highest specialization name and skill level. empty string if not found
---@return string skill name
---@return integer skill level
function GetSecondaryForte()
	local bestLevel = 0
	local skillName = ""

	local primarySpec, _ = GetSpecialization()

	for idx, spec in pairs(specializationSkills) do
		if primarySpec ~= spec then
			if skill_value(spec) > bestLevel then
				bestLevel = skill_value(spec)
				skillName = spec
			end
		end
	end
	return skillName, bestLevel
end

-- Verify specialization
---@return boolean returns true if expected specialization is correct
---@return string name of specialization skill to train, or empty string if none
function VerifySpecialization()
    if (is_caster() and mq.TLO.Me.Level() < 20) or (is_priest() and mq.TLO.Me.Level() < 30) then
		return false, ""
	end

	local currentSpec, currentSkill = GetSpecialization()
	if currentSpec == "" then
		if is_priest() or is_caster() then
			all_tellf("ERROR I do not have a Specialization skill")
		end
		return true, ""
	end

	log.Info("Current spec: %s, skill %d", currentSpec, currentSkill)

	-- Primary Specialization
    local expectedSpecialization = {
        CLR = "Specialize Alteration", -- heals, buffs
		DRU = "Specialize Alteration", -- heals, buffs
		SHM = "Specialize Alteration", -- heals, buffs
		ENC = "Specialize Alteration", -- slow, charm, buffs
		NEC = "Specialize Alteration", -- dots
		MAG = "Specialize Evocation",  -- nukes
		WIZ = "Specialize Evocation",  -- nukes
	}

	for class, spec in pairs(expectedSpecialization) do
		if class == class_shortname() then
			if spec ~= currentSpec and currentSkill <= 50 then
				log.Info("Need to train Specialization \ag%s\ax, skill %d/%d", spec, skill_value(spec), skill_cap(spec))
				return false, spec
			end
			if spec == currentSpec and currentSkill < skill_cap(currentSpec) then
				log.Info("Need to train Specialization \ag%s\ax, skill %d/%d", currentSpec, currentSkill, skill_cap(currentSpec))
				return false, currentSpec
			end
			if spec ~= currentSpec and currentSkill > 50 then
				all_tellf("ERROR: Specialization is [+r+]%s[+x+], expected [+y+]%s[+x+] (need re-specialization quest to reset)", currentSpec, spec)
				return false, ""
			end
		end
	end

    if current_server() == "FVP" then
        -- FVP: No AA:s in Kunark era
        return true, ""
    end

	-- Secondary Forte
	local expectedSecondary = {
		CLR = "Specialize Evocation",   -- nukes
		DRU = "Specialize Evocation",   -- nukes
		SHM = "Specialize Conjuration", -- dots
		ENC = "Specialize Conjuration", -- mez
		NEC = "Specialize Conjuration", -- disease spells
		MAG = "Specialize Conjuration", -- pet heals, buffs
		WIZ = "Specialize Alteration",  -- ports, concussion
	}

	if not have_alt_ability("Secondary Forte") then
		local expectedSkill = ""
		for class, spec in pairs(expectedSecondary) do
			if class == class_shortname() then
				expectedSkill = spec
			end
		end
		all_tellf("WARNING: I lack Secondary Forte AA: want [+r+]%s", expectedSkill)
		return false, ""
	end

	local secondary, secondaryLevel = GetSecondaryForte()
	if secondary == "" then
		all_tellf("ERROR: Secondary Forte is empty (should not happen)")
		return false, ""
	end

	log.Info("Current Secondary Forte skill: %s, skill %d", secondary, secondaryLevel)

	for class, spec in pairs(expectedSecondary) do
		if class == class_shortname() then
			if spec ~= secondary and secondaryLevel <= 50 then
				log.Info("Need to train Secondary Forte \ag%s\ax, skill %d/%d", spec, skill_value(secondary), skill_cap(secondary))
				return false, spec
			end

			-- Skill should be 51+. Cap is 100 at L70
			if secondary == spec and secondaryLevel < skill_cap(secondary) then
				log.Info("Need to train Secondary Forte \ag%s\ax, skill %d/%d", secondary, secondaryLevel, skill_cap(secondary))
				return false, secondary
			end

			-- find the 2nd highest skill name and skill level
			if secondary ~= spec and secondaryLevel > 50 then
				all_tellf("FATAL (need manual reset): Secondary Forte is [+r+]%s[+x+], expected [+y+]%s[+x+]", secondary, spec)
				return false, ""
			end
		end
	end

	return true, ""
end

local trainSpellMatrix = {
	CLR = {Abjuration = "Courage",         Divination = "True North",     Conjuration = "Summon Drink",           Alteration = "Minor Healing",  Evocation = "Strike"},
	DRU = {Abjuration = "Skin like Wood",  Divination = "See Invisible",  Conjuration = "Dance of the Fireflies", Alteration = "Minor Healing",  Evocation = "Burst of Flame"},
	SHM = {Abjuration = "Inner Fire",      Divination = "True North",     Conjuration = "Summon Drink",           Alteration = "Minor Healing",  Evocation = "Burst of Flame"},

	WIZ = {Abjuration = "Minor Shielding", Divination = "True North",     Conjuration = "Halo of Light",          Alteration = "Root",           Evocation = "Blast of Cold"},
	MAG = {Abjuration = "Minor Shielding", Divination = "True North",     Conjuration = "Summon Drink",           Alteration = "Renew Elements", Evocation = "Burst of Flame"},
	NEC = {Abjuration = "Minor Shielding", Divination = "Locate Corpse",  Conjuration = "Coldlight",              Alteration = "Cure Disease",   Evocation = "Word of Shadow"},     -- Word of Shadow: AoE DD
	ENC = {Abjuration = "Minor Shielding", Divination = "True North",     Conjuration = "Pendril's Animation",    Alteration = "Strengthen",     Evocation = "Chaotic Feedback"},   -- Chaotic Feedback: stun (face a corner)

	SHD = {Abjuration = "Endure Cold",     Divination = "Sense the Dead", Conjuration = "Disease Cloud",          Alteration = "Grim Aura",      Evocation = "Word of Spirit"},
	PAL = {Abjuration = "Yaulp",           Divination = "True North",     Conjuration = "Halo of Light",          Alteration = "Minor Healing",  Evocation = "Stun"},               -- NOTE: L07 Cease (Evocation) is Luclin
	RNG = {Abjuration = "Endure Fire",     Divination = "Glimpse",        Conjuration = "Dance of the Fireflies", Alteration = "Minor Healing",  Evocation = "Burst of Fire"},
	BST = {Abjuration = "Fleeting Fury",   Divination = "Serpent Sight",  Conjuration = "Summon Drink",           Alteration = "Salve",          Evocation = "Blast of Frost"},
}

-- Trains the specified spell skill (Abjuration, Alteration, Divination, Conjuration, Evocation) or their specialization skill
---@param baseSkill string
function TrainSpellSkill(baseSkill)

	if not is_priest() and not is_caster() and not is_hybrid() then
		return
	end

	if is_mag() and not have_pet() and baseSkill == "Alteration" then
		-- Renew Elements: requries Pet
		all_tellf("ERROR: MAG training Alteration must have a pet!")
		return
	end

	local trainSkill = ""

	local specName = "Specialize "..baseSkill
	if baseSkill == "Abjuration" then
		specName = "Specialize Abjure"
	end

    if ((is_caster() and mq.TLO.Me.Level() >= 20) or (is_priest() and mq.TLO.Me.Level() >= 30)) and skill_value(specName) < skill_cap(specName) then
        -- first, train until spec is capped
		trainSkill = specName
	end

    if trainSkill == "" and skill_value(baseSkill) < skill_cap(baseSkill) then
        -- then train until base skill is capped
		trainSkill = baseSkill
	end

    if trainSkill == "" then
        log.Info("Capped \ag%s\ax, ending!", baseSkill)
        return
    end

    log.Info("Training \ag%s\ax: %d/%d", trainSkill, skill_value(trainSkill), skill_cap(trainSkill))

	local spell = trainSpellMatrix[class_shortname()][baseSkill]
	if spell == nil then
		all_tellf("FATAL: no spell match (should not happen): skillName=%s", baseSkill)
		return
	end
    if not have_spell(spell) then
        all_tellf("ERROR: i do not have required training spell [+r+]%s[+x+], cannot train [+y+]%s[+x+]", spell, baseSkill)
        return
    end

	if is_enc() and baseSkill == "Conjuration" and inventory_item_count("Tiny Dagger") == 0 then
		-- Pendril's Animation: Tiny Dagger reagent
		all_tellf("ERROR: missing [+r+]Tiny Dagger[+x+] reagent")
		return
	end

	all_tellf("Training [+y+]%s[+x+] using spell [+g+]%s[+x+], skill %d/%d", trainSkill, spell, skill_value(trainSkill), skill_cap(trainSkill))

	local tries = 0
	local maxTries = 800
    local spellCost = mq.TLO.Spell(spell).Mana() + 50

	while true do
        RemoveTrainSpellBlockerBuffs()
		memorize_spell(spell, 1)

		if not is_casting() and is_spell_ready(spell) then
			castSpell(spell, mq.TLO.Me.ID())

			tries = tries + 1
			if tries >= maxTries then
				all_tellf("Giving up [+g+]%s[+x+] training after %d casts at %d/%d, ending!", trainSkill, tries, skill_value(trainSkill), skill_cap(trainSkill))
				return
			end
		end

		delay(50)
		doevents()

		if skill_value(trainSkill) == skill_cap(trainSkill) then
			all_tellf("Capped [+g+]%s[+x+], ending!", trainSkill)
			return
		end

		if mq.TLO.Cursor.ID() == 10290 or mq.TLO.Cursor.ID() == 10291 or mq.TLO.Cursor.ID() == 10295 or mq.TLO.Cursor.ID() == 13079 then
			-- 10290 Summoned: Halo of Light
			-- 10291 Summoned: Coldlight
			-- 10295 Summoned: Firefly Globe
			-- 13079 Summoned: Globe of Water
			log.Info("Destroying %s", mq.TLO.Cursor.Name())
			cmd("/destroy")
		end

		if is_enc() and baseSkill == "Conjuration" and have_pet() then
			-- Pendril's Animation: summons Pet
			-- kill pet in order to summon another
			cmd("/pet leave")
		end

        if mq.TLO.Me.CurrentMana() < spellCost or mq.TLO.Me.CurrentHPs() < 50 then
            if is_standing() then
                log.Info("spell train: medding for %s (%s)", spell, trainSkill)
                cmd("/sit")
            end
            mq.delay("300s", function() return (mq.TLO.Me.PctMana() >= 100 and mq.TLO.Me.PctHPs() >= 100) or is_standing() end)
        end

	end
end

-- click off buffs that may block cast of training spells
function RemoveTrainSpellBlockerBuffs()
	local blockers = {
		"Shielding",
		"Major Shielding",
		"Arch Shielding",
		"Greater Shielding",
		"Shield of the Magi",
		"Blessing of Temperance",
		"Protection of the Cabbage",
		"Protection of the Nine",
		"Blessing of the Nine",
		"Steeloak Skin",
		"Blessing of Steeloak",
		"Focus of Soul",
		"Focus of the Seventh",
		"Talisman of Wunshi",
		"Wunshi's Focusing",
		"Strength of Tunare",
		"Flight of Eagles",
		"Koadic's Endless Intellect",
		"Voice of Quellious",
		"Voice of Clairvoyance",
		"Clairvoyance",
		"Temperance",
		"Blessing of Aegolism",
		"Hand of Virtue",
		"Hand of Conviction",
	}
	for _, blocker in pairs(blockers) do
		if have_buff(blocker) then
			log.Info("Removing buff \ag%s\ax", blocker)
			cmdf('/removebuff "%s"', blocker)
		end
	end
end

return function()
    log.Info("Train spells started")
    local done, spec = VerifySpecialization()
    if not done and spec ~= "" then
        -- train Specialization and Secondary Forte skill
        local trainSkill = string.sub(spec, 12)
        if trainSkill == "Abjure" then
            -- "Specialize Abjure" -> "Abjuration"
            trainSkill = "Abjuration"
        end
        TrainSpellSkill(trainSkill)
    end

    -- train remaining spell skills
    local skills = {
        "Abjuration",
        "Alteration",
        "Conjuration",
        "Divination",
        "Evocation",
    }
    for idx, skill in pairs(skills) do
        TrainSpellSkill(skill)
    end
    log.Info("Train spells finished!")
end
