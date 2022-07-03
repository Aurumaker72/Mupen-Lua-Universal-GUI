RendererHelper = {}

function RendererHelper.DrawBorderedRectangle(backColor, borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
end
