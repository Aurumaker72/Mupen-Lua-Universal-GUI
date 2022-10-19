Renderer = middleclass('Renderer')

function Renderer:initialize()
    self.IsStable = true
end

function Renderer:DrawRectangle(color, thickness, x, y, w, h, cW, cH)
end
function Renderer:FillRectangle(color, x, y, w, h, cW, cH)
end
function Renderer:DrawEllipse(color, thickness, x, y, w, h)
end
function Renderer:FillEllipse(color, x, y, w, h)
end
function Renderer:DrawText(color, text, x, y)
end
function Renderer:DrawLine(color, thickness, x1, y1, x2, y2)
end
function Renderer:HexadecimalColorToRGB(hex)
    
end

function Renderer:RGBToHexadecimalColor(rgb)
end

function Renderer:FinalizeFrame()
end

function Renderer:DrawPlaceholder(x, y, w, h)
    self:DrawLine(self:RGBToHexadecimalColor({ 255, 0, 0 }), 1,
    x,
    y,
    x+w,
    h)
    self:DrawLine(self:RGBToHexadecimalColor({ 255, 0, 0 }), 1,
    x+w,
    y,
    x,
    h)
end