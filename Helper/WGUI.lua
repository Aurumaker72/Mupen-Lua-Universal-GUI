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

function WGUI.DrawText(color, text, x, y)
    wgui.setcolor(color)
    wgui.setfont(FONT_SIZE,"Arial","c")
    wgui.text(
        x, 
        y,
        text)
end