
require("ezmq")

function testParseSpellLine()
    local o = parseSpellLine("Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction")
    assert(o.Name == "Ward of Valiance")
    assert(o.MinMana == 50)
    assert(o.CheckFor == "Hand of Conviction")

    o = parseSpellLine("Ancient: Nova Strike/GoM/NoAggro")
    assert(o.Name == "Ancient: Nova Strike")
    assert(o.GoM == true)
    assert(o.NoAggro == true)

    o = parseSpellLine("Class|DRU/Everspring Jerkin of the Tangled Briars")
    assert(o.Name == "Everspring Jerkin of the Tangled Briars")
    assert(o.Class == "DRU")

    o = parseSpellLine("Balance of Discord/MaxTries|3/MinMana|10")
    assert(o.Name == "Balance of Discord")
    assert(o.MaxTries == 3)
    assert(o.MinMana == 10)
end

function testParseFilterLine()
    local o = parseFilterLine("/only|WAR")
    print("dumped filterConfig: " .. dump(o))
    print("hex: ".. hex_dump(o.Only))

    assert(o.Only == "WAR")
    assert(o.Not == nil)
end

function test_split_str()
    local o = split_str("Hello,World", ",")
    assert(o[1] == "Hello")
    assert(o[2] == "World")

    o = split_str("Ward of Valiance/MinMana|50/CheckFor|Hand of Conviction", "/")
    assert(o[1] == "Ward of Valiance")
    assert(o[2] == "MinMana|50")
    assert(o[3] == "CheckFor|Hand of Conviction")
 end

function test_strip_dannet_peer()
    local o = strip_dannet_peer("server_name")
    assert(o == "Name")

    o = strip_dannet_peer("name")
    assert(o == "Name")
 end

testParseSpellLine()
testParseFilterLine()

test_split_str()
test_strip_dannet_peer()
