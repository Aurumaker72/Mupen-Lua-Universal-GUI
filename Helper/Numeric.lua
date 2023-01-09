Numeric = {}

function Numeric.Remap(value, from1, to1, from2, to2)
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2
end

function Numeric.Clamp(value, min, max)
    return math.max(min, math.min(value, max))
end

function Numeric.PointIsInsideRectangle(pX, pY, x, y, w, h)
    return pX > x and pX < x + w and pY > y and pY < y + h
end

function Numeric.WrappingClamp(value, min, max) -- there has got to be branchless bithack for this!!!
    if value > max then
        return min
    end
    if value < min then
        return max
    end
    return value
end

function Numeric.IsNumeric(str)
    return not str:match("%W")
end
