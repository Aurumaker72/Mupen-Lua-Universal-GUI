GDIRenderer = middleclass('GDIRenderer', Renderer)

function GDIRenderer:initialize()
    self.IsStable = true
end

function GDIRenderer:DrawRectangle(color, thickness, x, y, w, h)
    wgui.setpen(color, thickness)
    wgui.rect(x, y, x + w, y + h)
end
function GDIRenderer:FillRectangle(color, x, y, w, h)
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.rect(x, y, x + w, y + h)
end
function GDIRenderer:DrawEllipse(color, thickness, x, y, w, h)
    wgui.setpen(color, thickness)
    wgui.ellipse(x, y, x + w, y + h)
end
function GDIRenderer:FillEllipse(color, x, y, w, h)
    wgui.setbrush(color)
    wgui.setpen(color)
    wgui.ellipse(x, y, x + w, y + h)
end
function GDIRenderer:DrawText(color, text, x, y)
    wgui.setcolor(color)
    wgui.setfont(Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE,
        Appearance.Themes[Appearance.CurrentTheme].FONT_NAME, "c")
    wgui.text(x, y, text)
end
function GDIRenderer:DrawLine(color, thickness, x1, y1, x2, y2)
    wgui.setpen(color, thickness)
    wgui.line(x1,y1,x2,y2)
end
