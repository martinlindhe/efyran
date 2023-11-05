local mq = require("mq")
local log = require("knightlinc/Write")
local broadCastInterfaceFactory = require("broadcast/broadcastinterface")
local bci = broadCastInterfaceFactory()

local aliases = require("lib/settings/default/SpellAliases")
local commandQueue = require("lib/CommandQueue")
local follow = require("lib/following/Follow")

---@class TeleportToCommand
---@field ZoneName string

-- Perform the "/portto <name>" command
---@param name string
local function portTo(name)
    local spellName = nil
    if is_wiz() then
        spellName = aliases.WIZ["port " .. name]
    elseif is_dru() then
        spellName = aliases.DRU["port " .. name]
    else
        return
    end

    if is_dru() then
        -- Abort if druid and grouped with a wizard within 5 levels of the druid's level
        for i = 1,mq.TLO.Group.Members() do
            local member = mq.TLO.Group.Member(i)
            local class = member.Class.ShortName()
            if class == "WIZ" and member.Level() >= mq.TLO.Me.Level()-5 then
                all_tellf("Aborting /portto: I am grouped with capable wizard %s, they will port!", member.Name())
                return
            end
        end
    end

    if spellName == nil then
        all_tellf("[+r+]ERROR[+x+]: Unknown port alias [+g+]%s[+x+].", name)
        return
    end

    follow.Stop()

    all_tellf("Porting group to [+g+]%s[+x+] ([+y+]%s[+x+]) ...", name, spellName)
    unflood_delay()

    if memorize_spell(spellName, 5) ~= nil then
        delay(5000)
        castSpellRaw(spellName, mq.TLO.Me.ID(), "gem5 -maxtries|3")
        wait_until_not_casting()
    end
end

---@param command TeleportToCommand
local function execute(command)
    portTo(command.ZoneName)
end

local function createCommand(name)
    name = name:lower()
    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/portto %s", name))
    end

    commandQueue.Enqueue(function() execute({ZoneName = name}) end)
end


bind("/portto", createCommand)
