local mq = require("mq")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local commandQueue = require("lib/CommandQueue")
local log = require("knightlinc/Write")
local bci = broadCastInterfaceFactory()

local classSpells = {
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
            --"Shield of Song",                   -- L49      XXX disabled on fvp nov 2, Eredhin says it should be enabled
            "Selo's Song of Travel",
            "Largo's Absonant Binding",
            "Nillipus' March of the Wee",
            "Song of Twilight",
            "Song of Dawn",
            "Vilia's Chorus of Celerity",
            "Selo's Assonant Strane",
            "Cantana of Replenishment",         -- L55
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
            "Cantana of Soothing",              -- L34
            "Melody of Ervaj",                  -- L50
            "Occlusion of Sound",               -- L55
            "Composition of Ervaj",             -- L60
        },
        Luclin = {}, -- TODO
        Planes = {}, -- TODO
        Ldon = {},   -- TODO
        Ykesha = {}, -- TODO
        Gates = {},  -- TODO
        Omens = {},  -- TODO
        Dragons = {}, -- TODO
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
            "Calefaction",                      -- L59
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
            "Invisibility versus Undead",
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
            "Enstill",                          -- L54
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
            "Resist Disease",                   -- L51
            "Divine Glory",                     -- L53
            "Resist Magic",                     -- L55
            "Wave of Healing",                  -- L55
            "Superior Healing",                 -- L57
            "Nullify Magic",                    -- L58
            "Celestial Cleansing",              -- L59
            "Resurrection",                     -- L59
            "Divine Strength",                  -- L60
            "Resolution",                       -- L60
            "Shield of Words",                  -- L60
            "Yaulp IV",                         -- L60
        }
    },
}

-- NOTE: fvp uses original spell names. These spells was later renamed
-- TODO make use of this table
local renamedSpells = {
    ["Cantana of Replenishment"]    = "Cantata of Replenishment",
    ["Enstill"]                     = "Instill",
    ["Invisibility versus Undead"]  = "Invisibility vs. Undead",
}

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
                local spellData = get_spell(spell)
                if spellData == nil then
                    all_tellf("UNLIKELY: %s: DID NOT RESOLVE [+r+]%s[+x+]", expac, spell)
                elseif not have_spell(spell) then
                    if spellData.Level() == nil then
                        all_tellf("%s: ERROR: No Level data for \ay%s\ax", expac, spell)
                    elseif spellData.Level() <= mq.TLO.Me.Level() then
                        log.Info("%s: Missing L%d \ay%s\ax", expac, spellData.Level(), spell)
                    end
                end
            end
        end
    end
end

---@param onlyExpac string
local function createCommand(onlyExpac)
    commandQueue.Enqueue(function() execute(onlyExpac) end)
end

bind("/missingspells", createCommand)
