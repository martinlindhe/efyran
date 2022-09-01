-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["B"] = {
		["Black Powder Pouch"] = "Keep";
		["Bone Chips"] = "Skip";
		["Blightfire-Infused Thick Hide"] = "Keep";
		["Brittle Larkspur"] = "Sell";
		["Brittle Laburnum"] = "Sell";
		["Boar Meat"] = "Keep";
		["Blackened Eye"] = "Sell";
		["Breath of Ro"] = "Sell";
		["Brittle Caladium"] = "Sell";
		["Brick of Bloodmetal"] = "Sell";
		["Brittle Oleander"] = "Sell";
		["Brined Armbands"] = "Trib";
	};
	["S"] = {
		["Stone of Marking"] = "Keep";
		["Spell: Horde of the Hive Rk. II"] = "Keep";
		["Spiderling Silk"] = "Keep";
		["Simple Binding Powder"] = "Sell";
		["Spell: Mask of the Raptor Rk. II"] = "Keep";
		["Spell: Unwavering Hammer of Zeal Rk. II"] = "Keep";
		["Stale Oleander"] = "Sell";
		["Song: Fatesong of the Gelidran Rk.II"] = "Keep";
		["Sunshard Powder"] = "Sell";
		["Spell: Voice of Prescience Rk. II"] = "Keep";
		["Sylvan Cloth Feet Ornament"] = "Keep";
		["Spell: Darianna's Mark Rk. II"] = "Keep";
		["Spell: Order of the Devout Rk. II"] = "Keep";
		["Superb Silk"] = "Keep";
		["Stale Muscimol"] = "Sell";
		["Shiv"] = "Sell";
		["Sapphire"] = "Sell";
		["Spell: Netherside Rk. II"] = "Keep";
		["Spell: Yaulp X Rk. II"] = "Keep";
		["Silver Tipped Quill"] = "Sell";
		["Strand of Ether"] = "Sell";
		["Spell: Rallied Palladium of Vie Rk. II"] = "Keep";
		["Spell: Armor of the Devout Rk. II"] = "Keep";
		["Spider Silk"] = "Keep";
		["Spell: Brierbloom Coat Rk. II"] = "Keep";
		["Sullied Spinneret Fluid"] = "Sell";
		["Sharp Luggald Claw"] = "Sell";
		["Shabby Vellum Parchment"] = "Sell";
		["Scale Ore"] = "Keep";
		["Sunshard Ore"] = "Sell";
		["Spell: Auroral Darkness Rk. II"] = "Keep";
		["Smashed War Grubs"] = "Sell";
		["Spell: Aura of Loyalty Rk. II"] = "Keep";
		["Sullied Animal Pelt"] = "Sell";
		["Star Ruby"] = "Sell";
		["Spell: Blessing of the Heartwood Rk. II"] = "Keep";
		["Sunshard Pebble"] = "Sell";
		["Steel Ingot"] = "Keep";
	};
	["5"] = {
	};
	["D"] = {
		["Diaku Forged Sword"] = "Sell";
		["Dreadspire Gargoyle Granite"] = "Keep";
		["Diaku Forged Maul"] = "Sell";
		["Diaku Forged Scimitar"] = "Sell";
		["Dweric Powder"] = "Keep";
		["Dry Caladium"] = "Sell";
		["Dry Laburnum"] = "Sell";
		["Discordant Steel"] = "Keep";
		["Diamond"] = "Sell";
		["Decaying Coin Purse"] = "Sell";
		["Dusty Marrow"] = "Sell";
		["Deprecated Fellowship Campfire Materials"] = "Sell";
		["Distillate of Divine Healing XIII"] = "Keep";
		["Desiccated Marrow"] = "Sell";
	};
	["E"] = {
		["Elaborate Binding Powder"] = "Sell";
		["Essence Emerald"] = "Keep";
		["Excellent Silk"] = "Keep";
		["Elven Blood"] = "Sell";
		["Exquisite Gem Dusted Rune"] = "Sell";
		["Exquisite Velium Gem Dusted Rune"] = "Sell";
		["Exquisite Silk"] = "Keep";
		["Emerald"] = "Keep";
	};
	["T"] = {
		["Tungsten Ore"] = "Keep";
		["Tears of Prexus"] = "Sell";
		["Tiny Dagger"] = "Keep";
		["Torn Cloth Eye Patch"] = "Sell";
		["Titanium Ore"] = "Keep";
		["Thick Silk"] = "Keep";
		["Twice-Stitched Sandals"] = "Trib";
		["Thick Spinneret Fluid"] = "Sell";
		["Tattered Animal Pelt"] = "Sell";
		["Thick Grizzly Bear Skin"] = "Sell";
		["Tiny Jade Inlaid Coffin"] = "Keep";
		["Tacky Spinneret Fluid"] = "Sell";
		["Troll Parts"] = "Sell";
		["Thalium Ore"] = "Keep";
		["Trinket of Suffering"] = "Sell";
	};
	["N"] = {
		["Nilitim's Grimoire Pg. 416"] = "Sell";
		["Nilitim's Grimoire Pg. 400"] = "Sell";
		["Natural Spices"] = "Keep";
		["Nilitim's Grimoire Pg. 415"] = "Sell";
		["Nilitim's Grimoire Pg. 378"] = "Sell";
		["Nilitim's Grimoire Pg. 449"] = "Sell";
		["Nilitim's Grimoire Pg. 379"] = "Sell";
		["Nilitim's Grimoire Pg. 450"] = "Sell";
		["Nilitim's Grimoire Pg. 401"] = "Sell";
		["Nilitim's Grimoire Pg. 300"] = "Sell";
		["Natural Silk"] = "Keep";
	};
	["G"] = {
		["Grade AA Nigriventer Venom"] = "Sell";
		["Grade A Caladium Extract"] = "Sell";
		["Gold-Tipped Boar Horn"] = "Sell";
		["Gold Gem Dusted Rune"] = "Sell";
		["Glowstone"] = "Keep";
		["Glowgem"] = "Keep";
		["Grubby Fine Papyrus"] = "Sell";
	};
	["8"] = {
	};
	["W"] = {
		["War Wraith Blood"] = "Sell";
		["Words of Incarceration"] = "Sell";
		["Wilted Muscimol"] = "Sell";
		["Wereorc Mane"] = "Keep";
		["Wilted Oleander"] = "Sell";
		["Words of Crippling Force"] = "Sell";
		["Words of Bondage"] = "Sell";
		["Words of Burnishing"] = "Sell";
		["Words of Odus"] = "Sell";
		["Words of Grappling"] = "Sell";
		["Wereorc Blood"] = "Keep";
		["Words of Tenancy"] = "Sell";
		["Words of Acquisition (Beza)"] = "Sell";
		["Words of the Ethereal"] = "Sell";
		["Wereorc Canine"] = "Keep";
		["Warped Steel Breastplate"] = "Keep";
		["Writing Ink"] = "Keep";
		["Water Flask"] = "Keep";
		["Wilted Caladium"] = "Sell";
		["Words of Requisition"] = "Sell";
		["Wereorc Claw"] = "Keep";
		["Wing of Xegony"] = "Sell";
	};
	["9"] = {
	};
	["6"] = {
	};
	["I"] = {
		["Intricate Defiant Chain Bracer"] = "Keep";
		["Indium Ore"] = "Keep";
		["Iridium Ore"] = "Keep";
		["Intricate Defiant Partisan Spear"] = "Keep";
		["Intricate Adept's Cloak"] = "Keep";
		["Intricate Defiant Charm"] = "Keep";
		["Intricate Adept's Belt"] = "Keep";
	};
	["F"] = {
		["Fire Opal"] = "Sell";
		["Faceted Crystal"] = "Keep";
		["Flawed Defiant Silk Cap"] = "Sell";
		["Flawed Defiant Silk Gloves"] = "Sell";
		["Flawless Silk"] = "Keep";
		["Faydwer Diamond"] = "Keep";
		["Flawed Defiant Leather Cap"] = "Sell";
		["Flawed Adept's Rake"] = "Sell";
		["Flawed Defiant Lance"] = "Sell";
		["Fine Animal Pelt"] = "Keep";
		["Figurine Collector's Chest: Denizens"] = "Keep";
		["Flawed Defiant Scale Shield"] = "Sell";
		["Firerune Brand"] = "Keep";
		["Flawed Animal Pelt"] = "Keep";
		["Flawed Defiant Plate Boots"] = "Sell";
		["Flawed Defiant Plate Gauntlets"] = "Sell";
		["Flawed Defiant Glass Shard"] = "Sell";
		["Flawed Defiant Shortsword"] = "Sell";
		["Fire Emerald"] = "Sell";
		["Fine Silk"] = "Keep";
		["Flawed Defiant Carapace"] = "Sell";
		["Flawed Defiant Silk Sandals"] = "Sell";
		["Flawed Defiant Brawl Stick"] = "Sell";
		["Flawed Defiant Silk Wristwrap"] = "Sell";
		["Fulginate Ore"] = "Keep";
		["Fire Beetle Eye"] = "Keep";
	};
	["Y"] = {
	};
	["V"] = {
		["Velium Gemmed Rune"] = "Sell";
		["Viridian Hero's Forge Plate Feet Ornament"] = "Keep";
		["Velium Gem Dusted Rune"] = "Sell";
		["Versluierd Fungus"] = "Sell";
		["Viridian Wizard Hat Ornament"] = "Keep";
	};
	["K"] = {
		["Kaladim Constitutional"] = "Keep";
		["Kobold Parts"] = "Sell";
	};
	["J"] = {
	};
	["L"] = {
		["Luggald Dagger"] = "Sell";
		["Lucidem"] = "Sell";
		["Leather Roll"] = "Keep";
		["Lelluran's Bridle"] = "Keep";
		["Low Quality Wolf Skin"] = "Sell";
		["Lumber Plank"] = "Keep";
		["Luggald Trident"] = "Sell";
	};
	["M"] = {
		["Mangled Animal Pelt"] = "Sell";
		["Medicinal Herbs"] = "Keep";
		["Medium Quality Cat Pelt"] = "Sell";
		["Misty Thicket Picnic"] = "Keep";
		["Makeshift Binding Powder"] = "Sell";
		["Maggot-Ridden Head"] = "Keep";
		["Modest Binding Powder"] = "Sell";
		["Mottled Hide"] = "Keep";
		["Mixing Bowl"] = "Keep";
		["Mantle of the Fallen Spirit"] = "Trib";
	};
	["0"] = {
	};
	["O"] = {
		["Ornate Defiant Cloth Wristwrap"] = "Keep";
		["Ornate Binding Powder"] = "Sell";
		["Ornate Defiant Cloth Gloves"] = "Keep";
		["Opal"] = "Sell";
		["Ornate Defiant Chain Gauntlets"] = "Keep";
	};
	["1"] = {
	};
	["4"] = {
	};
	["7"] = {
	};
	["R"] = {
		["Rough Defiant Leather Boots"] = "Sell";
		["Rune of Crippling"] = "Sell";
		["Rune of Rathe"] = "Sell";
		["Raw Indigo Nihilite"] = "Sell";
		["Raw Fine Runic Hide"] = "Keep";
		["Rotting Torso"] = "Keep";
		["Rune of Impetus"] = "Sell";
		["Rough Animal Pelt"] = "Sell";
		["Ruined Scaled Mantle"] = "Sell";
		["Ruby"] = "Sell";
		["Ruined Bear Pelt"] = "Sell";
		["Rotting Golden Tooth"] = "Sell";
		["Raw Fine Supple Runic Hide"] = "Keep";
		["Rune of the Astral"] = "Sell";
		["Rune of Ap`Sagor"] = "Sell";
		["Refined Binding Powder"] = "Sell";
		["Ruined Scaled Cape"] = "Sell";
		["Raw Amber Nihilite"] = "Keep";
		["Ringlet of the Fallen Spirit"] = "Keep";
		["Rubicite Ore"] = "Keep";
		["Remains of Brom"] = "Keep";
		["Razorfin Earring"] = "Trib";
		["Raw Supple Runic Hide"] = "Keep";
		["Rune of Frost"] = "Sell";
		["Ruined Animal Pelt"] = "Sell";
		["Rough Defiant Nihilite Shard"] = "Sell";
		["Rune of Concussion"] = "Sell";
		["Rough Defiant Longsword"] = "Sell";
		["Raw Faycite Crystal"] = "Keep";
		["Rune of Flash"] = "Sell";
	};
	["A"] = {
		["Aderirse Bur"] = "Sell";
	};
	["P"] = {
		["Pristine Animal Pelt"] = "Keep";
		["Pliant Loam"] = "Sell";
		["Pristine Silk"] = "Keep";
		["Porous Loam"] = "Sell";
		["Plated Nose Ring"] = "Sell";
		["Peridot"] = "Keep";
		["Puma Skin"] = "Sell";
	};
	["H"] = {
		["Harmonagate"] = "Sell";
		["High Quality Cat Pelt"] = "Sell";
	};
	["Q"] = {
	};
	["3"] = {
	};
	["X"] = {
	};
	["2"] = {
	};
	["Z"] = {
		["Zraxthril Forged Cutlass"] = "Sell";
		["Zraxthril Forged Mace"] = "Sell";
		["Zraxthril's Studded Earring"] = "Skip";
		["Zraxthril Forged Axe"] = "Sell";
		["Zraxthril Forged Flamberge"] = "Sell";
		["Zombie Skin"] = "Sell";
	};
	["C"] = {
		["Concentrated Grade A Nigriventer Venom"] = "Sell";
		["Cheirometric Lockpick Device"] = "Keep";
		["Curzon"] = "Sell";
		["Concentrated Grade A Choresine Sample"] = "Sell";
		["Cap of the Fallen Spirit"] = "Trib";
		["Crude Animal Pelt"] = "Sell";
		["Concentrated Grade B Choresine Sample"] = "Sell";
		["Concentrated Grade B Nigriventer Venom"] = "Sell";
		["Chronal Resonance Dust"] = "Keep";
		["Complex Gold Gem Dusted Rune"] = "Sell";
		["Concentrated Grade B Gormar Venom"] = "Sell";
		["Cobalt Ore"] = "Keep";
		["Concentrated Grade AA Choresine Sample"] = "Sell";
		["Cloth Bolt"] = "Keep";
		["Coarse Silk"] = "Keep";
		["Complex Platinum Silvered Rune"] = "Sell";
		["Crude Silk"] = "Sell";
		["Cloudy Potion"] = "Keep";
		["Crystallized Sulfur"] = "Sell";
		["Concentrated Grade A Gormar Venom"] = "Sell";
		["Complex Platinum Gem Dusted Rune"] = "Sell";
	};
	["U"] = {
		["Uncut Goshenite"] = "Sell";
		["Uncut Combine Star"] = "Sell";
		["Uncut Morganite"] = "Sell";
		["Uncut Amethyst"] = "Sell";
		["Urticaceae"] = "Sell";
	};
}
return obj1
