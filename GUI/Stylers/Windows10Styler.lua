Windows10Styler = middleclass('Windows10Styler', Styler)

function Windows10Styler:initialize()
end

function Windows10Styler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
end


function Windows10Styler:DrawBorder(control, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2)
end

function Windows10Styler:DrawGenericAccentShape(control, backColor, x, y, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
end