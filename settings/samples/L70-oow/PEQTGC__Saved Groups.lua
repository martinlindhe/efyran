local groups = { }

-- team12 == peq-team12.bat
-- pofear golem farm
-- keys: plane of sky flagged for isle 4 (shm 1.5 epic)
groups.team12 = {
    {"Garotta", "Samma", "Arctander", "Trams", "Kniven", "Brann"},
    {"Bandy", "Stor", "Spela", "Nullius", "Myggan", "Blastar"},
}

-- dps30 == peq-dps30.bat
-- keys: vp2, sebilis, howling stones, potime, tacvi, anguish
-- TODO keys: vt
groups.dps30 = {
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Myggan"},     -- melee 3
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Helge"},            -- tank
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Arctander"},       -- melee 1
    {"Gerwulf", "Erland", "Azoth","Urinfact",  "Strupen", "Drutten"},   -- melee 2
    {"Alethea", "Trams", "Blastar", "Brann", "Fandinu", "Redito"},      -- casters + buffers
}

-- port30 == peq-dps30.bat
groups.port30 = {
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Fandinu"},    -- MAX
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Blastar"},          -- WIP LDR AA
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Brann"},           -- WIP LDR AA
    {"Gerwulf", "Erland", "Azoth","Urinfact",  "Strupen", "Drutten"},   -- WIP LDR AA
    {"Alethea", "Trams", "Helge", "Arctander", "Myggan", "Redito"},     -- MAX
}

-- port54 = peq-dps30.bat + peq-dps54.bat
-- classic anguish team, killed omm
groups.port54 = {
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Fandinu"},
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Blastar"},
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Brann"},
    {"Gerwulf", "Erland", "Azoth", "Urinfact",  "Strupen", "Drutten"},
    {"Alethea", "Trams", "Helge", "Arctander", "Myggan", "Redito"},
    --
    {"Sophee", "Manu", "Kamaxia", "Kasta", "Crusade", "Fisse"},         -- WIP LDR AA
    {"Moola", "Runar", "Fedt", "Arriane", "Absint", "Lofty"},           ---MAX
    {"Crust", "Halsen", "Katten", "Bulf", "Papp", "Saga"},
    {"Hypert", "Lotho", "Yelwen", "Kasper", "Maynarrd", "Umlilo"},
}

-- port30noobs = peq-dps30.bat + peq-new21.bat
groups.port30noobs = {
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Fandinu"},
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Blastar"},
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Brann"},
    {"Gerwulf", "Erland", "Azoth", "Urinfact",  "Strupen", "Drutten"},
    {"Alethea", "Trams", "Helge", "Arctander", "Myggan", "Redito"},
    --
    {"Hypert", "Katten", "Halsen", "Kasta", "Bulf", "Saga"},            -- WIP LDR AA
    {"Pantless", "Tervet", "Ryggen", "Papp", "Nacken", "Fisse"},        -- WIP LDR AA
    {"Plin", "Sogaard", "Endstand", "Runar", "Katan", "Brinner"},       -- WIP LDR AA
    {"Crust", "Fedt", "Manu", "Kamaxia", "Gasoline"},                   -- WIP LDR AA
}

return groups
