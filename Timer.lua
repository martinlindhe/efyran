local Timer = {}
Timer.__index = Timer

-- creates a new Timer, duration in seconds
function Timer.new(duration)
    local t = setmetatable({}, Timer)
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

return Timer
