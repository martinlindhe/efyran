local mq = require("mq")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local commandQueue = require("lib/CommandQueue")
local log = require("knightlinc/Write")
local bci = broadCastInterfaceFactory()

local classSpells = {
    WAR = {
        Velious = { -- unsure if all of these belong to Velious
            "Throw Stone",                      -- L01 disc
            "Elbow Strike",                     -- L05 disc
            "Focused Will Discipline",          -- L10 disc
            "Provoke",                          -- L20 disc
            "Resistant Discipline",             -- L30 disc
            "Fearless Discipline",              -- L40 disc
            "Evasive Discipline",               -- L52 disc
            "Charge Discipline",                -- L53 disc
            "Mighty Strike Discipline",         -- L54 disc
            "Defensive Discipline",             -- L55 disc
            "Furious Discipline",               -- L56 disc
            "Precision Discipline",             -- L57 disc
            "Fellstrike Discipline",            -- L58 disc
            "Fortitude Discipline",             -- L59 disc
            "Aggressive Discipline",            -- L60 disc
        },
        PoP = {
            "Spirit of Rage Discipline",        -- L61 disc
            "Incite",                           -- L63 disc
        },
        LDoN = {
            "Bellow",                           -- L52 disc
            "Berate",                           -- L56 disc
        },
        GoD = {
            "Healing Will Discipline",          -- L63 disc
            "Stonewall Discipline",             -- L65 disc
            "Bellow of the Mastruq",            -- L65 disc
            "Ancient: Chaos Cry",               -- L65 disc
        },
        OOW = {
            "Aura of Runes Discipline",         -- L66 disc
            "Savage Onslaught Discipline",      -- L68 disc
            "Bazu Bellow",                      -- L69 disc
            "Shocking Defense Discipline",      -- L70 disc
        },
        DoN = {
            "Whirlwind Blade",                  -- L61 disc
            "Cyclone Blade",                    -- L69 disc
        },
        DoDH = {
            "Commanding Voice",                 -- L68 disc
        },
        PoR = {
            "Myrmidon's Aura",                  -- L55 aura
            "Champion's Aura",                  -- L70 aura
            "Mock",                             -- L70 disc
        },
    },
    BRD = {
        Original = {
            "Chant of Battle",                  -- L01
            "Chords of Dissonance",
            "Lyssa's Locating Lyric",
            "Selo's Accelerando",
            "Hymn of Restoration",
            "Jonthan's Whistling Warsong",
            "Kelin's Lugubrious Lament",
            "Elemental Rhythms",
            "Anthem de Arms",                   -- L10
            "Cinda's Charismatic Carillon",
            "Brusco's Boastful Bellow",
            "Purifying Rhythms",
            "Lyssa's Cataloging Libretto",
            "Kelin's Lucid Lullaby",
            "Tarew's Aquatic Ayre",
            "Guardian Rhythms",
            "Denon's Disruptive Discord",
            "Shauri's Sonorous Clouding",
            "Largo's Melodic Binding",          -- L20
            "Melanie's Mellifluous Motion",
            "Alenia's Disenchanting Melody",
            "Selo's Consonant Chain",
            "Lyssa's Veracious Concord",
            "Psalm of Warmth",
            "Angstlich's Appalling Screech",
            "Solon's Song of the Sirens",
            "Crission's Pixie Strike",
            "Psalm of Vitality",
            "Fufil's Curtailing Chant",         -- L30
            "Agilmente's Aria of Eagles",
            "Cassindra's Chorus of Clarity",
            "Psalm of Cooling",
            "Lyssa's Solidarity of Vision",
            "Denon's Dissension",
            "Vilia's Verses of Celerity",
            "Psalm of Purity",
            "Tuyen's Chant of Flame",
            "Syvelian's Anti-Magic Aria",       -- L40
            "Psalm of Mystic Shielding",
            "McVaxius' Berserker Crescendo",
            "Denon's Desperate Dirge",
            "Cassindra's Elegy",
            "Tuyen's Chant of Frost",
            "Niv's Melody of Preservation",
            "Selo's Chords of Cessation",
            "Verses of Victory",                -- L50
        },
        Kunark = {
            "Solon's Bewitching Bravura",       -- L39
            "Jonthan's Provocation",            -- L45
            "Shield of Songs",                  -- L49
            "Selo's Song of Travel",
            "Largo's Assonant Binding",
            "Nillipus' March of the Wee",
            "Song of Twilight",
            "Song of Dawn",
            "Vilia's Chorus of Celerity",
            "Selo's Assonant Strain",
            "Cantata of Replenishment",         -- L55
            "Brusco's Bombastic Bellow",        -- L55
            "Song of Highsun",
            "Song of Midnight",
            "McVaxius' Rousing Rondo",
            "Cassindra's Insipid Ditty",
            "Niv's Harmonic",
            "Jonthan's Inspiration",
            "Denon's Bereavement",
            "Solon's Charismatic Concord",
            "Kazumi's Note of Preservation",
            "Angstlich's Assonance",            -- L60
        },
        Velious = {
            "Cassindra's Chant of Clarity",     -- L20
            "Cantata of Soothing",              -- L34
            "Melody of Ervaj",                  -- L50
            "Resistant Discipline",             -- L51 disc
            "Fearless Discipline",              -- L54 disc
            "Deftdance Discipline",             -- L55 disc
            "Occlusion of Sound",               -- L55
            "Composition of Ervaj",             -- L60
            "Puretone Discipline",              -- L60 disc
        },
        Luclin = {
            "Magical Monologue",                -- L09
            "Song of Sustenance",               -- L15
            "Amplification",                    -- L30
            "Katta's Song of Sword Dancing",    -- L39
            "Sionachie's Dreams",               -- L40
            "Selo's Accelerating Chorus",       -- L49
            "Battlecry of the Vah Shir",        -- L52
            "Elemental Chorus",                 -- L54
            "Purifying Chorus",                 -- L56
            "Dreams of Ayonae",                 -- L58
            "Chorus of Replenishment",          -- L58
            "Ervaj's Lost Composition",         -- L60
            "Warsong of the Vah Shir",          -- L60
            "Ancient: Lcea's Lament",           -- L60
            "Ancient: Lullaby of Shadow",       -- L60
        },
        PoP = {
            "Tuyen's Chant of Disease",         -- L42
            "Tuyen's Chant of Poison",          -- L50
            "Silent Song of Quellious",         -- L61
            "Tuyen's Chant of the Plague",      -- L61
            "Saryrn's Scream of Pain",          -- L61
            "Dreams of Thule",                  -- L62
            "Druzzil's Disillusionment",        -- L62
            "Melody of Mischief",               -- L62
            "Warsong of Zek",                   -- L62
            "Wind of Marr",                     -- L62
            "Psalm of Veeshan",                 -- L63
            "Tuyen's Chant of Venom",           -- L63
            "Tuyen's Chant of Ice",             -- L63
            "Call of the Banshee",              -- L64
            "Chorus of Marr",                   -- L64
            "Dreams of Terris",                 -- L64
            "Requiem of Time",                  -- L64
            "Rizlona's Call of Flame",          -- L64
            "Tuyen's Chant of Fire",            -- L65
            "Harmony of Sound",                 -- L65
            "Lullaby of Morell",                -- L65
        },
        LoY = {
            "Aria of Asceticism",               -- L45
            "Aria of Innocence",                -- L52
        },
        LDoN = {
            "Selo's Rhythm of Speed",           -- L25
            "Rizlona's Embers",                 -- L45
            "Rizlona's Fire",                   -- L53
            "Fufil's Diminishing Dirge",        -- L60
            "Call of the Muse",                 -- L65
        },
        GoD = {
            "War March of the Mastruq",         -- L65
            "Echo of the Trusik",               -- L65
            "Dark Echo",                        -- L65
            "Ancient: Chaos Chant",             -- L65
        },
        OOW = {
            "Bellow of Chaos",                  -- L66
            "Luvwen's Aria of Serenity",        -- L66
            "Vulka's Chant of Disease",         -- L66
            "Angstlich's Wail of Panic",        -- L67
            "Cantata of Life",                  -- L67
            "Luvwen's Lullaby",                 -- L67
            "Vulka's Chant of Frost",           -- L67
            "Zuriki's Song of Shenanigans",     -- L67
            "Dirge of Metala",                  -- L68
            "Vulka's Chant of Poison",          -- L68
            "War March of Muram",               -- L68
            "Yelhun's Mystic Call",             -- L68
            "Chorus of Life",                   -- L69
            "Eriki's Psalm of Power",           -- L69
            "Verse of Vesagran",                -- L69
            "Voice of the Vampire",             -- L70
            "Vulka's Chant of Flame",           -- L70
            "Vulka's Lullaby",                  -- L70
            "Ancient: Call of Power",           -- L70
        },
        DoN = {
            "Song of the Storm",                -- L61
            "Angstlich's Echo of Terror",       -- L62
            "Storm Blade",                      -- L69
        },
        DoDH = {
            "Creeping Dreams",                  -- L68
            "Thousand Blades",                  -- L69 disc
        },
        PoR = {
            "Aura of Insight",                  -- L55 aura
            "Aura of the Muse",                 -- L70 aura
            "Arcane Aria",                      -- L70
        },
    },
    RNG = {
        Original = {
            "Endure Fire",                      -- L09
            "Flame Lick",
            "Glimpse",
            "Lull Animal",
            "Minor Healing",
            "Skin like Wood",
            "Snare",
            "Burst of Fire",                    -- L15
            "Camouflage",
            "Cure Poison",
            "Dance of the Fireflies",
            "Feet like Cat",
            "Grasping Roots",
            "Invoke Lightning",
            "Thistlecoat",
            "Bind Sight",                       -- L22
            "Enduring Breath",
            "Harmony",
            "Ignite",
            "Light Healing",
            "Skin like Rock",
            "Ward Summoned",
            "Barbcoat",                         -- L30
            "Cancel Magic",
            "Eyes of the Cat",
            "Invigor",
            "Shield of Thistles",
            "Stinging Swarm",
            "Strength of Earth",
            "Calm Animal",                      -- L39
            "Careless Lightning",
            "Dismiss Summoned",
            "Healing",
            "Levitate",
            "Skin like Steel",
            "Spirit of Wolf",
            "Bramblecoat",                       -- L49
            "Call of Flame",
            "Ensnaring Roots",
            "Immolate",
            "Resist Fire",
            "Shield of Brambles",
            "Superior Camouflage",
            "Wolf Form",
        },
        Kunark = {
            "Ensnare",                          -- L51
            "Extinguish Fatigue",               -- L52
            "Firestrike",                       -- L52
            "Storm Strength",                   -- L53
            "Drones of Doom",                   -- L54
            "Skin like Diamond",                -- L54
            "Chloroplast",                      -- L55
            "Jolt",                             -- L55
            "Chill Sight",                      -- L56
            "Greater Wolf Form",                -- L56
            "Greater Healing",                  -- L57
            "Shield of Spikes",                 -- L58
            "Dustdevil",                        -- L59
            "Enveloping Roots",                 -- L60
            "Thorncoat",                        -- L60
        },
        Velious = {
            "Endure Cold",                      -- L22
            "Firefist",                         -- L22
            "Panic Animal",                     -- L22
            "Call of Sky",                      -- L39
            "Spikecoat",                        -- L49
            "Call of Earth",                    -- L50

            "Strength of Nature",               -- L51
            "Call of Fire",                     -- L55
            "Cinder Jolt",                      -- L55
            "Resist Cold",                      -- L55
            "Nullify Magic",                    -- L58
            "Skin like Nature",                 -- L59
            "Call of the Predator",             -- L60
        }
    },
    PAL = {
        Original = {
            "Courage",                          -- L09
            "Cure Poison",
            "Flash of Light",
            "Minor Healing",
            "Spook the Dead",
            "True North",
            "Yaulp",
            "Cure Disease",                     -- L15
            "Hammer of Wrath",
            "Holy Armor",
            "Light Healing",
            "Lull",
            "Sense the Dead",
            "Ward Undead",
            "Center",                           -- L22
            "Endure Poison",
            "Halo of Light",
            "Invigor",
            "Invisibility vs. Undead",
            "Reckless Strength",
            "Root",
            "Expulse Undead",                   -- L30
            "Hammer of Striking",
            "Healing",
            "Soothe",
            "Spirit Armor",
            "Stun",
            "Symbol of Transal",
            "Cancel Magic",                     -- L39
            "Counteract Poison",
            "Daring",
            "Endure Disease",
            "Greater Healing",
            "Symbol of Ryltan",
            "Yaulp II",
            "Calm",                             -- L49
            "Dismiss Undead",
            "Guard",
            "Holy Might",
            "Revive",
            "Symbol of Pinzarn",
            "Valor",
        },
        Kunark = {
            "Divine Might",                     -- L49
            "Pacify",                           -- L51
            "Force",                            -- L52
            "Frenzied Strength",                -- L52
            "Armor of Faith",                   -- L53
            "Instill",                          -- L54
            "Expel Undead",                     -- L54
            "Divine Aura",                      -- L55
            "Divine Favor",                     -- L55
            "Counteract Disease",               -- L56
            "Yaulp III",                        -- L56
            "Symbol of Naltron",                -- L58
        },
        Velious = {
            "Endure Magic",                     -- L30
            "Divine Purpose",                   -- L39
            "Guard",                            -- L39
            "Flame of Light",                   -- L50
            "Resistant Discipline",             -- L51 disc
            "Resist Disease",                   -- L51
            "Divine Glory",                     -- L53
            "Fearless Discipline",              -- L54 disc
            "Holyforge Discipline",             -- L55 disc
            "Resist Magic",                     -- L55
            "Wave of Healing",                  -- L55
            "Superior Healing",                 -- L57
            "Nullify Magic",                    -- L58
            "Celestial Cleansing",              -- L59
            "Resurrection",                     -- L59
            "Sanctification Discipline",        -- L60 disc
            "Divine Strength",                  -- L60
            "Resolution",                       -- L60
            "Shield of Words",                  -- L60
            "Yaulp IV",                         -- L60
        },
        Luclin = {
            "Cease",                            -- L07
            "Desist",                           -- L13
            "Reanimation",                      -- L22 unsure
            "Instrument of Nife",               -- L26
            "Reconstitution",                   -- L30 unsure
            "Reparation",                       -- L31 unsure
            "Divine Vigor",                     -- L35
            "Valor of Marr",                    -- L44
            "Remove Curse",                     -- L45
            "Thunder of Karana",                -- L47
            "Renewal",                          -- L49 unsure
            "Quellious' Word of Tranquility",   -- L54
            "Restoration",                      -- L55
            "Breath of Tunare",                 -- L56
            "Healing Wave of Prexus",           -- L58
            "Celestial Cleansing",              -- L59
            "Brell's Mountainous Barrier",      -- L60
            "Remove Greater Curse",             -- L60
        },
        PoP = {
            "Wave of Life",                     -- L39
            "Brell's Steadfast Aegis",          -- L49
            "Force of Akera",                   -- L53
            "Greater Immobilize",               -- L61
            "Heroism",                          -- L61 unsure
            "Resist Poison",                    -- L61 unsure
            "Touch of Nife",                    -- L61
            "Crusader's Touch",                 -- L62
            "Force of Akilae",                  -- L62
            "Ward of Nife",                     -- L62
            "Deny Undead",                      -- L62
            "Improved Invisibility to Undead",  -- L63 unsure
            "Light of Nife",                    -- L63
            "Pious Might",                      -- L63
            "Symbol of Marzin",                 -- L63 unsure
            "Aura of the Crusader",             -- L64
            "Heroic Bond",                      -- L64 unsure
            "Quellious' Word of Serenity",      -- L64
            "Supernal Cleansing",               -- L64
            "Brell's Stalwart Shield",          -- L65
            "Bulwark of Faith",                 -- L65 unsure
            "Shackles of Tunare",               -- L65
            "Wave of Marr",                     -- L65
        },
        LoY = {
            "Ethereal Cleansing",               -- L44
            "Light of Life",                    -- L52
        },
        LDoN = {
            "Remove Minor Curse",               -- L19
            "Remove Lesser Curse",              -- L34
            "Austerity",                        -- L55
            "Blessing of Austerity",            -- L58
            "Guidance",                         -- L65
        },
        GoD = {
            "Salve",                            -- L01
            "Wave of Trushar",                  -- L65
            "Light of Order",                   -- L65
            "Holy Order",                       -- L65
            "Ancient: Force of Chaos",          -- L65
        },
        OOW = {
            "Direction",                        -- L66
            "Touch of Piety",                   -- L66
            "Force of Piety",                   -- L66
            "Crusader's Purity",                -- L67
            "Silvered Fury",                    -- L67
            "Spurn Undead",                     -- L67
            "Symbol of Jeron",                  -- L67
            "Pious Fury",                       -- L68
            "Light of Piety",                   -- L68
            "Serene Command",                   -- L68
            "Jeron's Mark",                     -- L68
            "Hand of Direction",                -- L69
            "Armor of the Champion",            -- L69
            "Pious Cleansing",                  -- L69
            "Bulwark of Piety",                 -- L69
            "Affirmation",                      -- L70
            "Brell's Brawny Bulwark",           -- L70
            "Wave of Piety",                    -- L70
            "Ancient: Force of Jeron",          -- L70
        },
        DoN = {
            "Guard of Piety",                   -- L56
            "Guard of Humility",                -- L61
            "Guard of Righteousness",           -- L69
        },
        DoDH = {
            "Last Rites",                       -- L68
            "Silent Piety",                     -- L69
        },
        PoR = {
            "Holy Aura",                        -- L55 aura
            "Blessed Aura",                     -- L70 aura
            "Ward of Tunare",                   -- L70
        },
    },
    CLR = {
        Original = {
            "Courage",                          -- L01
            "Cure Poison",
            "Divine Aura",
            "Flash of Light",
            "Lull",
            "Minor Healing",
            "Spook the Dead",
            "Strike",
            "True North",
            "Yaulp",
            "Cure Blindness",                   -- L05
            "Cure Disease",
            "Furor",
            "Gate",
            "Holy Armor",
            "Light Healing",
            "Reckless Strength",
            "Stun",
            "Summon Drink",
            "Ward Undead",
            "Center",                           -- L09
            "Endure Fire",
            "Endure Poison",
            "Fear",
            "Hammer of Wrath",
            "Invigor",
            "Root",
            "Sense the Dead",
            "Soothe",
            "Summon Food",
            "Word of Pain",
            "Bind Affinity",                    -- L14
            "Cancel Magic",
            "Endure Cold",
            "Endure Disease",
            "Expulse Undead",
            "Halo of Light",
            "Healing",
            "Invisibility vs. Undead",
            "Sense Summoned",
            "Smite",
            "Symbol of Transal",
            "Calm",                             -- L19
            "Daring",
            "Endure Magic",
            "Extinguish Fatigue",
            "Holy Might",
            "Spirit Armor",
            "Ward Summoned",
            "Word of Shadow",
            "Yaulp II",
            "Bravery",                          -- L24
            "Counteract Poison",
            "Dismiss Undead",
            "Greater Healing",
            "Hammer of Striking",
            "Inspire Fear",
            "Symbol of Ryltan",
            "Wave of Fear",
            "Abundant Drink",                   -- L29
            "Counteract Disease",
            "Divine Barrier",
            "Instill",
            "Expulse Summoned",
            "Guard",
            "Panic the Dead",
            "Revive",
            "Word of Spirit",
            "Wrath",
            "Abundant Food",                    -- L34
            "Atone",
            "Blinding Luminance",
            "Expel Undead",
            "Force",
            "Frenzied Strength",
            "Resist Fire",
            "Resist Poison",
            "Superior Healing",
            "Symbol of Pinzarn",
            "Tremor",
            "Valor",
            "Word of Health",
            "Armor of Faith",                   -- L39
            "Complete Heal",
            "Dismiss Summoned",
            "Invoke Fear",
            "Nullify Magic",
            "Pacify",
            "Resist Cold",
            "Resist Disease",
            "Resuscitate",
            "Word of Souls",
            "Banish Undead",                    -- L44
            "Earthquake",
            "Hammer of Requital",
            "Resist Magic",
            "Resolution",
            "Retribution",
            "Symbol of Naltron",
            "Yaulp III",
            "Abolish Poison",                   -- L49
            "Expel Summoned",
            "Immobilize",
            "Resurrection",
            "Shield of Words",
            "Sound of Force",
            "Word Divine",
            "Word of Healing",
        },
        Kunark = {
            "Imbue Amber",                      -- L29: Cazic-Thule
            "Imbue Black Pearl",                -- L29: Prexus
            "Imbue Black Sapphire",             -- L29: Bertoxxulous
            "Imbue Diamond",                    -- L29: Mithaniel Marr
            "Imbue Emerald",                    -- L29: Tunare
            "Imbue Opal",                       -- L29: Rodcet Nife
            "Imbue Peridot",                    -- L29: Bristlebane
            "Imbue Plains Pebble",              -- L29: Karana
            "Imbue Rose Quartz",                -- L29: Erollisi Marr
            "Imbue Ruby",                       -- L29: Brell Serilis
            "Imbue Sapphire",                   -- L29: Innoruuk
            "Imbue Topaz",                      -- L29: Quellious
            "Death Pact",                       -- L51
            "Dread of Night",                   -- L51
            "Remedy",                           -- L51
            "Sunskin",                          -- L51
            "Heroic Bond",                      -- L52
            "Heroism",                          -- L52
            "Upheaval",                         -- L52
            "Word of Vigor",                    -- L52
            "Annul Magic",                      -- L53
            "Divine Light",                     -- L53
            "Yaulp IV",                         -- L53
            "Reckoning",                        -- L54
            "Symbol of Marzin",                 -- L54
            "Unswerving Hammer of Faith",       -- L54
            "Exile Undead",                     -- L55
            "Fortitude",                        -- L55
            "Wake of Tranquility",              -- L55
            "Banish Summoned",                  -- L56
            "Mark of Karn",                     -- L56
            "Paralyzing Earth",                 -- L56
            "Reviviscence",                     -- L56
            "Aegis",                            -- L57
            "Bulwark of Faith",                 -- L57
            "Trepidation",                      -- L57
            "Word of Restoration",              -- L57
            "Antidote",                         -- L58
            "Enforced Reverence",               -- L58
            "Naltron's Mark",                   -- L58
            "Celestial Elixir",                 -- L59
            "The Unspoken Word",                -- L59
            "Banishment of Shadows",            -- L60
            "Divine Intervention",              -- L60
            "Word of Redemption",               -- L60
        },
        Velious = {
            "Armor of Protection",              -- L34
            "Turning of the Unnatural",         -- L39
            "Celestial Healing",                -- L44
            "Improved Invisibility to Undead",  -- L50
            "Stun Command",                     -- L55
            "Aegolism",                         -- L60
        },
    },
    DRU = {
        Original = {
            "Burst of Flame",                   -- L01
            "Dance of the Fireflies",
            "Endure Fire",
            "Flame Lick",
            "Lull Animal",
            "Minor Healing",
            "Panic Animal",
            "Sense Animals",
            "Skin like Wood",
            "Snare",
            "Burst of Fire",                    -- L05
            "Camouflage",
            "Cure Disease",
            "Cure Poison",
            "Gate",
            "Grasping Roots",
            "Harmony",
            "Invoke Lightning",
            "Ward Summoned",
            "Whirling Wind",
            "Endure Cold",                      -- L09
            "Enduring Breath",
            "Firefist",
            "Ignite",
            "Invisibility versus Animals",
            "Light Healing",
            "Shield of Thistles",
            "Starshine",
            "Strength of Earth",
            "Thistlecoat",
            "Treeform",
            "Befriend Animal",                  -- L14
            "Bind Affinity",
            "Cascade of Hail",
            "Expulse Summoned",
            "Halo of Light",
            "Levitate",
            "See Invisible",
            "Skin like Rock",
            "Spirit of Wolf",
            "Stinging Swarm",
            "Summon Drink",
            "Summon Food",
            "Barbcoat",                         -- L19
            "Calm Animal",
            "Cancel Magic",
            "Careless Lightning",
            "Dizzying Wind",
            "Endure Disease",
            "Endure Poison",
            "Feral Spirit",
            "Healing",
            "Ring of Butcher",
            "Ring of Commons",
            "Ring of Karana",
            "Ring of Toxxulia",
            "Shield of Barbs",
            "Superior Camouflage",
            "Terrorize Animal",
            "Charm Animals",                    -- L24
            "Creeping Crud",
            "Dismiss Summoned",
            "Ensnaring Roots",
            "Pogonip",
            "Resist Fire",
            "Ring of Feerrott",
            "Ring of Lavastorm",
            "Ring of Ro",
            "Ring of Steamfont",
            "Skin like Steel",
            "Spirit of Cheetah",
            "Sunbeam",
            "Tremor",
            "Wolf Form",
            "Bramblecoat",                       -- L29
            "Circle of Butcher",
            "Circle of Commons",
            "Circle of Karana",
            "Circle of Toxxulia",
            "Combust",
            "Counteract Disease",
            "Counteract Poison",
            "Ensnare",
            "Greater Healing",
            "Immolate",
            "Ring of Misty",
            "Shield of Brambles",
            "Succor: East",
            "Beguile Animals",                  -- L34
            "Circle of Feerrott",
            "Circle of Lavastorm",
            "Circle of Ro",
            "Circle of Steamfont",
            "Drones of Doom",
            "Earthquake",
            "Endure Magic",
            "Expel Summoned",
            "Greater Wolf Form",
            "Lightning Strike",
            "Regeneration",
            "Resist Cold",
            "Strength of Stone",
            "Succor: Butcher",
            "Avalanche",                        -- L39
            "Circle of Misty",
            "Enveloping Roots",
            "Firestrike",
            "Pack Regeneration",
            "Pack Spirit",
            "Share Wolf Form",
            "Shield of Spikes",
            "Skin like Diamond",
            "Spikecoat",
            "Succor: Ro",
            "Allure of the Wild",               -- L44
            "Banish Summoned",
            "Chloroplast",
            "Drifting Death",
            "Form of the Great Wolf",
            "Nullify Magic",
            "Resist Disease",
            "Resist Poison",
            "Savage Spirit",
            "Storm Strength",
            "Succor: Lavastorm",
            "Engulfing Roots",                  -- L49
            "Fire",
            "Ice",
            "Lightning Blast",
            "Pack Chloroplast",
            "Resist Magic",
            "Shield of Thorns",
            "Skin like Nature",
            "Starfire",
            "Succor: North",
            "Thorncoat",
        },
        Kunark = {
            "Scale of Wolf",                    -- L24
            "Beguile Plants",                   -- L29
            "Imbue Emerald",                    -- L29
            "Imbue Plains Pebble",              -- L29
            "Circle of the Combines",           -- L34
            "Wind of the North",                -- L39
            "Wind of the South",                -- L39
            "Calefaction",                      -- L44
            "Circle of Winter",                 -- L51
            "Legacy of Spike",                  -- L51
            "Repulse Animal",                   -- L51
            "Upheaval",                         -- L51
            "Breath of Ro",                     -- L52
            "Call of Karana",                   -- L52
            "Circle of Summer",                 -- L52
            "Egress",                           -- L52
            "Glamour of Tunare",                -- L53
            "Spirit of Scale",                  -- L53
            "Superior Healing",                 -- L53
            "Winged Death",                     -- L53
            "Blizzard",                         -- L54
            "Form of the Howler",               -- L54
            "Regrowth",                         -- L54
            "Scoriae",                          -- L54
            "Annul Magic",                      -- L55
            "Exile Summoned",                   -- L55
            "Girdle of Karana",                 -- L55
            "Tunare's Request",                 -- L55
            "Bladecoat",                        -- L56
            "Breath of Karana",                 -- L56
            "Engorging Roots",                  -- L56
            "Wake of Karana",                   -- L56
            "Bonds of Tunare",                  -- L57
            "Frost",                            -- L57
            "Natureskin",                       -- L57
            "Succor",                           -- L57
            "Fist of Karana",                   -- L58
            "Regrowth of the Grove",            -- L58
            "Shield of Blades",                 -- L58
            "Legacy of Thorn",                  -- L59
            "Spirit of Oak",                    -- L59
            "Wildfire",                         -- L59
            "Banishment",                       -- L60
            "Entrapping Roots",                 -- L60
            "Form of the Hunter",               -- L60
            "Mask of the Hunter",               -- L60
        },
        Velious = {
            "Ring of the Combines",             -- L24
            "Ring of Surefall Glade",           -- L24
            "Circle of Surefall Glade",         -- L29
            "Circle of Iceclad",                -- L34
            "Fury of Air",                      -- L34
            "Ring of Great Divide",             -- L34
            "Ring of Iceclad",                  -- L34
            "Circle of Great Divide",           -- L39
            "Ring of Cobalt Scar",              -- L39
            "Ring of Wakening Lands",           -- L39
            "Ro's Fiery Sundering",             -- L39
            "Circle of Cobalt Scar",            -- L44
            "Circle of Wakening Lands",         -- L44
            "Fixation of Ro",                   -- L44
            "Improved Superior Camouflage",     -- L50
            "Chloroblast",                      -- L55
            "Nature Walker's Behest",           -- L55          XXX L255 on FVP, nov 2
            "Nature's Touch",                   -- L60
            "Protection of the Glades",         -- L60
        },
    },
    SHM = {
        Original = {
            "Burst of Flame",                   -- L01
            "Cure Disease",
            "Dexterous Aura",
            "Endure Cold",
            "Flash of Light",
            "Inner Fire",
            "Minor Healing",
            "Strengthen",
            "True North",
            "Cure Poison",                      -- L05
            "Drowsy",
            "Endure Fire",
            "Feet like Cat",
            "Fleeting Fury",
            "Frost Rift",
            "Gate",
            "Scale Skin",
            "Sicken",
            "Spirit Pouch",
            "Summon Drink",
            "Cure Blindness",                   -- L09
            "Endure Disease",
            "Light Healing",
            "Sense Animals",
            "Serpent Sight",
            "Spirit of Bear",
            "Spirit of Wolf",
            "Spirit Sight",
            "Summon Food",
            "Tainted Breath",
            "Bind Affinity",                    -- L14
            "Burst of Strength",
            "Disempower",
            "Endure Poison",
            "Enduring Breath",
            "Invisibility versus Animals",
            "Levitate",
            "Root",
            "Spirit of Snake",
            "Spirit Strike",
            "Turtle Skin",
            "Walking Sleep",
            "Affliction",                       -- L19
            "Cancel Magic",
            "Endure Magic",
            "Frenzy",
            "Healing",
            "Infectious Cloud",
            "Insidious Fever",
            "Malaise",
            "Shrink",
            "Spirit of Cat",
            "Spirit Strength",
            "Vision",
            "Cannibalize",                      -- L24
            "Counteract Disease",
            "Creeping Vision",
            "Envenomed Breath",
            "Frost Strike",
            "Invigor",
            "Poison Storm",
            "Protect",
            "Regeneration",
            "Resist Cold",
            "Spirit of Cheetah",
            "Spirit of Monkey",
            "Spirit of Ox",
            "Alluring Aura",                    -- L29
            "Befriend Animal",
            "Counteract Poison",
            "Greater Healing",
            "Invisibility",
            "Listless Power",
            "Quickness",
            "Raging Strength",
            "Resist Fire",
            "Rising Dexterity",
            "Tagar's Insects",
            "Ultravision",
            "Companion Spirit",                 -- L34
            "Fury",
            "Health",
            "Instill",
            "Malaisement",
            "Nimble",
            "Resist Disease",
            "Scourge",
            "Shifting Shield",
            "Talisman of Tnarg",
            "Winter's Roar",
            "Assiduous Vision",                 -- L39
            "Blinding Luminance",
            "Chloroplast",
            "Deftness",
            "Extinguish Fatigue",
            "Furious Strength",
            "Gale of Poison",
            "Glamour",
            "Insidious Malady",
            "Resist Poison",
            "Togor's Insects",
            "Venom of the Snake",
            "Vigilant Spirit",
            "Agility",                          -- L44
            "Alacrity",
            "Blizzard Blast",
            "Guardian",
            "Guardian Spirit",
            "Incapacitate",
            "Nullify Magic",
            "Resist Magic",
            "Stamina",
            "Talisman of Altuna",
            "Abolish Disease",                  -- L49
            "Charisma",
            "Dexterity",
            "Envenomed Bolt",
            "Frenzied Spirit",
            "Malosi",
            "Plague",
            "Rage",
            "Strength",
        },
        Kunark = {
            "Scale of Wolf",                    -- L24
            "Imbue Amber",                      -- L29: Cazic-Thule
            "Imbue Ivory",                      -- L29: The Tribunal
            "Imbue Jade",                       -- L29: Rallos Zek
            "Imbue Sapphire",                   -- L29: Innoruuk
            "Charm Animals",                    -- L34
            "Cannibalize II",                   -- L39
            "Immobilize",                       -- L51
            "Talisman of Jasinth",              -- L51
            "Turgur's Insects",                 -- L51
            "Insidious Decay",                  -- L52
            "Regrowth",                         -- L52
            "Spirit of Scale",                  -- L52
            "Cripple",                          -- L53
            "Deliriously Nimble",               -- L53
            "Superior Healing",                 -- L53
            "Talisman of Shadoo",               -- L53
            "Cannibalize III",                  -- L54
            "Ice Strike",                       -- L54
            "Riotous Health",                   -- L54
            "Shroud of the Spirits",            -- L54
            "Annul Magic",                      -- L55
            "Spirit of the Howler",             -- L55
            "Talisman of Kragg",                -- L55
            "Torrent of Poison",                -- L55
            "Acumen",                           -- L56
            "Bane of Nife",                     -- L56
            "Celerity",                         -- L56
            "Paralyzing Earth",                 -- L56
            "Malosini",                         -- L57
            "Maniacal Strength",                -- L57
            "Talisman of the Brute",            -- L57
            "Talisman of the Cat",              -- L57
            "Mortal Deftness",                  -- L58
            "Talisman of the Rhino",            -- L58
            "Talisman of the Serpent",          -- L58
            "Tigir's Insects",                  -- L58
            "Pox of Bertoxxulous",              -- L59
            "Talisman of the Raptor",           -- L59
            "Unfailing Reverence",              -- L59
            "Voice of the Berserker",           -- L59
            "Avatar",                           -- L60
            "Malo",                             -- L60
            "Torpor",                           -- L60
        },
        Velious = {
            "Shock of the Tainted",             -- L34
            "Tumultuous Strength",              -- L39
            "Blast of Poison",                  -- L44
            "Summon Companion",                 -- L44
            "Spirit Quickening",                -- L50
            "Chloroblast",                      -- L55
            "Form of the Great Bear",           -- L55
            "Cannibalize IV",                   -- L58
            "Focus of Spirit",                  -- L60
            "Primal Avatar",                    -- L60
        },
    },
    SHD = {
        Original = {
            "Disease Cloud",                    -- L09
            "Invisibility vs. Undead",
            "Leering Corpse",
            "Lifetap",
            "Locate Corpse",
            "Sense the Dead",
            "Siphon Strength",
            "Bone Walk",                        -- L15
            "Clinging Darkness",
            "Endure Cold",
            "Fear",
            "Lifespike",
            "Numb the Dead",
            "Shadow Step",
            "Convoke Shadow",                   -- L22
            "Dark Empathy",
            "Deadeye",
            "Engulfing Darkness",
            "Spook the Dead",
            "Vampiric Embrace",
            "Ward Undead",
            "Endure Disease",                   -- L30
            "Feign Death",
            "Gather Shadows",
            "Heat Blood",
            "Lifedraw",
            "Restless Bones",
            "Wave of Enfeeblement",
            "Animate Dead",                     -- L39
            "Cancel Magic",
            "Expulse Undead",
            "Heart Flutter",
            "Resist Cold",
            "Shadow Vortex",
            "Shieldskin",
            "Breath of the Dead",               -- L49
            "Dismiss Undead",
            "Dooming Darkness",
            "Invoke Fear",
            "Life Leech",
            "Shadow Sight",
            "Summon Dead",
            "Word of Spirit",
        },
        Kunark = {
            "Siphon Life",                      -- L51
            "Malignant Dead",                   -- L52
            "Rest the Dead",                    -- L52
            "Boil Blood",                       -- L53
            "Banshee Aura",                     -- L54
            "Panic the Dead",                   -- L54
            "Bobbing Corpse",                   -- L55
            "Expel Undead",                     -- L55
            "Steelskin",                        -- L56
            "Spirit Tap",                       -- L56
            "Vampiric Curse",                   -- L57
            "Cackling Bones",                   -- L58
            "Nullify Magic",                    -- L58
            "Cascading Darkness",               -- L59
            "Asystole",                         -- L60
            "Drain Spirit",                     -- L60
        },
        Velious = {
            "Grim Aura",                        -- L22
            "Strengthen Death",                 -- L29
            "Shroud of Hate",                   -- L39
            "Shroud of Pain",                   -- L50
            "Resistant Discipline",             -- L51 disc
            "Summon Corpse",                    -- L51
            "Summon Companion",                 -- L52
            "Fearless Discipline",              -- L54 disc
            "Unholy Aura Discipline",           -- L55 disc
            "Shroud of Death",                  -- L55
            "Shroud of Undeath",                -- L55
            "Diamondskin",                      -- L59
            "Leechcurse Discipline",            -- L60 disc
            "Drain Soul",                       -- L60
            "Death Peace",                      -- L60
        },
        Luclin = {
            "Despair",                          -- L09
            "Lesser Summon Corpse",             -- L12 unsure
            "Scream of Hate",                   -- L15
            "Cure Disease",                     -- L19 unsure
            "Scream of Pain",                   -- L23
            "Terror of Darkness",               -- L33
            "Scream of Death",                  -- L37
            "Voice of Darkness",                -- L39
            "Terror of Shadows",                -- L42
            "Voice of Shadows",                 -- L46
            "Harmshield",                       -- L50 unsure
            "Abduction of Strength",            -- L52
            "Mental Corruption",                -- L52
            "Terror of Death",                  -- L53
            "Torrent of Hate",                  -- L54
            "Voice of Death",                   -- L55
            "Torrent of Pain",                  -- L56
            "Conjure Corpse",                   -- L57 unsure
            "Torrent of Fatigue",               -- L58
            "Deathly Temptation",               -- L58
            "Terror of Terris",                 -- L59
            "Augment Death",                    -- L60 unsure
            "Cloak of the Akheva",              -- L60
            "Voice of Terris",                  -- L60
        },
        PoP = {
            "Spike of Disease",                 -- L01
            "Tiny Companion",                   -- L19
            "Spear of Disease",                 -- L34
            "Spear of Pain",                    -- L48
            "Spear of Plague",                  -- L54
            "Aura of Darkness",                 -- L61
            "Festering Darkness",               -- L61
            "Improved Invisibility to Undead",  -- L61 unsure
            "Ignite Blood",                     -- L61 unsure
            "Bond of Death",                    -- L62 unsure
            "Touch of Volatis",                 -- L62
            "Zevfeer's Bite",                   -- L62
            "Deny Undead",                      -- L62
            "Shroud of Chaos",                  -- L63
            "Aura of Pain",                     -- L63
            "Terror of Thule",                  -- L63
            "Blood of Hate",                    -- L63
            "Augmentation of Death",            -- L64 unsure
            "Invoke Death",                     -- L64 unsure
            "Pact of Hate",                     -- L64
            "Spear of Decay",                   -- L64
            "Voice of Thule",                   -- L65
            "Aura of Hate",                     -- L65
            "Touch of Innoruuk",                -- L65
            "Cloak of Luclin",                  -- L65
        },
        LoY = {
            "Blood of Pain",                    -- L41
            "Comatose",                         -- L52
        },
        LDoN = {
            "Dark Temptation",                  -- L32
            "Scythe of Darkness",               -- L47
            "Call of Darkness",                 -- L54
            "Scythe of Death",                  -- L54
            "Scythe of Innoruuk",               -- L64
        },
        GoD = {
            "Mental Horror",                    -- L65
            "Black Shroud",                     -- L65
            "Miasmic Spear",                    -- L65
            "Ancient: Bite of Chaos",           -- L65
        },
        OOW = {
            "Blood of Discord",                 -- L66
            "Dark Constriction",                -- L66
            "Bond of Inruku",                   -- L66
            "Soulless Terror",                  -- L66
            "Touch of Inruku",                  -- L67
            "Inruku's Bite",                    -- L67
            "Shroud of Discord",                -- L67
            "Terror of Discord",                -- L67
            "Shadow Howl",                      -- L67
            "Theft of Pain",                    -- L68
            "Blood of Inruku",                  -- L68
            "Son of Decay",                     -- L68
            "Scythe of Inruku",                 -- L68
            "Rune of Decay",                    -- L69
            "Pact of Decay",                    -- L69
            "Spear of Muram",                   -- L69
            "Dread Gaze",                       -- L69
            "Theft of Hate",                    -- L70
            "Touch of the Devourer",            -- L70
            "Cloak of Discord",                 -- L70
            "Ancient: Bite of Muram",           -- L70
        },
        DoN = {
            "Soulless Fear",                    -- L56
            "Ichor Guard",                      -- L56
            "Shadow Voice",                     -- L57
            "Soul Guard",                       -- L61
            "Soulless Panic",                   -- L61
            "Shadow Bellow",                    -- L62
            "Soul Shield",                      -- L69
        },
        DoDH = {
            "Fickle Shadows",                   -- L68
            "Touch of Draygun",                 -- L69
            "Gift of Draygun",                  -- L69
        },
        PoR = {
            "Decrepit Skin",                    -- L70
            "Theft of Agony",                   -- L70
        },
    },
    ENC = {
        Original = {
            "Lull",                             -- L01
            "Minor Illusion",
            "Minor Shielding",
            "Pendril's Animation",
            "Reclaim Energy",
            "Shallow Breath",
            "Strengthen",
            "Taper Enchantment",
            "True North",
            "Weaken",
            "Color Flux",                       -- L04
            "Enfeeblement",
            "Fear",
            "Gate",
            "Haze",
            "Illusion: Half-Elf",
            "Illusion: Human",
            "Invisibility",
            "Juli's Animation",
            "Mesmerize",
            "Suffocating Sphere",
            "Tashina",
            "Alliance",                         -- L08
            "Bind Sight",
            "Cancel Magic",
            "Chaotic Feedback",
            "Enchant Silver",
            "Eye of Confusion",
            "Illusion: Gnome",
            "Illusion: Wood Elf",
            "Lesser Shielding",
            "Mircyl's Animation",
            "Root",
            "See Invisible",
            "Sentinel",
            "Soothe",
            "Bind Affinity",                    -- L12
            "Charm",
            "Choke",
            "Ebbing Strength",
            "Enduring Breath",
            "Illusion: Dark Elf",
            "Illusion: Erudite",
            "Illusion: Halfling",
            "Illusion: High Elf",
            "Kilan's Animation",
            "Languid Pace",
            "Memory Blur",
            "Mist",
            "Serpent Sight",
            "Thicken Mana",
            "Whirl till you hurl",
            "Chase the Moon",                   -- L16
            "Disempower",
            "Enchant Electrum",
            "Enthrall",
            "Identify",
            "Illusion: Barbarian",
            "Illusion: Dwarf",
            "Illusion: Tree",
            "Invisibility vs. Undead",
            "Levitate",
            "Mesmerization",
            "Quickness",
            "Rune I",
            "Sanity Warp",
            "Shalee's Animation",
            "Shielding",
            "Benevolence",                      -- L20
            "Berserker Strength",
            "Calm",
            "Cloud",
            "Color Shift",
            "Crystallize Mana",
            "Endure Magic",
            "Feckless Might",
            "Illusion: Ogre",
            "Illusion: Troll",
            "Shifting Sight",
            "Sisna's Animation",
            "Sympathetic Aura",
            "Tashani",
            "Alacrity",                         -- L24
            "Beguile",
            "Chaos Flux",
            "Enchant Gold",
            "Illusion: Earth Elemental",
            "Illusion: Skeleton",
            "Invigor",
            "Major Shielding",
            "Rune II",
            "Sagar's Animation",
            "Strip Enchantment",
            "Tepid Deeds",
            "Augmentation",                     -- L29
            "Clarify Mana",
            "Clarity",
            "Curse of the Simple Mind",
            "Dyn's Dizzying Draught",
            "Feedback",
            "Illusion: Air Elemental",
            "Illusion: Water Elemental",
            "Enstill",
            "Listless Power",
            "Nullify Magic",
            "Obscure",
            "Suffocate",
            "Uleen's Animation",
            "Ultravision",
            "Anarchy",                          -- L34
            "Boltran's Animation",
            "Cast Sight",
            "Enchant Platinum",
            "Entrance",
            "Greater Shielding",
            "Illusion: Fire Elemental",
            "Insipid Weakness",
            "Mana Sieve",
            "Radiant Visage",
            "Rune III",
            "Aanya's Animation",                -- L39
            "Cajoling Whispers",
            "Celerity",
            "Distill Mana",
            "Gravity Flux",
            "Illusion: Dry Bone",
            "Illusion: Spirit Wolf",
            "Immobilize",
            "Insight",
            "Invoke Fear",
            "Mind Wipe",
            "Pacify",
            "Rampage",
            "Resist Magic",
            "Shade",
            "Arch Shielding",                   -- L44
            "Brilliance",
            "Color Skew",
            "Discordant Mind",
            "Extinguish Fatigue",
            "Illusion: Werewolf",
            "Incapacitate",
            "Pillage Enchantment",
            "Rune IV",
            "Shiftless Deeds",
            "Tashania",
            "Weakness",
            "Yegoreff's Animation",
            "Adorning Grace",                   -- L49
            "Allure",
            "Berserker Spirit",
            "Blanket of Forgetfulness",
            "Dazzle",
            "Gasping Embrace",
            "Group Resist Magic",
            "Kintaz's Animation",
            "Paralyzing Earth",
            "Purify Mana",
            "Reoccurring Amnesia",
            "Shadow",
            "Swift like the Wind",
        },
        Kunark = {
            "Breeze",                           -- L16
            "Illusion: Iksar",                  -- L20
            "Enchant Adamantite",               -- L49
            "Enchant Brellium",                 -- L49
            "Enchant Mithril",                  -- L49
            "Enchant Steel",                    -- L49
            "Collaboration",                    -- L51
            "Theft of Thought",                 -- L51
            "Wake of Tranquility",              -- L51
            "Boon of the Clear Mind",           -- L52
            "Color Slant",                      -- L52
            "Fascination",                      -- L52
            "Rune V",                           -- L52
            "Aanya's Quickening",               -- L53
            "Boltran's Agacerie",               -- L53
            "Cripple",                          -- L53
            "Recant Magic",                     -- L53
            "Clarity II",                       -- L54
            "Dementia",                         -- L54
            "Glamour of Kintaz",                -- L54
            "Shield of the Magi",               -- L54
            "Largarn's Lamentation",            -- L55
            "Memory Flux",                      -- L55
            "Wind of Tashani",                  -- L55
            "Zumaik's Animation",               -- L55
            "Augment",                          -- L56
            "Overwhelming Splendor",            -- L56
            "Torment of Argli",                 -- L56
            "Trepidation",                      -- L56
            "Enlightenment",                    -- L57
            "Forlorn Deeds",                    -- L57
            "Tashanian",                        -- L57
            "Umbra",                            -- L57
            "Bedlam",                           -- L58
            "Fetter",                           -- L58
            "Wondrous Rapidity",               -- L58
            "Asphyxiate",                       -- L59
            "Gift of Pure Thought",             -- L59
            "Rapture",                          -- L59
            "Dictate",                          -- L60
            "Visions of Grandeur",              -- L60
            "Wind of Tashanian",                -- L60
        },
        Velious = {
            "Enchant Clay",                     -- L08
            "Gift of Magic",                    -- L34
            "Wandering Mind",                   -- L39
            "Boon of the Garou",                -- L44
            "Enchant Velium",                   -- L44
            "Summon Companion",                 -- L44
            "Improved Invisibility",            -- L50
            "Gift of Insight",                  -- L55
            "Gift of Brilliance",               -- L60
        },
    },
    MAG = {
        Original = {
            "Burst of Flame",                   -- L01
            "Flare",
            "Minor Shielding",
            "Reclaim Energy",
            "Summon Dagger",
            "Summon Drink",
            "Summon Food",
            "True North",
            "Burn",                             -- L04
            "Elementalkin: Air",
            "Elementalkin: Earth",
            "Elementalkin: Fire",
            "Elementalkin: Water",
            "Fire Flux",
            "Gate",
            "Sense Summoned",
            "Summon Bandages",
            "Summon Wisp",
            "Dimensional Pocket",               -- L08
            "Elementaling: Air",
            "Elementaling: Earth",
            "Elementaling: Fire",
            "Elementaling: Water",
            "Eye of Zomm",
            "Flame Bolt",
            "Invisibility",
            "Lesser Shielding",
            "Shield of Fire",
            "Shock of Blades",
            "Staff of Tracing",
            "Bind Affinity",                    -- L12
            "Burnout",
            "Cancel Magic",
            "Column of Fire",
            "Elemental: Air",
            "Elemental: Earth",
            "Elemental: Fire",
            "Elemental: Water",
            "Rain of Blades",
            "Summon Fang",
            "Ward Summoned",
            "Identify",                         -- L16
            "Minor Summoning: Air",
            "Minor Summoning: Earth",
            "Minor Summoning: Fire",
            "Minor Summoning: Water",
            "Phantom Leather",
            "See Invisible",
            "Shielding",
            "Shock of Flame",
            "Staff of Warding",
            "Summon Heatstone",
            "Summon Throwing Dagger",
            "Bolt of Flame",                    -- L20
            "Elemental Shield",
            "Expulse Summoned",
            "Lesser Summoning: Air",
            "Lesser Summoning: Earth",
            "Lesser Summoning: Fire",
            "Lesser Summoning: Water",
            "Rain of Fire",
            "Renew Summoning",
            "Shield of Flame",
            "Spear of Warding",
            "Summon Arrows",
            "Summon Waterstone",
            "Cornucopia",                       -- L24
            "Everfount",
            "Flame Flux",
            "Major Shielding",
            "Malaise",
            "Shock of Spikes",
            "Staff of Runes",
            "Summoning: Air",
            "Summoning: Earth",
            "Summoning: Fire",
            "Summoning: Water",
            "Burnout II",                       -- L29
            "Dismiss Summoned",
            "Greater Summoning: Air",
            "Greater Summoning: Earth",
            "Greater Summoning: Fire",
            "Greater Summoning: Water",
            "Inferno Shield",
            "Phantom Chain",
            "Rain of Spikes",
            "Summon Coldstone",
            "Sword of Runes",
            "Blaze",                            -- L34
            "Cinder Bolt",
            "Dimensional Hole",
            "Greater Shielding",
            "Minor Conjuration: Air",
            "Minor Conjuration: Earth",
            "Minor Conjuration: Fire",
            "Minor Conjuration: Water",
            "Nullify Magic",
            "Staff of Symbols",
            "Barrier of Combustion",            -- L39
            "Dagger of Symbols",
            "Expel Summoned",
            "Flame Arc",
            "Lesser Conjuration: Air",
            "Lesser Conjuration: Earth",
            "Lesser Conjuration: Fire",
            "Lesser Conjuration: Water",
            "Rain of Lava",
            "Summon Ring of Flight",
            "Arch Shielding",                   -- L44
            "Conjuration: Air",
            "Conjuration: Earth",
            "Conjuration: Fire",
            "Conjuration: Water",
            "Elemental Armor",
            "Malaisement",
            "Modulating Rod",
            "Phantom Plate",
            "Shock of Swords",
            "Banish Summoned",                  -- L49
            "Burnout III",
            "Greater Conjuration: Air",
            "Greater Conjuration: Earth",
            "Greater Conjuration: Fire",
            "Greater Conjuration: Water",
            "Lava Bolt",
            "Rain of Swords",
            "Shield of Lava",
        },
        Kunark = {
            "Renew Elements",                   -- L08
            "Summon Orb",                       -- L46
            "Gift of Xev",                      -- L51
            "Malosi",                           -- L51
            "Scintillation",                    -- L51
            "Vocarate: Earth",                  -- L51
            "Bristlebane's Bundle",             -- L52
            "Char",                             -- L52
            "Phantom Armor",                    -- L52
            "Vocarate: Fire",                   -- L52
            "Annul Magic",                      -- L53
            "Boon of Immolation",               -- L53
            "Quiver of Marr",                   -- L53
            "Vocarate: Air",                    -- L53
            "Bandoleer of Luclin",              -- L54
            "Scars of Sigil",                   -- L54
            "Shield of the Magi",               -- L54
            "Vocarate: Water",                  -- L54
            "Call of the Hero",                 -- L55
            "Pouch of Quellious",               -- L55
            "Rage of Zomm",                     -- L55
            "Sirocco",                          -- L55
            "Cadeau of Flame",                  -- L56
            "Dyzil's Deafening Decoy",          -- L56
            "Exile Summoned",                   -- L56
            "Muzzle of Mardu",                  -- L56
            "Eye of Tallon",                    -- L57
            "Greater Vocaration: Earth",        -- L57
            "Shock of Steel",                   -- L57
            "Greater Vocaration: Fire",         -- L58
            "Malosini",                         -- L58
            "Velocity",                         -- L58
            "Greater Vocaration: Air",          -- L59
            "Manastorm",                        -- L59
            "Seeking Flame of Seukor",          -- L59
            "Aegis of Ro",                      -- L60
            "Banishment",                       -- L60
            "Greater Vocaration: Water",        -- L60
            "Mala",                             -- L60
        },
        Velious = {
            "Expedience",                       -- L29
            "Monster Summoning I",              -- L34
            "Summon Shard of the Core",         -- L34
            "Summon Companion",                 -- L39
            "Monster Summoning II",             -- L50
            "Burnout IV",                       -- L55
            "Wrath of the Elements",            -- L55
            "Valiant Companion",                -- L59
            "Monster Summoning III",            -- L60
        },
    },
    WIZ = {
        Original = {
            "Frost Bolt",                       -- L01
            "Minor Shielding",
            "Numbing Cold",
            "Blast of Cold",
            "Sphere of Light",
            "True North",
            "Fade",                             -- L04
            "Gate",
            "Glimpse",
            "Icestrike",
            "O`Keil's Radiation",
            "Root",
            "See Invisible",
            "Shock of Fire",
            "Column of Frost",                  -- L08
            "Eye of Zomm",
            "Fingers of Fire",
            "Fire Bolt",
            "Lesser Shielding",
            "Sense Summoned",
            "Shadow Step",
            "Shock of Ice",
            "Bind Affinity",                    -- L12
            "Cancel Magic",
            "Firestorm",
            "Frost Spiral of Al'Kabor",
            "Gaze",
            "Halo of Light",
            "Resistant Skin",
            "Shock of Lightning",
            "Bind Sight",                       -- L16
            "Flame Shock",
            "Heat Sight",
            "Identify",
            "Invisibility",
            "Lightning Bolt",
            "Pillar of Fire",
            "Project Lightning",
            "Shielding",
            "Shieldskin",
            "Elemental Shield",                 -- L20
            "Instill",
            "Fay Gate",
            "Fire Spiral of Al'Kabor",
            "Force Shock",
            "North Gate",
            "Sight",
            "Tishan's Clash",
            "Tox Gate",
            "Cast Force",                       -- L24
            "Cazic Gate",
            "Column of Lightning",
            "Common Gate",
            "Frost Shock",
            "Leatherskin",
            "Levitate",
            "Lightning Storm",
            "Major Shielding",
            "Nek Gate",
            "Ro Gate",
            "West Gate",
            "Bonds of Force",                   -- L29
            "Energy Storm",
            "Evacuate: North",
            "Fay Portal",
            "Inferno Shock",
            "Magnify",
            "North Portal",
            "Shock Spiral of Al'Kabor",
            "Thunder Strike",
            "Tox Portal",
            "Yonder",
            "Cazic Portal",                     -- L34
            "Circle of Force",
            "Evacuate: Fay",
            "Greater Shielding",
            "Ice Shock",
            "Lava Storm",
            "Nek Portal",
            "Nullify Magic",
            "Steelskin",
            "Thunderclap",
            "Chill Sight",                      -- L39
            "Common Portal",
            "Evacuate: Ro",
            "Force Spiral of Al'Kabor",
            "Immobilize",
            "Lightning Shock",
            "Ro Portal",
            "Shifting Sight",
            "West Portal",
            "Arch Shielding",                   -- L44
            "Conflagration",
            "Diamondskin",
            "Elemental Armor",
            "Evacuate: Nek",
            "Force Strike",
            "Frost Storm",
            "Gravity Flux",
            "Alter Plane: Hate",                -- L46
            "Alter Plane: Sky",
            "Evacuate: West",                   -- L49
            "Ice Comet",
            "Markar's Clash",
            "Paralyzing Earth",
            "Rend",
            "Supernova",
            "Wrath of Al'Kabor",
        },
        Kunark = {
            "Combine Gate",                     -- L24
            "Imbue Fire Opal",                  -- L29
            "Combine Portal",                   -- L34
            "Harvest",                          -- L34
            "Concussion",                       -- L39
            "Markar's Relocation",              -- L39
            "Tishan's Relocation",              -- L39
            "Atol's Spectral Shackles",         -- L51
            "Draught of Fire",                  -- L51
            "Pillar of Frost",                  -- L51
            "Tishan's Discord",                 -- L51
            "Abscond",                          -- L52
            "Lure of Frost",                    -- L52
            "Manaskin",                         -- L52
            "Tears of Druzzil",                 -- L52
            "Annul Magic",                      -- L53
            "Inferno of Al'Kabor",              -- L53
            "Jyll's Static Pulse",              -- L53
            "Pillar of Lightning",              -- L54
            "Shield of the Magi",               -- L54
            "Thunderbolt",                      -- L54
            "Voltaic Draught",                  -- L54
            "Draught of Jiva",                  -- L55
            "Lure of Flame",                    -- L55
            "Plainsight",                       -- L55
            "Tears of Solusek",                 -- L55
            "Jyll's Zephyr of Ice",             -- L56
            "Markar's Discord",                 -- L56
            "Retribution of Al'Kabor",          -- L56
            "Draught of Ice",                   -- L57
            "Evacuate",                         -- L57
            "Eye of Tallon",                    -- L57
            "Pillar of Flame",                  -- L57
            "Fetter",                           -- L58
            "Lure of Lightning",                -- L58
            "Manasink",                         -- L58
            "Tears of Prexus",                  -- L58
            "Flaming Sword of Xuzl",            -- L59
            "Invert Gravity",                   -- L59
            "Jyll's Wave of Heat",              -- L59
            "Vengeance of Al'Kabor",            -- L59
            "Disintegrate",                     -- L60
            "Lure of Ice",                      -- L60
            "Sunstrike",                        -- L60
            "Winds of Gelid",                   -- L60
        },
        Velious = {
            "Great Divide Gate",                -- L34
            "Iceclad Gate",                     -- L34
            "Iceclad Portal",                   -- L34
            "O`Keil's Flickering Flame",        -- L34
            "Cobalt Scar Gate",                 -- L39
            "Great Divide Portal",              -- L39
            "Invisibility to Undead",           -- L39
            "Translocate: Combine",             -- L39
            "Translocate: Fay",                 -- L39
            "Translocate: North",               -- L39
            "Translocate: Tox",                 -- L39
            "Wakening Lands Gate",              -- L39
            "Cobalt Scar Portal",               -- L44
            "Enticement of Flame",              -- L44
            "Translocate: Cazic",               -- L44
            "Translocate: Common",              -- L44
            "Translocate: West",                -- L44
            "Translocate: Nek",                 -- L44
            "Translocate: Ro",                  -- L44
            "Wakening Lands Portal",            -- L44
            "Translocate: Cobalt Scar",         -- L49
            "Translocate: Great Divide",        -- L49
            "Translocate: Iceclad",             -- L49
            "Translocate: Wakening Lands",      -- L49
            "Translocate",                      -- L50
            "Translocate: Group",               -- L52
            "Improved Invisibility",            -- L55
            "Hsagra's Wrath",                   -- L60
            "Ice Spear of Solist",              -- L60
            "Porlos' Fury",                     -- L60
        },
    },
    NEC = {
        Original = {
            "Cavorting Bones",                  -- L01
            "Coldlight",
            "Disease Cloud",
            "Invisibility versus Undead",
            "Lifetap",
            "Locate Corpse",
            "Minor Shielding",
            "Reclaim Energy",
            "Sense the Dead",
            "Siphon Strength",
            "Clinging Darkness",                -- L04
            "Endure Cold",
            "Fear",
            "Gate",
            "Grim Aura",
            "Leering Corpse",
            "Lifespike",
            "Numb the Dead",
            "Poison Bolt",
            "True North",
            "Bone Walk",                        -- L08
            "Dark Empathy",
            "Dark Pact",
            "Deadeye",
            "Gather Shadows",
            "Impart Strength",
            "Lesser Shielding",
            "Mend Bones",
            "Shadow Step",
            "Vampiric Embrace",
            "Ward Undead",
            "Bind Affinity",                    -- L12
            "Convoke Shadow",
            "Endure Disease",
            "Engulfing Darkness",
            "Heat Blood",
            "Leech",
            "Lifedraw",
            "Scent of Dusk",
            "Sight Graft",
            "Spook the Dead",
            "Wave of Enfeeblement",
            "Banshee Aura",                     -- L16
            "Cancel Magic",
            "Cure Disease",
            "Feign Death",
            "Heart Flutter",
            "Hungry Earth",
            "Infectious Cloud",
            "Restless Bones",
            "Shielding",
            "Shieldskin",
            "Spirit Armor",
            "Voice Graft",
            "Allure of Death",                  -- L20
            "Animate Dead",
            "Dominate Undead",
            "Expulse Undead",
            "Harmshield",
            "Identify",
            "Shadow Compact",
            "Shadow Vortex",
            "Siphon Life",
            "Word of Shadow",
            "Breath of the Dead",               -- L24
            "Haunting Corpse",
            "Intensify Death",
            "Leatherskin",
            "Major Shielding",
            "Rapacious Subvention",
            "Resist Cold",
            "Rest the Dead",
            "Scent of Shadow",
            "Screaming Terror",
            "Shadow Sight",
            "Shock of Poison",
            "Boil Blood",                       -- L29
            "Dismiss Undead",
            "Dooming Darkness",
            "Panic the Dead",
            "Renew Bones",
            "Spirit Tap",
            "Summon Dead",
            "Vampiric Curse",
            "Word of Spirit",
            "Beguile Undead",                   -- L34
            "Call of Bones",
            "Greater Shielding",
            "Invoke Fear",
            "Invoke Shadow",
            "Resist Disease",
            "Root",
            "Steelskin",
            "Surge of Enfeeblement",
            "Venom of the Snake",
            "Augment Death",                    -- L39
            "Counteract Disease",
            "Drain Spirit",
            "Expel Undead",
            "Malignant Dead",
            "Nullify Magic",
            "Scent of Darkness",
            "Scourge",
            "Summon Corpse",
            "Word of Souls",
            "Arch Shielding",                   -- L44
            "Asystole",
            "Cackling Bones",
            "Covetous Subversion",
            "Dead Man Floating",
            "Diamondskin",
            "Ignite Bones",
            "Pact of Shadow",
            "Banish Undead",                    -- L49
            "Bond of Death",
            "Cajole Undead",
            "Cascading Darkness",
            "Drain Soul",
            "Ignite Blood",
            "Invoke Death",
            "Lich",
            "Paralyzing Earth",
        },
        Kunark = {
            "Track Corpse",                     -- L20
            "Dread of Night",                   -- L51
            "Envenomed Bolt",                   -- L51
            "Sacrifice",                        -- L51
            "Splurt",                           -- L51
            "Defoliation",                      -- L52
            "Manaskin",                         -- L52
            "Plague",                           -- L52
            "Scent of Terris",                  -- L52
            "Annul Magic",                      -- L53
            "Convergence",                      -- L53
            "Instill",                          -- L53
            "Minion of Shadows",                -- L53
            "Deflux",                           -- L54
            "Shadowbond",                       -- L54
            "Shield of the Magi",               -- L54
            "Thrall of Bones",                  -- L54
            "Chill Bones",                      -- L55
            "Infusion",                         -- L55
            "Levant",                           -- L55
            "Skin of the Shadow",               -- L55
            "Cessation of Cor",                 -- L56
            "Sedulous Subversion",              -- L56
            "Servant of Bones",                 -- L56
            "Trepidation",                      -- L56
            "Conjure Corpse",                   -- L57
            "Exile Undead",                     -- L57
            "Vexing Replenishment",             -- L57
            "Immobilize",                       -- L58
            "Pyrocruor",                        -- L58
            "Quivering Veil of Xarn",           -- L58
            "Devouring Darkness",               -- L59
            "Emissary of Thule",                -- L59
            "Touch of Night",                   -- L59
            "Banishment of Shadows",            -- L60
            "Demi Lich",                        -- L60
            "Enslave Death",                    -- L60
            "Trucidation",                      -- L60
        },
        Velious = {
            "Torbas' Acid Blast",               -- L34
            "Chilling Embrace",                 -- L39
            "Corporeal Empathy",                -- L44
            "Incinerate Bones",                 -- L44
            "Summon Companion",                 -- L44
            "Dead Men Floating",                -- L49
            "Improved Invisibility",            -- L50
            "Augmentation of Death",            -- L55
            "Conglaciation of Bone",            -- L55
            "Arch Lich",                        -- L60
            "Death Peace",                      -- L60
            "Gangrenous Touch of Zum`uul",      -- L60
        },
        Luclin = {
            "Focus Death",                      -- L11
            "Lesser Summon Corpse",             -- L12
            "Shackle of Bone",                  -- L17
            "Eternities Torment",               -- L27
            "Shackle of Spirit",                -- L38
            "Insidious Retrogression",          -- L46
            "Degeneration",                     -- L52
            "Succussion of Shadows",            -- L54
            "Crippling Claudication",           -- L56
            "Mind Wrack",                       -- L58
            "Zevfeer's Theft of Vitae",         -- L60
            "Funeral Pyre of Kelador",          -- L60
            "Ancient: Lifebane",                -- L60
            "Ancient: Master of Death",         -- L60
        },
        PoP = {
            "Tiny Companion",                   -- L19
            "Torbas' Poison Blast",             -- L49
            "Torbas' Venom Blast",              -- L54
            "Eidolon Voice",                    -- L56
            "Imbue Nightmare",                  -- L57
            "Imbue Disease",                    -- L58
            "Imbue Torment",                    -- L58
            "Touch of Mujaki",                  -- L61
            "Neurotoxin",                       -- L61
            "Shield of the Arcane",             -- L61
            "Legacy of Zek",                    -- L61
            "Dark Plague",                      -- L61
            "Petrifying Earth",                 -- L62
            "Rune of Death",                    -- L62
            "Saryrn's Kiss",                    -- L62
            "Greater Immobilize",               -- L63
            "Force Shield",                     -- L63
            "Death's Silence",                  -- L63
            "Embracing Darkness",               -- L63
            "Saryrn's Companion",               -- L63
            "Shield of Maelin",                 -- L64
            "Seduction of Saryrn",              -- L64
            "Touch of Death",                   -- L64
            "Blood of Thule",                   -- L65
            "Child of Bertoxxulous",            -- L65
            "Word of Terris",                   -- L65
            "Destroy Undead",                   -- L65
        },
        LoY = {
            "Auspice",                          -- L45
            "Comatose",                         -- L52
        },
        LDoN = {
            "Wuggan's Lesser Appraisal",        -- L13
            "Reebo's Lesser Exorcism",          -- L13
            "Reebo's Lesser Augury",            -- L14
            "Wuggan's Lesser Discombobulation", -- L14
            "Wuggan's Lesser Extrication",      -- L14
            "Reebo's Lesser Cleansing",         -- L14
            "Wuggan's Appraisal",               -- L23
            "Reebo's Exorcism",                 -- L23
            "Reebo's Augury",                   -- L24
            "Wuggan's Discombobulation",        -- L24
            "Wuggan's Extrication",             -- L24
            "Reebo's Cleansing",                -- L24
            "Wuggan's Greater Appraisal",       -- L33
            "Reebo's Greater Exorcism",         -- L33
            "Reebo's Greater Augury",           -- L34
            "Wuggan's Greater Discombobulation",-- L34
            "Wuggan's Greater Extrication",     -- L34
            "Reebo's Greater Cleansing",        -- L34
            "Dark Soul",                        -- L39
            "Bounce",                           -- L44
            "Ward of Calliav",                  -- L49
            "Imprecation",                      -- L54
            "Guard of Calliav",                 -- L58
            "Reflect",                          -- L58
            "Horror",                           -- L63
            "Protection of Calliav",            -- L64
        },
        GoD = {
            "Night Stalker",                    -- L65
            "Night Fire",                       -- L65
            "Night's Beckon",                   -- L65
            "Ancient: Seduction of Chaos",      -- L65
        },
        OOW = {
            "Acikin",                           -- L66
            "Shadow Guard",                     -- L66
            "Chaos Plague",                     -- L66
            "Eidolon Howl",                     -- L66
            "Soulspike",                        -- L67
            "Grip of Mori",                     -- L67
            "Glyph of Darkness",                -- L67
            "Lost Soul",                        -- L67
            "Dark Nightmare",                   -- L67
            "Unholy Howl",                      -- L67
            "Fang of Death",                    -- L68
            "Scent of Midnight",                -- L68
            "Desecrating Darkness",             -- L68
            "Shadow of Death",                  -- L68
            "Dull Pain",                        -- L69
            "Dark Hold",                        -- L69
            "Dark Salve",                       -- L69
            "Bulwark of Calliav",               -- L69
            "Pyre of Mori",                     -- L69
            "Chaos Venom",                      -- L70
            "Dark Possession",                  -- L70
            "Dark Assassin",                    -- L70
            "Word of Chaos",                    -- L70
            "Desolate Undead",                  -- L70
            "Ancient: Curse of Mori",           -- L70
            "Ancient: Touch of Orshilak",       -- L70
        },
        DoN = {
            "Unholy Voice",                     -- L57
            "Soul Orb",                         -- L61
            "Eidolon Bellow",                   -- L61
            "Unholy Bellow",                    -- L62
            "Shadow Orb",                       -- L69
        },
        DoDH = {
            "Call for Blood",                   -- L68
            "Corath Venom",                     -- L69
            "Dread Pyre",                       -- L70
        },
        PoR = {
            "Dark Rune",                        -- L55
            "Grave Pact",                       -- L70
            "Mind Flay",                        -- L70
            "Death Rune",                       -- L70
        },
    },
    BST = {
        Luclin = {
            "Sense Animals",                    -- L02
            "Endure Cold",                      -- L03
            "Cure Disease",                     -- L04
            "Flash of Light",                   -- L05
            "Minor Healing",                    -- L06
            "Inner Fire",                       -- L07
            "Spirit of Sharik",                 -- L08
            "Endure Fire",                      -- L09
            "Sharik's Replenishing",            -- L09
            "Scale Skin",                       -- L10
            "Fleeting Fury",                    -- L11
            "Blast of Frost",                   -- L12
            "Cure Poison",                      -- L13
            "Spirit of Lightning",              -- L13
            "Strengthen",                       -- L14
            "Sicken",                           -- L14
            "Keshuval's Rejuvenation",          -- L15
            "Spirit of Khaliz",                 -- L15
            "Serpent Sight",                    -- L16
            "Summon Drink",                     -- L17
            "Spirit of Bear",                   -- L17
            "Light Healing",                    -- L18
            "Endure Poison",                    -- L18
            "Spirit of the Blizzard",           -- L18
            "Tainted Breath",                   -- L19
            "Drowsy",                           -- L20
            "Spirit of Keshuval",               -- L21
            "Endure Disease",                   -- L22
            "Shrink",                           -- L23
            "Spirit of Wolf",                   -- L24
            "Enduring Breath",                  -- L25
            "Spirit Strike",                    -- L26
            "Turtle Skin",                      -- L26
            "Herikol's Soothing",               -- L27
            "Healing",                          -- L28
            "Spirit of Inferno",                -- L28
            "Spirit Strength",                  -- L28
            "Summon Food",                      -- L29
            "Spirit Sight",                     -- L29
            "Spirit of Herikol",                -- L30
            "Summon Companion",                 -- L31
            "Levitate",                         -- L32
            "Endure Magic",                     -- L34
            "Envenomed Breath",                 -- L35
            "Cancel Magic",                     -- L35
            "Yekan's Recovery",                 -- L36
            "Spirit of Ox",                     -- L37
            "Yekan's Quickening",               -- L37
            "Spirit of Monkey",                 -- L38
            "Spirit of the Scorpion",           -- L38
            "Greater Healing",                  -- L38
            "Spirit of Yekan",                  -- L39
            "Raging Strength",                  -- L41
            "Spiritual Light",                  -- L41
            "Spiritual Brawn",                  -- L42
            "Invisibility",                     -- L43
            "Listless Power",                   -- L44
            "Counteract Disease",               -- L45
            "Spirit of Kashek",                 -- L46
            "Spirit of Vermin",                 -- L46
            "Frenzy",                           -- L47
            "Protect",                          -- L48
            "Spirit Salve",                     -- L48
            "Vigor of Zehkes",                  -- L49
            "Sha's Lethargy",                   -- L50
            "Resist Disease",                   -- L51
            "Spirit of Wind",                   -- L51
            "Ultravision",                      -- L51
            "Resistant Discipline",             -- L51 disc
            "Aid of Khurenz",                   -- L52
            "Health",                           -- L52
            "Spiritual Radiance",               -- L52
            "Venom of the Snake",               -- L52
            "Deftness",                         -- L53
            "Spirit of the Storm",              -- L53
            "Talisman of Tnarg",                -- L53
            "Furious Strength",                 -- L54
            "Resist Poison",                    -- L54
            "Spirit of Omakin",                 -- L54
            "Spirit of Snow",                   -- L54
            "Fearless Discipline",              -- L54 disc
            "Chloroplast",                      -- L55
            "Omakin's Alacrity",                -- L55
            "Sha's Restoration",                -- L55
            "Protective Spirit Discipline",     -- L55 disc
            "Incapacitate",                     -- L56
            "Shifting Shield",                  -- L56
            "Spirit of Flame",                  -- L56
            "Spirit of Zehkes",                 -- L56
            "Dexterity",                        -- L57
            "Stamina",                          -- L57
            "Spirit of Khurenz",                -- L58
            "Talisman of Altuna",               -- L58
            "Nullify Magic",                    -- L58
            "Blizzard Blast",                   -- L59
            "Chloroblast",                      -- L59
            "Sha's Ferocity",                   -- L59
            "Spiritual Purity",                 -- L59
            "Alacrity",                         -- L60
            "Savagery",                         -- L60
            "Sha's Advantage",                  -- L60
            "Spirit of Khati Sha",              -- L60
            "Spiritual Strength",               -- L60
            "Bestial Fury Discipline",          -- L60 disc
        },
        PoP = {
            "Tiny Companion",                   -- L19
            "Ice Spear",                        -- L33
            "Frost Shard",                      -- L47
            "Ice Shard",                        -- L54
            "Annul Magic",                      -- L61
            "Counteract Poison",                -- L61
            "Healing of Sorsha",                -- L61
            "Infusion of Spirit",               -- L61
            "Scorpion Venom",                   -- L61
            "Talisman of Shadoo",               -- L61
            "Spiritual Vigor",                  -- L62
            "Spirit of Arag",                   -- L62
            "Talisman of Kragg",                -- L62
            "Abolish Disease",                  -- L63
            "Arag's Celerity",                  -- L63
            "Celerity",                         -- L63
            "Frost Spear",                      -- L63
            "Spirit of Rellic",                 -- L63
            "Talisman of Jasinth",              -- L63
            "Regrowth",                         -- L64
            "Spiritual Dominion",               -- L64
            "Spirit of Sorsha",                 -- L64
            "Acumen",                           -- L65
            "Ferocity",                         -- L65
            "Plague",                           -- L65
            "Sha's Revenge",                    -- L65
        },
        LoY = {
            "Malaria",                          -- L40
            "Bond of the Wild",                 -- L52
        },
        LDON = {
            "Spirit of the Shrew",              -- L39
            "Ward of Calliav",                  -- L49
            "Pack Shrew",                       -- L44
            "Guard of Calliav",                 -- L58
            "Protection of Calliav",            -- L64
        },
        GoD = {
            "Salve",                            -- L01
            "Turepta Blood",                    -- L65
            "Trushar's Mending",                -- L65
            "Trushar's Frost",                  -- L65
            "Ancient: Frozen Chaos",            -- L65
        },
        OOW = {
            "Chimera Blood",                    -- L66
            "Healing of Mikkily",               -- L66
            "Muada's Mending",                  -- L67
            "Focus of Alladnu",                 -- L67
            "Spiritual Vitality",               -- L67
            "Spirit of Alladnu",                -- L68
            "Growl of the Beast",               -- L68
            "Spirit of Irionu",                 -- L68
            "Glacier Spear",                    -- L69
            "Feral Vigor",                      -- L69
            "Spiritual Ascendance",             -- L69
            "Feral Guard",                      -- L69
            "Ferocity of Irionu",               -- L70
            "Festering Malady",                 -- L70
            "Sha's Legacy",                     -- L70
            "Spirit of Rashara",                -- L70
            "Ancient: Savage Ice",              -- L70
        },
        DoN = {
            "Growl of the Leopard",             -- L61
            "Growl of the Panther",             -- L69
        },
        DoDH = {
            "Bestial Empathy",                  -- L68
            "Empathic Fury",                    -- L69 disc
        },
        PoR = {
            "Spirit of Oroshar",                -- L70
            "Rake",                             -- L70 disc
        },
    },
}

