Table = {}

function Table.Length(T) -- SLOW: do not use in hot code path
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function Table.Copy(T)
    local u = { }
    for k, v in pairs(T) do u[k] = v end
    return setmetatable(u, getmetatable(T))
end

function Table.Create(length, fillValue)
    local table = {}
    for i = 1, length, 1 do
        table[i] = fillValue
    end
    return table
end