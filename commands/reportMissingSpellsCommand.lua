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
            --"Shield of Song",                   -- L49      XXX disabled on fvp
            "Selo's Song of Travel",
            "Largo's Absonant Binding",
            "Nillipus' March of the Wee",
            "Song of Twilight",
            "Song of Dawn",
            "Vilia's Chorus of Celerity",
            "Selo's Assonant Strane",
            "Cantana of Replenishment",         -- L55          XXX typo in the name on fvp, should be "Cantata"
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
                    log.Info("%s: \ay%s\ax", expac, spell)
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
