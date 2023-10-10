
---@class CommandHandler
---@field Id string
---@field Execute fun()


local random = math.random
local function uuid()
    math.randomseed(os.time())
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

---@class CommandQueue
---@field private queue CommandHandler[]
local commandQueue = {
    queue = {},
}

---@param command fun()
function commandQueue.Add(command)
    table.insert(commandQueue.queue, { Id = uuid(), Execute = command })
end

---@return CommandHandler|nil
function commandQueue.Pop()
    for idx, command in ipairs(commandQueue.queue) do
        table.remove(commandQueue.queue, idx)
        return command
    end

    return nil
end

-- Clears the command queue
function commandQueue.Clear()
    commandQueue.queue = {}
end

function commandQueue.Process()
    local command = commandQueue.Pop()
    if command == nil then
        return
    end

    command.Execute()
end

return commandQueue
