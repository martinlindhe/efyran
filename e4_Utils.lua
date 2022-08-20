local Utils = {}


local Timer = {}
Timer.__index = Timer

-- creates a new Timer, duration in seconds
function Timer.new(duration)
    local t = setmetatable({}, Utils.Timer)
    t.duration = duration
    t:restart()
    return t
end

function Timer.new_expired(duration)
    local t = Timer.new(duration)
    t:expire()
    return t
end

-- expires timer
function Timer.expire(self)
    self.expires = 0
end

-- returns true if timer expired
function Timer.expired(self)
    return os.time() > self.expires
end

-- restarts timer
function Timer.restart(self)
    self.expires = os.time() + self.duration
end

Utils.Timer = Timer

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
        formatting = string.rep("  ", indent) .. k .. ": "
        if type(v) == "table" then
            print(formatting)
            tprint(v, indent+1)
        elseif type(v) == 'boolean' then
            print(formatting .. tostring(v))      
        else
            print(formatting .. v)
        end
    end
end

-- Requires: tbl is a table containing strings; str is a string.
-- Effects : returns true if tbl contains str, false otherwise.
function find_string_in(tbl, str)
    for _, element in ipairs(tbl) do
        if (element == str) then
            return true
        end
    end
    return false
end

return Utils