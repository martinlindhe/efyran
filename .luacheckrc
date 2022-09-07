color = true
max_line_length = false

allow_defined_top = true

globals = { "mq" }

-- https://luacheck.readthedocs.io/en/stable/warnings.html
ignore = {
    "212", -- Unused argument.
    "213", -- Unused loop variable.
    "512", -- Loop can be executed at most once.
}
