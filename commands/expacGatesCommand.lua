local mq = require("mq")
local commandQueue = require('e4_CommandQueue')

local function execute()
    if have_item("Assistant Researcher's Symbol") then
        all_tellf("tongues: DONE")
        -- TODO check if we have any tongues that is wasting bag space if we got the reward
        return
    end
    local tongues = {
        "Ikaav Tongue",
        "Mastruq Tongue",
        "Aneuk Tongue",
        "Ra'Tuk Tongue",
        "Noc Tongue",
        "Kyv Tongue",
        "Ukun Tongue",
        "Ixt Tongue",
        "Tongue of the Zun'muram",
        "Tongue of the Tunat'muram",
    }

    local s = ""
    local missing = 0
    for k, name in pairs(tongues) do
        if not have_item(name) then
            missing = missing + 1
            s = s .. name .. ", "
        end
    end

    if s == "" then
        s = "tongues: OK"
    else
        s = string.format("tongues NEED %d: %s", missing, s)
    end

    all_tellf(s)
end


local function createCommand()
    commandQueue.Enqueue(function() execute() end)
end

-- report your GoD tongue quest status
bind("/tongues", createCommand)
