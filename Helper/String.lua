String = {}

function String.ToTable(str)
    local strTable = {}
    str:gsub(".", function(c) table.insert(strTable, c) end)
    return strTable
end

function String.FromTable(t)
    local str = ""
    for i = 1, #t, 1 do
        str = str .. t
    end
    return str
end

function String.RemoveAt(str, index)
    return str:sub(1, index - 1) .. str:sub(index + 1, str:len())
end

function String.InsertAt(str, str2, index)
    return str:sub(1, index) .. str2 .. str:sub(index + str2:len(), str:len())
end

function String.SetAt(str, str2, index)
    return str:sub(1, index - 1) .. str2 .. str:sub(index + str2:len(), str:len())
end

function String.GetCharAt(str, index)
    return str:sub(index, index)
end
