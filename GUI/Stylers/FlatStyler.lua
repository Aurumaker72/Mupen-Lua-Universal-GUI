FlatStyler = middleclass('FlatStyler', Styler)

function FlatStyler:initialize()
end

function FlatStyler:DrawButton(control, backColor, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
end
function FlatStyler:DrawBorder(borderColor, borderSize, x, y, w, h)
end