-- Mapping between classic spell names and the names used on live.
-- These spells was later renamed. Needed for fvp, which use the classic names.
local renamedSpells = {
    -- renamed (live)                classic name (fvp)
    ["Illusion: Dry Bone"]          = "Illusion: Drybone",
    ["Malaise"]                     = "Malise",
    ["Malaisement"]                 = "Malisement",
    ["Tashina"]                     = "Tashan",
    ["Wind of Tashani"]             = "Wind of Tishani",
    ["Wind of Tashanian"]           = "Wind of Tishanian",
    ["Wondrous Rapidity"]           = "Wonderous Rapidity",
    ["Dustdevil"]                   = "Calefaction",
    ["Complete Heal"]               = "Complete Healing",
    ["Invisibility vs. Undead"]     = "Invisibility versus Undead",
    ["Instill"]                     = "Enstill",
    ["Selo's Assonant Strain"]      = "Selo's Assonant Strane",
    ["Largo's Assonant Binding"]    = "Largo's Absonant Binding",
    ["Cantata of Replenishment"]    = "Cantana of Replenishment",
    ["Cantata of Soothing"]         = "Cantana of Soothing",
    ["Vocarate: Fire"]              = "Vocerate: Fire",
    ["Vocarate: Water"]             = "Vocerate: Water",
    ["Vocarate: Air"]               = "Vocerate: Air",
    ["Vocarate: Earth"]             = "Vocerate: Earth",
    ["O`Keil's Radiation"]          = "O`Keils Radiation",
    ["O`Keil's Flickering Flame"]   = "O'Keils Flickering Flame",
    ["Blast of Cold"]               = "Shock of Frost",
    ["Thunderbolt"]                 = "Thunderbold",
    ["Voltaic Draught"]             = "Voltaic Draugh",
    ["Rapacious Subvention"]        = "Rapacious Subversion",
    ["Vexing Replenishment"]        = "Vexing Mordinia",
    ["Servant of Bones"]            = "Servent of Bones",
    ["Leech"]                       = "Leach",
}

