Color = {} -- potential namespace conflict

-- NOTE: performance critical

function Color.HexadecimalColorToRGB(hex)
    --if not hex then
    --    print(debug.traceback())
    --end
    -- OPTIMIZATION: dont copy and reallocate string, instead shift logic indexing by one
    --hex = hex:gsub("#","")
    return 
    {
    -- OPTIMIZATION: dont reallocate string due to concatenation, insetad specify explicit radix
        tonumber(hex:sub(2,3), 16), 
        tonumber(hex:sub(4,5), 16), 
        tonumber(hex:sub(6,7), 16),
    }
end

function Color.RGBToHexadecimalColor(rgb)
    -- OPTIMIZATION: dont reallocate string due to concatenation, instead use prepend # inside format specifier
    return string.format("#%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])--"#" .. string.format("%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])
end

function Color.TemporalInterpolateRGBColor(currentColor, targetColor)
    currentColor[1] = math.floor(currentColor[1] + (targetColor[1] - currentColor[1]) * 0.1)
    currentColor[2] = math.floor(currentColor[2] + (targetColor[2] - currentColor[2]) * 0.1)
    currentColor[3] = math.floor(currentColor[3] + (targetColor[3] - currentColor[3]) * 0.1)
    return Color.RGBToHexadecimalColor(currentColor)
end

