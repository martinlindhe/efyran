local mq = require("mq")
local commandQueue = require('app/commandQueue')
local log          = require("efyran/knightlinc/Write")

---@class VeteranAACommand
---@field AdvancedAbilityName string

---@param command VeteranAACommand
local function execute(command)
    local filter = command.AdvancedAbilityName
    if filter ~= nil and not matches_filter(filter, mq.TLO.Me.Name()) then -- XXX sender name for /only|group to work
        log.Info("use-veteran-aa: Not matching filter, giving up: %s", filter)
        return
    end

    use_alt_ability(command.AdvancedAbilityName)
end

local function createStaunchCommand()
    if is_orchestrator() then
        mq.cmd("/dgzexecute /staunch") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Staunch Recovery"}) end)
end

local function createArmorCommand()
    if is_orchestrator() then
        mq.cmd("/dgzexecute /armor") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Armor of Experience"}) end)
end

local function createInfusionCommand()
    if is_orchestrator() then
        mq.cmd("/dgzexecute /infusion") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Infusion of the Faithful"}) end)
end

local function createItensityCommand()
    if is_orchestrator() then
        mq.cmd("/dgzexecute /intensity") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Intensity of the Resolute"}) end)
end

local function createExpedientCommand()
    if is_orchestrator() then
        mq.cmd("/dgzexecute /expedient") -- XXX filter
    end

    commandQueue.Enqueue(function() execute({AdvancedAbilityName = "Expedient Recovery"}) end)
end

mq.bind("/staunch", createStaunchCommand)
mq.bind("/armor", createArmorCommand)
mq.bind("/infusion", createInfusionCommand)
mq.bind("/intensity", createItensityCommand)
mq.bind("/expedient", createExpedientCommand)
