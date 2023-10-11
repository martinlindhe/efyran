local mq = require("mq")
local commandQueue = require('commandQueue')
local log          = require("efyran/knightlinc/Write")
local botSettings = require("efyran/e4_BotSettings")

local function execute()
    if botSettings.settings.mount == nil then
        return
    end

    if not mq.TLO.Me.CanMount() then
        all_tellf("MOUNT ERROR, cannot mount in %s", zone_shortname())
        return
    end

    -- XXX see if mount clicky buff is on us already

    local spell = getSpellFromBuff(botSettings.settings.mount)
    if spell == nil then
        all_tellf("/mounton: getSpellFromBuff %s FAILED", botSettings.settings.mount)
        cmd("/beep 1")
        return false
    end

    if have_buff(spell.RankName()) then
        log.Error("I am already mounted.")
        return false
    end

    -- XXX dont summon if we are already mounted.
    log.Info("Summoning mount %s ...", botSettings.settings.mount)
    castSpellAbility(nil, botSettings.settings.mount)
end

local function createMountCommand(peer, filter)
    if is_orchestrator() then
        cmd("/dgzexecute /mounton")
    end

    commandQueue.Enqueue(function() execute() end)
end

local function createDismountCommand(peer, filter)
    if is_orchestrator() then
        cmd("/dgzexecute /mountoff")
    end
    log.Info("Dismounting ...")
    cmd("/dismount")
end

mq.bind("/mounton", createMountCommand)
mq.bind("/mountoff", createDismountCommand)
