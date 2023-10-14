local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    -- 22198 The Scepter of Shadows
    if have_item_id(22198) then
        all_tellf("lucidshards: OK (KEYED)")
        return
    end

    -- 17324 Unadorned Scepter of Shadows
    if have_item_id(17324) then
        all_tellf("lucidshards: OK")
        return
    end

    local shards = {
        [22185] = "The Grey",
        [22186] = "Fungus Grove",
        [22187] = "Scarlet Desert",
        [22188] = "The Deep",
        [22189] = "Ssraeshza Temple",
        [22190] = "Akheva Ruins",
        [22191] = "Dawnshroud Peaks",
        [22192] = "Maiden's Eye",
        [22193] = "Acrylia Caverns",
        [22194] = "Sanctus Seru / Katta",
        [17323] = "Akheva Ruins Container", -- Shadowed Scepter Frame
    }
    local s = ""
    local missing = 0
    for id, name in pairs(shards) do
        if not have_item_id(id) then
            missing = missing + 1
            s = s .. name .. ", "
        end
    end

    if s == "" then
        s = "lucidshards: OK"
    else
        s = string.format("lucidshards NEED %d: %s", missing, s)
    end

    all_tellf(s)
end

local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

-- report your Lucid Shards
bind("/lucidshards", createCommand)
