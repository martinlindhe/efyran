-- Queue object used for heal requests, buff requests, etc.

---@class QueueValue
---@field public Name string Name
---@field public Prop string|nil Property

local Queue = {
    ---@type QueueValue[]
     values = {}
}
Queue.__index = Queue

function Queue.new()
    local t = setmetatable({}, Queue)
    return t
end

function Queue.add(self, name, prop)
    table.insert(Queue.values, {
        ["Name"] = name,
        ["Prop"] = prop,
    })
end

function Queue.remove(self, name)
    local idx = -1

    for k, v in pairs(Queue.values) do
        if v.Name == name then
            idx = k
        end
    end

    if idx ~= -1 then
        table.remove(Queue.values, idx)
    end
end

function Queue.contains(self, name)
    for k, v in pairs(Queue.values) do
        if v.Name == name then
            return true
        end
    end
    return false
end

function Queue.size(self)
    return #Queue.values
end

---@return string|nil
function Queue.prop(self, name)
    for k, v in pairs(Queue.values) do
        if v.Name == name then
            return v.Prop
        end
    end
    return nil
end

-- returns first element from queue, or nil if empty
function Queue.peek_first(self)
    for k, v in ipairs(Queue.values) do
        return v.Name
    end
    return nil
end

-- returns text string of "name" values
function Queue.describe(self)
    local res = ""
    for k, v in pairs(Queue.values) do
        res = res .. v.Name .. ", "
    end
    return res
end

return Queue
