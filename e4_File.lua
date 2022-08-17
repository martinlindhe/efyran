local File = {}

function File.readAll(file)
    print('File.readAll ', file)
    local f = io.open(file, 'rb')
    if f then
        local content = f:read('*all')
        f:close()
        return content
    else
        mq.cmd.dgtell('File not found: ', file)
        mq.cmd.beep(1)
        return nil
    end
end

return File