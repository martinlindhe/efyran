--- reports if we are not running e4


mq = require("mq")

local found = false

local others = ""

-- comma separated list of integer pids with info to access
for pid in string.gmatch(mq.TLO.Lua.PIDs(), '([^,]+)') do
    local luainfo = mq.TLO.Lua.Script(pid)   --- luainfo
    if luainfo.Name() == "e4" then
        found = true
    else
        others = others .. ", " .. luainfo.Name()
    end
end

if not found then
    local extra = ""
    if others ~= "" then
        extra = " Running "..others
    end
    mq.cmd.dgtell("all Not running e4.")
end
