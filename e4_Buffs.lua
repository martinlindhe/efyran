local Buffs = {}

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Buffs.RefreshBuffs()
    print('RefreshBuffs XXX ', mq.TLO.Me.Class.ShortName, ' ', mq.TLO.Time)

    local settingsFile = settingsRoot .. '/' .. mq.TLO.MacroQuest.Server() .. '_' .. mq.TLO.Me.Class.ShortName() .. '_' .. mq.TLO.Me.Name() .. '.ini'

    for n = 1,20,1
    do
        local buff = mq.TLO.Ini(settingsFile, 'Buffs', 'Buff' .. n)()
        if buff ~= nil then
            print(type(buff), 'XXX cast ', buff)

            -- XXX check my buffs. ..

            --  mq.TLO.Me.Buff('Flight of Eagles')
        end
    end

end

return Buffs