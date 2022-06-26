GDIPlusRenderer = middleclass('GDIPlusRenderer', Renderer)

function GDIPlusRenderer:initialize()
    self.IsStable = false
end

-- TODO: expand C side gdi+ API

function GDIPlusRenderer:DrawRectangle(color, thickness, x, y, w, h)
    wgui.fillrecta(x, y, w, h, color) -- TODO: fix channel mismatch, proper no-fill
end
function GDIPlusRenderer:FillRectangle(color, x, y, w, h)
    wgui.fillrecta(x, y, w, h, color) -- TODO: fix channel mismatch
end
function GDIPlusRenderer:DrawEllipse(color, thickness, x, y, w, h)
    wgui.fillellipsea(x, y, w, h, color)  -- TODO: fix channel mismatch, proper no-fill
end
function GDIPlusRenderer:FillEllipse(color, x, y, w, h)
    wgui.fillellipsea(x, y, w, h, color) -- TODO: fix channel mismatch
end
function GDIPlusRenderer:DrawText(color, text, x, y)
    -- TODO: actual GDI+ implementation
    wgui.setcolor(color)
    wgui.setfont(Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE,
        Appearance.Themes[Appearance.CurrentTheme].FONT_NAME, "c")
    wgui.text(x, y, text)
end
function GDIPlusRenderer:DrawLine(color, thickness, x1, y1, x2, y2)
    -- TODO: actual GDI+ implementation
    wgui.setpen(color, thickness)
    wgui.line(x1,y1,x2,y2)
end
