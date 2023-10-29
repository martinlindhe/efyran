-- Get yer alcohol tolerance skill up

-- Load inventory with Short Beer in PoK, then run this:
-- /bcaa //target Culkin Ironstove
-- /autobuy short beer|1600    = 1600 = 8 x 10 slot bags

local mq = require("mq")

local log = require("knightlinc/Write")

local drunk = false
mq.event("too-drunk", "You could not possibly consume more alcohol or become more intoxicated#*#", function(line)
    drunk = true
end)

-- Returns true on success
--- @return boolean
local function drinkAlcohol()

    local alcoholDrinks = {
        "Short Beer", -- 1s5c
        "Honey Mead", -- 1s5c
    }

    local item = nil
    for _, v in pairs(alcoholDrinks) do
        item = find_item("="..v)
        if item ~= nil then
            break
        end
    end

    if item == nil then
        return false
    end

    log.Info("Attempting to drink %s", item.Name())
    mq.cmdf("/itemnotify in pack%d %d rightmouseup", item.ItemSlot() - 22, item.ItemSlot2() + 1)

    mq.delay(100)
    return true
end

return function()
    log.Info("Alcohol tolerance training started")

    open_bags()

    while true do
        clear_cursor()

        mq.doevents()
        if not drinkAlcohol() then
            mq.cmd("/beep 1")
            all_tellf("IM OUT OF BOOZE! Alcohol Tolerance %d/%d", skill_value("Alcohol Tolerance"), skill_cap("Alcohol Tolerance"))
            break
        end

        mq.doevents()

        if skill_value("Alcohol Tolerance") >= skill_cap("Alcohol Tolerance") then
            all_tellf("Alcohol Tolerance maxed at %d/%d", skill_value("Alcohol Tolerance"), skill_cap("Alcohol Tolerance"))
            break
        end
        if drunk then
            log.Info("Yer blasted, waiting...")
            mq.cmd("/popup Yer blasted, waiting...")
            mq.delay(5000) -- 5s
            drunk = false
        end
    end

    close_bags()
end
