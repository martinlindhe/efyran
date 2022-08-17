local Buffs = {}

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Buffs.RefreshBuffs()
    print('-- RefreshBuffs ', mq.TLO.Me.Class.ShortName, ' ', mq.TLO.Time)

    local settingsFile = settingsRoot .. '/' .. mq.TLO.MacroQuest.Server() .. '_' .. mq.TLO.Me.Class.ShortName() .. '_' .. mq.TLO.Me.Name() .. '.ini'

    for n = 1,20,1
    do
        local buffItem = mq.TLO.Ini(settingsFile, 'Buffs', 'Buff' .. n)()
        if buffItem ~= nil then

            local spell
            if mq.TLO.FindItem(buffItem).ID() ~= nil then
                spell = mq.TLO.FindItem(buffItem).Clicky.Spell
                --print('using clicky', buffItem, spell)
            elseif mq.TLO.Me.Book(buffItem)() ~= nil then
                spell = mq.TLO.Me.Book(mq.TLO.Me.Book(buffItem))
                --print('using book', buffItem, spell)
            else
                print('ERROR cant find buff', buffItem)
            end

            -- print("considering buffing ", spell)

            if mq.TLO.Me.Buff(spell.Name()).ID() == nil then
                print('refreshing buff ', spell.Name())

                if spell.TargetType() == "Self" then
                    mq.cmd.casting('"' .. buffItem .. '"')
                else
                    mq.cmd.casting('"' .. buffItem .. '" -targetid|'.. mq.TLO.Me.ID())
                end

                -- end loop after first successful buff
                break
            end
        end
    end

end

return Buffs
