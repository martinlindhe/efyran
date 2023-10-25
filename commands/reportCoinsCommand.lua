local mq = require("mq")
local log          = require("knightlinc/Write")
local commandQueue = require("lib/CommandQueue")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

local function execute()
    local me = mq.TLO.Me
    all_tellf("coins: inventory [+y+]%dp[+x+] %dg %ds %dc, bank [+y+]%dp[+x+] %dg %ds %dc, shared [+y+]%dp[+x+]",
        me.Platinum(), me.Gold(), me.Silver(), me.Copper(),
        me.PlatinumBank(), me.GoldBank(), me.SilverBank(), me.CopperBank(),
        me.PlatinumShared())
end

-- reports coin summary on all peers
local function createCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/coins")
    end

    commandQueue.Enqueue(function() execute() end)
end

bind("/coins", createCommand)
