WGUI = {} -- potential name conflict

function WGUI.FillRectangleBounds(color, x, y, w, h)
    wgui.setbrush(color)
    wgui.setpen(color)
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
    wgui.setfont(FONT_SIZE,"Arial","c")
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
    if not hex then
        print(debug.traceback())
    end
    hex = hex:gsub("#","")
    return 
    {
        tonumber("0x"..hex:sub(1,2)), 
        tonumber("0x"..hex:sub(3,4)), 
        tonumber("0x"..hex:sub(5,6)),
    }
end

function WGUI.RGBToHexadecimalColor(rgb)
    return "#" .. string.format("%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])
end

function WGUI.TemporalInterpolateRGBColor(currentColor, targetColor)
    currentColor[1] = math.floor(currentColor[1] +  (targetColor[1] - currentColor[1]) * 0.1)
    currentColor[2] = math.floor(currentColor[2] + (targetColor[2] - currentColor[2]) * 0.1)
    currentColor[3] = math.floor(currentColor[3] + (targetColor[3] - currentColor[3]) * 0.1)
    return WGUI.RGBToHexadecimalColor(currentColor)
end