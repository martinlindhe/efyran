-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["B"] = {
		["Black Powder Pouch"] = "Keep";
		["Bone Chips"] = "Skip";
		["Blackened Eye"] = "Sell";
		["Brittle Laburnum"] = "Sell";
		["Brittle Oleander"] = "Sell";
	};
	["S"] = {
		["Shiv"] = "Sell";
		["Spell: Brierbloom Coat Rk. II"] = "Keep";
		["Spell: Blessing of the Heartwood Rk. II"] = "Keep";
		["Spell: Horde of the Hive Rk. II"] = "Keep";
		["Steel Ingot"] = "Keep";
		["Stone of Marking"] = "Keep";
		["Silver Tipped Quill"] = "Sell";
		["Star Ruby"] = "Sell";
		["Sharp Luggald Claw"] = "Sell";
		["Sunshard Pebble"] = "Sell";
		["Spell: Mask of the Raptor Rk. II"] = "Keep";
	};
	["5"] = {
	};
	["D"] = {
		["Dry Laburnum"] = "Sell";
		["Deprecated Fellowship Campfire Materials"] = "Keep";
		["Distillate of Divine Healing XIII"] = "Keep";
		["Dry Caladium"] = "Sell";
	};
	["E"] = {
		["Elven Blood"] = "Sell";
	};
	["T"] = {
		["Tears of Prexus"] = "Sell";
		["Torn Cloth Eye Patch"] = "Sell";
		["Thalium Ore"] = "Keep";
		["Troll Parts"] = "Sell";
		["Thick Silk"] = "Keep";
		["Twice-Stitched Sandals"] = "Trib";
	};
	["N"] = {
		["Nilitim's Grimoire Pg. 416"] = "Sell";
		["Nilitim's Grimoire Pg. 400"] = "Sell";
		["Nilitim's Grimoire Pg. 415"] = "Sell";
		["Nilitim's Grimoire Pg. 378"] = "Sell";
		["Nilitim's Grimoire Pg. 379"] = "Sell";
		["Nilitim's Grimoire Pg. 450"] = "Sell";
		["Natural Silk"] = "Keep";
		["Nilitim's Grimoire Pg. 300"] = "Sell";
		["Nilitim's Grimoire Pg. 401"] = "Sell";
	};
	["G"] = {
		["Grade AA Nigriventer Venom"] = "Sell";
		["Grade A Caladium Extract"] = "Sell";
		["Gold Gem Dusted Rune"] = "Sell";
	};
	["8"] = {
	};
	["W"] = {
		["Words of Incarceration"] = "Sell";
		["Wilted Muscimol"] = "Sell";
		["Words of Acquisition (Beza)"] = "Sell";
		["Words of Tenancy"] = "Sell";
		["Words of Grappling"] = "Sell";
		["Water Flask"] = "Keep";
		["Words of Crippling Force"] = "Sell";
		["Writing Ink"] = "Keep";
		["Words of Requisition"] = "Sell";
		["Words of Bondage"] = "Sell";
		["Words of Burnishing"] = "Sell";
	};
	["9"] = {
	};
	["H"] = {
	};
	["I"] = {
		["Indium Ore"] = "Keep";
		["Iridium Ore"] = "Keep";
	};
	["X"] = {
	};
	["Y"] = {
	};
	["V"] = {
		["Viridian Hero's Forge Plate Feet Ornament"] = "Keep";
		["Viridian Wizard Hat Ornament"] = "Keep";
	};
	["K"] = {
		["Kaladim Constitutional"] = "Keep";
	};
	["J"] = {
	};
	["L"] = {
		["Lelluran's Bridle"] = "Keep";
		["Lumber Plank"] = "Keep";
		["Leather Roll"] = "Keep";
	};
	["M"] = {
		["Modest Binding Powder"] = "Sell";
		["Misty Thicket Picnic"] = "Keep";
		["Medicinal Herbs"] = "Keep";
	};
	["0"] = {
	};
	["O"] = {
		["Ornate Defiant Cloth Gloves"] = "Keep";
		["Opal"] = "Sell";
		["Ornate Defiant Chain Gauntlets"] = "Keep";
		["Ornate Defiant Cloth Wristwrap"] = "Keep";
	};
	["1"] = {
	};
	["U"] = {
	};
	["7"] = {
	};
	["Z"] = {
		["Zraxthril Forged Cutlass"] = "Sell";
		["Zraxthril Forged Axe"] = "Sell";
		["Zraxthril Forged Mace"] = "Sell";
		["Zraxthril Forged Flamberge"] = "Sell";
	};
	["A"] = {
	};
	["P"] = {
		["Pristine Animal Pelt"] = "Keep";
		["Pristine Silk"] = "Keep";
		["Peridot"] = "Keep";
		["Pliant Loam"] = "Sell";
	};
	["6"] = {
	};
	["Q"] = {
	};
	["3"] = {
	};
	["F"] = {
		["Fire Opal"] = "Sell";
		["Flawed Defiant Silk Cap"] = "Sell";
		["Figurine Collector's Chest: Denizens"] = "Keep";
		["Flawed Defiant Leather Cap"] = "Sell";
		["Flawed Adept's Rake"] = "Sell";
		["Fine Animal Pelt"] = "Keep";
		["Firerune Brand"] = "Keep";
		["Flawed Defiant Glass Shard"] = "Sell";
		["Fire Emerald"] = "Sell";
		["Flawed Defiant Plate Gauntlets"] = "Sell";
		["Fine Silk"] = "Keep";
		["Flawed Defiant Plate Boots"] = "Sell";
		["Flawed Defiant Silk Sandals"] = "Sell";
		["Flawed Defiant Brawl Stick"] = "Sell";
		["Flawed Defiant Silk Wristwrap"] = "Sell";
		["Fulginate Ore"] = "Keep";
		["Fire Beetle Eye"] = "Keep";
	};
	["2"] = {
	};
	["R"] = {
		["Rough Defiant Leather Boots"] = "Sell";
		["Raw Fine Runic Hide"] = "Keep";
		["Rune of Impetus"] = "Sell";
		["Rough Animal Pelt"] = "Sell";
		["Rough Defiant Nihilite Shard"] = "Sell";
		["Rune of Frost"] = "Sell";
		["Raw Fine Supple Runic Hide"] = "Keep";
		["Rune of the Astral"] = "Sell";
		["Ringlet of the Fallen Spirit"] = "Keep";
		["Remains of Brom"] = "Keep";
		["Raw Supple Runic Hide"] = "Keep";
		["Rubicite Ore"] = "Keep";
		["Rotting Golden Tooth"] = "Sell";
		["Ruby"] = "Sell";
		["Rough Defiant Longsword"] = "Sell";
		["Rune of Concussion"] = "Sell";
		["Rune of Flash"] = "Sell";
	};
	["C"] = {
		["Crude Animal Pelt"] = "Sell";
		["Concentrated Grade B Nigriventer Venom"] = "Sell";
		["Complex Platinum Gem Dusted Rune"] = "Sell";
		["Crude Silk"] = "Sell";
		["Crystallized Sulfur"] = "Sell";
		["Concentrated Grade B Gormar Venom"] = "Sell";
		["Cloth Bolt"] = "Keep";
	};
	["4"] = {
	};
}
return obj1
