local file = require('e4_File')

Buffs = { selfBuffs = nil }

-- FIXME: relative path...
local settingsRoot = 'D:/dev-mq/mqnext-e4-lua/settings'

function Buffs.RefreshBuffs()
    print('-- RefreshBuffs ', mq.TLO.Me.Class.ShortName, ' ', mq.TLO.Time)

    if Buffs.selfBuffs == nil then
        local settingsFile = settingsRoot .. '/' .. mq.TLO.MacroQuest.Server() .. '_' .. mq.TLO.Me.Class.ShortName() .. '_' .. mq.TLO.Me.Name() .. '.lua'

        local settings = loadfile(settingsFile)()


        -- read on script start. yaml parser is slow !!!
        --local settings = file.tokenizeYaml(settingsFile)
        if settings ~= nil then
            Buffs.selfBuffs = settings.buffs
            print('loaded selfbuffs:')
            tprint(Buffs.selfBuffs)
        else
            -- give up. no settings file found
            mq.cmd.dgtell('File not found: ', settingsFile)
            mq.cmd.beep(1)
            return
        end
    end

    for k, buffItem in pairs(Buffs.selfBuffs) do
        --local buffItem = mq.TLO.Ini(settingsFile, 'Buffs', 'Buff' .. n)()

        local spell
        if mq.TLO.FindItem(buffItem).ID() ~= nil then
            spell = mq.TLO.FindItem(buffItem).Clicky.Spell
            --print('using clicky ', buffItem, ', spell: ', spell)
        elseif mq.TLO.Me.Book(buffItem)() ~= nil then
            spell = mq.TLO.Me.Book(mq.TLO.Me.Book(buffItem))
            --print('using book ', buffItem, ', spell: ', spell)
        elseif mq.TLO.Me.AltAbility(buffItem)() ~= nil then
            spell = mq.TLO.Me.AltAbility(buffItem).Spell
            --print('using aa ', buffItem, ', spell: ', spell)
        else
            mq.cmd.dgtell('ERROR cant find buff ', buffItem)
        end

        -- print("considering buffing ", spell)

        -- refresh missing buffs or ones fading within 2 ticks
        if mq.TLO.Me.Buff(spell.Name()).ID() == nil or mq.TLO.Me.Buff(spell.Name()).Duration.Ticks() <= 2 then
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

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function tprint (tbl, indent)
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


return Buffs

