---@class Timer
local Timer = {}
Timer.__index = Timer

-- Creates a timer with `duration` length.
---@param duration number seconds
function Timer.new(duration)
    local t = setmetatable({}, Timer)
    t.duration = (duration or 0)*1000
    t:restart()
    return t
end

-- Creates a timer with `duration` length and no time left.
---@param duration number seconds
function Timer.new_expired(duration)
    local t = Timer.new(duration)
    t:expire()
    return t
end

-- Creates a timer with `duration` length that expires in `expireDuration`.
---@param duration number seconds
---@param expireDuration number
function Timer.new_expires_in(duration, expireDuration)
    local t = Timer.new(duration)
    t.expires = mq.gettime() + (expireDuration or 0)*1000
    return t
end

-- Creates a timer with `duration` length and random time left.
---@param duration number seconds
function Timer.new_random(duration)
    local t = Timer.new(duration)
    t.expires = mq.gettime() + math.random(0, (duration or 0)*1000)
    return t
end

-- Return expire time in seconds
---@return integer
function Timer.expires_in(self)
    return self.expires or 0
end

-- Expires timer.
function Timer.expire(self)
    self.expires = 0
end

-- Is timer expired?
---@return boolean
function Timer.expired(self)
    return mq.gettime() >= self.expires
end

-- Restarts timer.
function Timer.restart(self)
    self.expires = mq.gettime() + self.duration
end

return Timer
