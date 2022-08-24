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
function tprint(tbl, indent)
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


function is_rof2()
    -- XXX hack, will be able to check if on emu with MacroQuest.Build value soon
    --  ? value == 1 is live (?), value 2 is test, 3 is beta, 4 is rof2-emu
    -- XXX BEST YET: MacroQuest.BuildName is a text string (Live, Test, Beta, Emu) ? 21 aug '22, not yet in master branch
    if mq.TLO.EverQuest.Server() == "antonius" then
        return false
    end
    return true
end

-- returns true if spawn is another peer
function is_peer(spawn)
    if spawn == nil or spawn.Type() ~= "PC" then
        return false
    end
    return mq.TLO.DanNet(spawn.Name())() ~= nil
end

-- returns true if spawnID is another peer
function is_peer_id(spawnID)
    return is_peer(spawn_from_id(spawnID))
end

-- returns true if spawnID is in LoS
function is_spawn_los(spawnID)
    local spawn = spawn_from_id(spawnID)
    return spawn ~= nil and spawn.LineOfSight()
end

-- return spawn or nil
function spawn_from_id(spawnID)
    local spawn = mq.TLO.Spawn("id " .. spawnID)
    if tostring(spawn) == "NULL" then
        return nil
    end
    return spawn
end

-- returns a spawn, nil if not found
function spawn_from_peer_name(name)
    local v = mq.TLO.Spawn("pc =" .. name)
    if v() == "NULL" then
        return nil
    end
    return v
end

return Utils
