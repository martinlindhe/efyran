--- reports if we are not running e4

require("ezmq")

-- returns a comma-separated list of all running scripts, except for `name`.
---@param name string
local function get_running_scripts_except(name)
    local others = ""
    for pid in string.gmatch(mq.TLO.Lua.PIDs(), '([^,]+)') do
        ---@diagnostic disable-next-line: param-type-mismatch
        local luainfo = mq.TLO.Lua.Script(pid)
        if luainfo.Name() ~= name then
            others = others .. ", " .. luainfo.Name()
        end
    end
    return others
end

if not is_script_running("efyran") then
    all_tellf("Not running efyran. %s", get_running_scripts_except("efyran"))
end
