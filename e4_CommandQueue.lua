--local mq = require("mq")
local log = require("knightlinc/Write")

local bard = require("Class_Bard")

---@class CommandQueueValue
---@field public Name string Name
---@field public Arg string Argument

local CommandQueue = {
    ---@type CommandQueueValue[]
    queue = {},
}

---@param name string
---@param arg? string optional argument
function CommandQueue.Add(name, arg)
    table.insert(CommandQueue.queue, {
        ["Name"] = name,
        ["Arg"] = arg,
    })
end

function CommandQueue.Remove(name)
    local idx = -1

    for k, v in pairs(CommandQueue.queue) do
        if v.Name == name then
            idx = k
        end
    end

    if idx ~= -1 then
        table.remove(CommandQueue.queue, idx)
    end
end

---@return CommandQueueValue|nil
function CommandQueue.PeekFirst()
    for k, v in pairs(CommandQueue.queue) do
        return v
    end
    return nil
end

function CommandQueue.Process()
    --log.Debug("CommandQueue.Process()")

    local v = CommandQueue.PeekFirst()
    if v == nil then
        return
    end

    log.Info("Performing command %s", v.Name)

    CommandQueue.Remove(v.Name)

    if v.Name == "joingroup" then
        wait_until_not_casting()
        cmd("/squelch /target clear")
        delay(100)
        cmd("/squelch /invite")
    elseif v.Name == "joinraid" then
        wait_until_not_casting()
        cmd("/notify ConfirmationDialogBox Yes_Button leftmouseup")
        cmd("/squelch /raidaccept")
    elseif v.Name == "zoned" then
        pet.ConfigureTaunt()

        joinCurrentHealChannel()
        memorizeListedSpells()
    elseif v.Name == "playmelody" then
        bard.PlayMelody(v.Arg)
    else
        all_tellf("ERROR unknown command in queue: %s", v.Name)
    end
end

return CommandQueue
