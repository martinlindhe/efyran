--- reports if we are not running e4

require("ezmq")

if not is_script_running("e4") then
    all_tellf("Not running e4. %s", get_running_scripts_except("e4"))
end
