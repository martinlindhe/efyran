local mq = require("mq")
local commandQueue = require('commandQueue')

---@class WardsCommand
---@field Kind string

---@param command WardsCommand
local function execute(command)
    local kind = command.Kind
    if not is_clr() and not is_dru() then
        return
    end
    if kind == "cure" then
        local aaName = "Ward of Purity" -- DoDH
        if not have_alt_ability(aaName) then
            all_tellf("I do not have AA \ar%s\ax", aaName)
            return
        end
        if is_alt_ability_ready(aaName) then
            all_tellf("Dropping %s ward '%s' ...", kind, aaName)
            use_alt_ability(aaName)
        else
            all_tellf("\ar%s ward '%s' is not ready\ax. Ready in %s", kind, aaName, mq.TLO.Me.AltAbilityTimer(aaName).TimeHMS())
        end

    elseif kind == "heal" then
        local healWards = {
            "Exquisite Benediction", -- CLR
            "Nature's Boon",         -- DRU
            "Call of the Ancients",  -- SHM
        }
        for k, aaName in pairs(healWards) do
            if have_alt_ability(aaName) then
                if is_alt_ability_ready(aaName) then
                    all_tellf("Dropping \ay%s ward\ax '%s' ...", kind, aaName)
                    use_alt_ability(aaName)
                else
                    all_tellf("\ar%s ward '%s' is not ready\ax. Ready in %s", kind, aaName, mq.TLO.Me.AltAbilityTimer(aaName).TimeHMS())
                end
                return
            end
        end
    else
        all_tellf("UseWard FATAL: unhandled kind %s", kind)
    end
end

local function createHealWardCommand()
    commandQueue.Enqueue(function() execute({Kind = "heal"}) end)
end

local function createCureWardCommand()
    commandQueue.Enqueue(function() execute({Kind = "cure"}) end)
end

-- Use heal ward AA (CLR/DRU/SHM, OOW)
mq.bind("/healward", createHealWardCommand)

-- Summon all available heal wards (CLR/DRU/SHM, OOW)
mq.bind("/healwards", function() cmdf("/dgzexecute /healward") end)

-- Use cure ward AA "Ward of Purity" (CLR, DoDH)
mq.bind("/cureward", createCureWardCommand)

-- Summon all available cure wards (CLR, DoDH)
mq.bind("/curewards", function() cmdf("/dgzexecute /cureward") end)
