local mq = require 'mq'
local log = require 'knightlinc/Write'

---@param targetId number
---@return boolean
local function ensureTarget(targetId)
    if not targetId then
        log.Debug("Invalid <targetId>")
      return false
    end

    if mq.TLO.Target.ID() ~= targetId then
      if mq.TLO.SpawnCount("id "..targetId)() > 0 then
        mq.cmdf("/mqtarget id %s", targetId)
        mq.delay(500, function() return mq.TLO.Target.ID() == targetId end)
      else
        log.Warn("EnsureTarget has no spawncount for target id <%d>", targetId)
      end
    end

    return mq.TLO.Target.ID() == targetId
end

return {
    EnsureTarget = ensureTarget
}