-- Unlike have_spell(), we ignore AA names.
local function haveSpellOnly(name)
    local ranked = mq.TLO.Spell(name).RankName()
    if mq.TLO.Me.Book(ranked)() ~= nil then
        return true
    end
    return mq.TLO.Me.Book(name)() ~= nil
end

-- Report missing spells/tomes.
---@param expac string
---@param spell string
local function reportSpellStatus(expac, spell)
    local spellData = get_spell(spell)
    if spellData == nil then
        all_tellf("UNLIKELY: %s: DID NOT RESOLVE [+r+]%s[+x+]", expac, spell)
    elseif not haveSpellOnly(spell) and not have_combat_ability(spell) then
        if spellData.Level() == nil then
            local rename = renamedSpells[spell]
            if rename ~= nil then
                reportSpellStatus(expac, rename)
                return
            else
                all_tellf("%s: ERROR: No Level data for [+y+]%s[+x+]", expac, spell)
            end
        elseif spellData.Level() <= mq.TLO.Me.Level() then
            log.Info("%s: Missing L%d \ay%s\ax", expac, spellData.Level(), spell)
        end
    end
end

---@param spell spell
---@return boolean
local function recognizedSpell(spell)
    if spell() == nil then
        return false
    end

    local class = class_shortname()
    local spells = classSpells[class]
    if spells == nil then
        return false
    end

    for expac, t in pairs(spells) do
        for _, currentSpell in pairs(t) do
            if spell.Name() == currentSpell then
                return true
            end
            local rename = renamedSpells[currentSpell]
            if rename ~= nil and spell.Name() == rename then
                return true
            end
        end
    end

    return false
