local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("lib/CommandQueue")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

local function execute()
    local me = mq.TLO.Me
    all_tellf("coins: [+y+]%dp[+x+] %dg %ds inventory, [+y+]%dp[+x+] bank, [+y+]%dp[+x+] shared",
        me.Platinum(), me.Gold(), me.Silver(), -- don't show inventory copper
        me.PlatinumBank(), -- don't show bank gold, silver, copper (should be empty)
        me.PlatinumShared())
end

-- reports coin summary on all peers
local function createCommand()
    if is_orchestrator() then
        bci.ExecuteAllCommand("/coins")
    end
    commandQueue.Enqueue(function() execute() end)
end

bind("/coins", createCommand)
