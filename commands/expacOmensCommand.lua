local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    local augs = {
        "Abhorrent Brimstone of Charring",
        "Gem of Unnatural Regrowth",
        "Kyv Eye of Marksmanship",
        "Orb of Forbidden Laughter",
        "Petrified Girplan Heart",
        "Rune of Astral Celerity",
        "Rune of Futile Resolutions",
        "Rune of Grim Portents",
        "Rune of Living Lightning",
        "Stone of Horrid Transformation",
        "Stone of Planar Protection",
    }
    local s = ""
    local missing = 0
    for k, name in pairs(augs) do
        if not have_item(name) then
            missing = missing + 1
            s = s .. name .. ", "
        end
    end

    if s == "" then
        s = "coaaugs: OK"
    else
        s = string.format("coaaugs NEED %d: %s", missing, s)
    end

    all_tellf(s)
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

-- report your CoA auguments
mq.bind("/coaaugs", createCommand)
