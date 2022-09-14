local mq = require("mq")
local Queue = { values = {} }
Queue.__index = Queue

-- queue object used for heal requests, buff requests etc

function Queue.new()
    local t = setmetatable({}, Queue)
    return t
end

function Queue.add(self, name, prop)
    table.insert(Queue.values, {
        ["name"] = name,
        ["prop"] = prop,
    })
end

function Queue.remove(self, name)
    local idx = -1

    for k, v in pairs(Queue.values) do
        if v["name"] == name then
            idx = k
        end
    end

    if idx ~= -1 then
        table.remove(Queue.values, idx)
    end
end

function Queue.contains(self, name)
    for k, v in pairs(Queue.values) do
        if v["name"] == name then
            return true
        end
    end
    return false
end

function Queue.size(self)
    local n = 0
    for k, v in pairs(Queue.values) do
        n = n + 1
    end
    --print("queue size: table.getn ", table.getn(self), ", counted ", n)
    return n
end

function Queue.prop(self, name)
    for k, v in pairs(Queue.values) do
        if v["name"] == name then
            return v["prop"]
        end
    end
    return nil
end

--[[
-- removes and return last entry from queue, or nil if empty
function Queue.pop(self)
    -- XXX fixme pop last. currently it pops first item
    print("queue size is now ", Queue:size())
    if Queue:size() > 0 then
        local res = table.remove(Queue.values, 1) -- first entry
        tprint(res)
        print("-- grabbed from queue: ", res)
        return res
    end
    return nil
end
]]--


-- returns first element from queue, or nil if empty
function Queue.peek_first(self)
    for k, v in pairs(Queue.values) do
        return v["name"]
    end
    return nil
end
-- returns text string of "name" values
function Queue.describe(self)
    local res = ""
    for k, v in pairs(Queue.values) do
        res = res .. v["name"] .. ", "
    end
    return res
end

return Queue