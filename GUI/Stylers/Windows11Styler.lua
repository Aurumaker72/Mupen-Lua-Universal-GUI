Windows11Styler = middleclass('Windows11Styler', Styler)

function Windows11Styler:initialize()
end

function Windows11Styler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2, 2, 2)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h, 2, 2)
end


function Windows11Styler:DrawBorder(control, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2, 2, 2)
end

function Windows11Styler:DrawGenericAccentShape(control, backColor, x, y, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h, 2, 2)
end