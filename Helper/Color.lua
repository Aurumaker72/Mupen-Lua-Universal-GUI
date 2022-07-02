Color = {
    InterpolationEpsilon = 15
} -- potential namespace conflict

function Color.TemporalInterpolateRGBColor(currentColor, targetColor)
    if not currentColor then
        print(debug.traceback())
    end
    
    local differenceR = math.abs(targetColor[1] - currentColor[1])
    local differenceG = math.abs(targetColor[2] - currentColor[2])
    local differenceB = math.abs(targetColor[3] - currentColor[3])
    if (differenceR + differenceG + differenceB) / 3 < Color.InterpolationEpsilon then
        currentColor = targetColor
        CurrentRenderer:RGBToHexadecimalColor(currentColor)
    end

    currentColor[1] = math.floor(currentColor[1] + (targetColor[1] - currentColor[1]) * 0.1)
    currentColor[2] = math.floor(currentColor[2] + (targetColor[2] - currentColor[2]) * 0.1)
    currentColor[3] = math.floor(currentColor[3] + (targetColor[3] - currentColor[3]) * 0.1)

    return CurrentRenderer:RGBToHexadecimalColor(currentColor)
end

