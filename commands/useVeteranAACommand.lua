local mq = require("mq")
local log          = require("knightlinc/Write")
local broadCastInterfaceFactory = require 'broadcast/broadcastinterface'
local commandQueue = require("CommandQueue")

local bci = broadCastInterfaceFactory()

---@class VeteranAACommand
---@field AdvancedAbilityName string
---@field Filter string

---@param command VeteranAACommand
local function execute(command)
    if command.Filter ~= nil and not matches_filter(command.Filter, mq.TLO.Me.Name()) then -- XXX sender name for /only|group to work
        log.Info("use-veteran-aa: Not matching filter, giving up: %s", command.Filter)
        return
    end

    use_alt_ability(command.AdvancedAbilityName)
end

local function createStaunchCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/staunch") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Staunch Recovery"}) end)
end

local function createArmorCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/armor") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Armor of Experience"}) end)
end

local function createInfusionCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/infusion") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Infusion of the Faithful"}) end)
end

local function createItensityCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/intensity") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Intensity of the Resolute"}) end)
end

local function createExpedientCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/expedient") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Expedient Recovery"}) end)
end

local function createThroneCommand()
    if is_orchestrator() then
        bci.ExecuteZoneCommand("/throne") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Throne of Heroes"}) end)
end

bind("/staunch", createStaunchCommand)
bind("/armor", createArmorCommand)
bind("/infusion", createInfusionCommand)
bind("/intensity", createItensityCommand)
bind("/expedient", createExpedientCommand)

-- tell peers in zone to use Throne of Heroes
bind("/throne", createThroneCommand)

-- tell peers in zone to use Lesson of the Devoted
bind("/lesson", function(...)
    local filter = args_string(...)
    if is_orchestrator() then
        bci.ExecuteZoneCommand(string.format("/lesson %s", filter))
    end
    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Lesson of the Devoted", Filter = filter}) end)
end)

-- tell all peers to use Throne of Heroes
bind("/throneall", function()
    bci.ExecuteAllWithSelfCommand("/throne")
end)
