FlatStyler = middleclass('FlatStyler', Styler)

function FlatStyler:initialize()
end

function FlatStyler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
end
function FlatStyler:DrawBorder(control, borderColor, borderSize, x, y, w, h)
end