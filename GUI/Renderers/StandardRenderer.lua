StandardRenderer = middleclass('StandardRenderer', Renderer)

function StandardRenderer:initialize()
    self.IsStable = true
end

function StandardRenderer:DrawRectangle(color, thickness, x, y, w, h)
    if not color then
        print(debug.traceback())
    end
    wgui.setpen(color, thickness)
    wgui.rect(x, y, x + w, y + h)
end
function StandardRenderer:FillRectangle(color, x, y, w, h)
    if not color then
        print(debug.traceback())
    end
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.rect(x, y, x + w, y + h)
end
function StandardRenderer:DrawEllipse(color, thickness, x, y, w, h)
    if not color then
        print(debug.traceback())
    end
    wgui.setpen(color, thickness)
    wgui.ellipse(x, y, x + w, y + h)
end
function StandardRenderer:FillEllipse(color, x, y, w, h)
    if not color then
        print(debug.traceback())
    end
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.ellipse(x, y, x + w, y + h)
end
function StandardRenderer:DrawText(color, text, x, y)
    if not color then
        print(debug.traceback())
    end
    wgui.setcolor(color)
    wgui.setfont(Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE,
        Appearance.Themes[Appearance.CurrentTheme].FONT_NAME, "c")
    wgui.text(x, y, text)
end
function StandardRenderer:DrawLine(color, thickness, x1, y1, x2, y2)
    if not color then
        print(debug.traceback())
    end
    wgui.setpen(color, thickness)
    wgui.line(x1,y1,x2,y2)
end

function StandardRenderer:HexadecimalColorToRGB(hex)
    if not hex or type(hex) == "string" == false then
        print(debug.traceback())
    end
    return  -- OPTIMIZATION: dont copy and reallocate string, instead shift logic indexing by one
    {       -- OPTIMIZATION: dont reallocate string due to concatenation, insetad specify explicit radix
        tonumber(hex:sub(2,3), 16), 
        tonumber(hex:sub(4,5), 16), 
        tonumber(hex:sub(6,7), 16),
    }
end

function StandardRenderer:RGBToHexadecimalColor(rgb)
    if not rgb then
        print(debug.traceback())
    end
        -- OPTIMIZATION: dont reallocate string due to concatenation, instead use prepend # inside format specifier
        return string.format("#%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])--"#" .. string.format("%06X", (rgb[1] * 0x10000) + (rgb[2] * 0x100) + rgb[3])
end