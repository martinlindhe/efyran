local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("lib/CommandQueue")

local bci = broadCastInterfaceFactory()

-- report language skills
local function execute()

    local maxLanguageID = 25
    if current_server() == "FVP" then
        maxLanguageID = 24 -- 25 "Vah Shir" was added with Luclin
    end

    local s = ""
    for i = 1, maxLanguageID do
        if mq.TLO.Me.LanguageSkill(i)() >= 100 then
            --log.Debug("Language %s CAPPED (id %d)", mq.TLO.Me.Language(i)(), i)
        elseif mq.TLO.Me.LanguageSkill(i)() == 0 then
            s = s .. string.format("[+r+]%d:%s (0)[+x+], ", i, mq.TLO.Me.Language(i)())
        else
            s = s .. string.format("[+y+]%d:%s (%d)[+x+], ", i, mq.TLO.Me.Language(i)(), mq.TLO.Me.LanguageSkill(i)())
        end
    end

    if s ~= "" then
        all_tellf(s)
    else
        all_tellf("[+g+]OK: All languages capped[+y+]")
    end
end

local function createCommand(distance)
    if is_orchestrator() then
        bci.ExecuteAllCommand("/languages")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/languages", createCommand)
