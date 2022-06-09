WGUI = {} -- potential namespace conflict

function WGUI.FillRectangleBounds(color, x, y, w, h)
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.rect(x, y, x+w, y+h)
end

function WGUI.DrawRectangleBounds(color, thickness, x, y, w, h)
    wgui.setpen(color, thickness)
    wgui.rect(x, y, x+w, y+h)
end

function WGUI.FillRectangle(color, x, y, r, b)
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.rect(x, y, r, b)
end

function WGUI.FillEllipse(color, x, y, w, h)
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.ellipse(x, y, x+w, y+h)
end

function WGUI.DrawEllipse(color, thickness, x, y, w, h)
    wgui.setpen(color, thickness)
    wgui.ellipse(x, y, x+w, y+h)
end

function WGUI.DrawText(color, text, x, y)
    wgui.setcolor(color)
    wgui.setfont(Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE,Appearance.Themes[Appearance.CurrentTheme].FONT_NAME,"c")
    wgui.text(
        x, 
        y,
        text)
end

function WGUI.DrawLine(color, thickness, x1, y1, x2, y2)
    wgui.setpen(color, thickness)
    wgui.line(x1,y1,x2,y2)
end

function WGUI.HexadecimalColorToRGB(hex)
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

function WGUI.RGBToHexadecimalColor(rgb)
    -- OPTIMIZATION: dont reallocate string due to concatenation, instead use prepend # inside format specifier
    return string.format("#%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])--"#" .. string.format("%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])
end

function WGUI.TemporalInterpolateRGBColor(currentColor, targetColor)
    currentColor[1] = math.floor(currentColor[1] + (targetColor[1] - currentColor[1]) * 0.1)
    currentColor[2] = math.floor(currentColor[2] + (targetColor[2] - currentColor[2]) * 0.1)
    currentColor[3] = math.floor(currentColor[3] + (targetColor[3] - currentColor[3]) * 0.1)
    return WGUI.RGBToHexadecimalColor(currentColor)
end

