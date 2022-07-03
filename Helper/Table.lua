Table = {}

function Table.DeepCopy(T)
    local u = {}
    for k, v in pairs(T) do
        u[k] = v
    end
    return setmetatable(u, getmetatable(T))
end

function Table.Create(length, fillValue)
    local table = {}
    for i = 1, length, 1 do
        table[i] = fillValue
    end
    return table
end

function Table.HashLength(T)
    local i = 0
    for i, v in pairs(t) do
        i = i + 1
    end
    return i
end
