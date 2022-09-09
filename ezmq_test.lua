
require("ezmq")

function testParseSpellLine()
    local o = parseSpellLine("Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction")
    assert(o.Name == "Ward of Valiance")
    assert(o.MinMana == "50")
    assert(o.CheckFor == "Hand of Conviction")

    local o = parseSpellLine("Ancient: Nova Strike/GoM/NoAggro")
    assert(o.Name == "Ancient: Nova Strike")
    assert(o.GoM == true)
    assert(o.NoAggro == true)

    local o = parseSpellLine("Class|DRU/Everspring Jerkin of the Tangled Briars")
    assert(o.Name == "Everspring Jerkin of the Tangled Briars")
    assert(o.Class == "DRU")
end



testParseSpellLine()
