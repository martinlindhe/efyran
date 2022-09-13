local groups = { }

-- team12 == peq-team12.bat
-- pofear golem farm
-- keys: plane of sky flagged for isle 4 (shm 1.5 epic)
groups.team12 = {
    {"Bandy", "Stor", "Spela", "Nullius", "Myggan", "Blastar"},
    {"Kniven", "Samma", "Arctander", "Trams", "Garotta", "Brann"},
}

-- dps30 == peq-dps30.bat
-- keys: vp2, sebilis, howling stones, potime, tacvi, anguish
-- TODO keys: vt
groups.dps30 = {
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Helge"}, -- tank
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Arctander"}, -- melee 1
    {"Gerwulf", "Erland", "Azoth","Urinfact",  "Strupen", "Drutten"}, -- melee 2
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Myggan"}, -- melee 3
    {"Alethea", "Trams", "Blastar", "Brann", "Fandinu", "Redito"},  -- casters + buffers
}

-- port30 == peq-dps30.bat
groups.port30 = {
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Blastar"},
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Brann"},
    {"Gerwulf", "Erland", "Azoth","Urinfact",  "Strupen", "Drutten"},
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Fandinu"},
    {"Alethea", "Trams", "Helge", "Arctander", "Myggan", "Redito"},
}

-- port54 = peq-dps54.bat
-- classic anguish team, killed omm
groups.port54 = {
    {"Bandy", "Stor", "Spela", "Nullius", "Laser", "Blastar"},
    {"Chancer", "Samma", "Knuck", "Blod", "Kniven", "Brann"},
    {"Gerwulf", "Erland", "Azoth", "Urinfact",  "Strupen", "Drutten"},
    {"Garotta", "Tervet", "Besty", "Sweetlard", "Fosco", "Fandinu"},
    {"Alethea", "Trams", "Helge", "Arctander", "Myggan", "Redito"},
    --
    {"Sophee", "Manu", "Kamaxia", "Kasta", "Crusade", "Fisse"},
    {"Crust", "Halsen", "Katten", "Bulf", "Papp", "Saga"},
    {"Hypert", "Lotho", "Yelwen", "Kasper", "Maynarrd", "Umlilo"},
    {"Moola", "Runar", "Fedt", "Arriane", "Absint", "Lofty"},
}

return groups
