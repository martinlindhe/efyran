
require("ezmq")

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint(tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))
        else
            print(formatting .. v)
        end
    end
end


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



testParseSpellLine()
test_split_str()



function test_strip_dannet_peer()
    local o = strip_dannet_peer("server_name")
    assert(o == "Name")

    o = strip_dannet_peer("name")
    assert(o == "Name")
 end

 test_strip_dannet_peer()