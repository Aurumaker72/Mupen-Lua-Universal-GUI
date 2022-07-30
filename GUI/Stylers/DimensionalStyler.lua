DimensionalStyler = middleclass('DimensionalStyler', Styler)

local DEPTH = 3
local DEPTH_DIVISOR = 1

function DimensionalStyler:initialize()
end

function DimensionalStyler:DrawButton(backColor, borderColor, borderSize, x, y, w, h)
    local darkened = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(100,
        CurrentRenderer:HexadecimalColorToRGB(backColor)))
    CurrentRenderer:FillRectangle(borderColor, x - DEPTH_DIVISOR, y - DEPTH_DIVISOR, w, h)
    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
    self:DrawBorder(darkened, borderSize, x, y, w, h)

end

function DimensionalStyler:DrawBorder(borderColor, borderSize, x, y, w, h)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x - DEPTH, y - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x - DEPTH, y - DEPTH, x + w - DEPTH/2, y - DEPTH)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y + h, x - DEPTH, y + h - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x - DEPTH, y - DEPTH, x - DEPTH, y + h - DEPTH )

    CurrentRenderer:DrawLine(borderColor, borderSize, x + w, y, x + w - DEPTH, y - DEPTH)
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y + h, x + w, y + h)

    CurrentRenderer:DrawLine(borderColor, borderSize, x + w, y + h, x + w, y)

    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x + w, y)
    CurrentRenderer:DrawLine(borderColor, borderSize, x, y, x, y + h)

end
