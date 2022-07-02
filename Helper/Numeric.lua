Numeric = {}

function Numeric.Remap(value, from1, to1, from2, to2)
    return (value - from1) / (to1 - from1) * (to2 - from2) + from2
end

function Numeric.Clamp(value, min, max)
    return math.max( min, math.min(value, max) )
end

function Numeric.TemporalInterpolateNumber(current, target)
    return Numeric.TemporalInterpolateNumberWithSpeed(0.1, current, target)
end

function Numeric.TemporalInterpolateNumberWithSpeed(factor, current, target)
    current = math.floor(current +  (target - current) * factor)
    return current
end

function Numeric.TemporalInterpolateNumberWithEpsilon(e, current, target)
    if target - current < e then
        return target
    end
    return Numeric.TemporalInterpolateNumber(current, target)
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