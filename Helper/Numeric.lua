Numeric = {}

function Numeric.Remap(value, from1, to1, from2, to2)
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2
end

function Numeric.Clamp(value, min, max)
    return math.max( min, math.min(value, max) )
end