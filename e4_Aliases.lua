local Aliases = {}

function Aliases.Init()
    -- restart all: /bcaa //multiline ; /lua stop e4 ; /timed 5 /lua run e4

    -- CRASH :::    mq.bind('/e4all', mq.cmd.bcaa('//multiline ; /lua stop e4 ; /timed 5 /lua run e4'))

    --[[
    FIXME: does not work...
    mq.bind('/e4all', function()
        mq.cmd.bcaa('/lua stop e4')
        mq.delay(500)
        mq.cmd.bcaa('/lua run e4')
    end)
    ]]--

    --print('DONE Aliases.Init')
end

return Aliases