end

-- Reports missing spells/discs
---@param onlyExpac string
local function execute(onlyExpac)
    local class = class_shortname()
    local spells = classSpells[class]
    if spells == nil then
        all_tellf("UNLIKELY: class spells missing for %s", class)
        return
    end

    if onlyExpac == nil then
        log.Info("Missing spell report:")
    else
        log.Info("Missing spell report (expac %s):", onlyExpac)
    end

    for expac, expacSpells in pairs(spells) do
        if onlyExpac == nil or (onlyExpac ~= nil and string.lower(onlyExpac) == string.lower(expac)) then
            log.Info("Expansion %s (%d total):", expac, #expacSpells)
            for _, spell in pairs(expacSpells) do
                reportSpellStatus(expac, spell)
            end
        end
    end

    -- scan spell book and look for any unknown spells according to the above tables.
    local bookSize = 8 * 90 -- size of spellbook: 8 * 90 pages (RoF2)
    for i = 1, bookSize do
        local spell = mq.TLO.Me.Book(i)
        if spell() ~= nil then
            if not recognizedSpell(spell) then
                log.Info("UNRECOGNIZED SPELL %d: L%d %s", i, spell.Level(), spell.RankName())
            end
        end
    end

    -- scan for unknown discs.
    for i = 1, 100 do
        local spell = mq.TLO.Me.CombatAbility(i)
        if spell() ~= nil then
            if not recognizedSpell(spell) then
                log.Info("UNRECOGNIZED DISC %d: L%d %s", i, spell.Level(), spell.RankName())
            end
        end
    end
end

---@param onlyExpac string
local function createCommand(onlyExpac)
    commandQueue.Enqueue(function() execute(onlyExpac) end)
end

bind("/missingspells", createCommand)
