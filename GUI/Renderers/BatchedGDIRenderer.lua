BatchedGDIRenderer = middleclass('BatchedGDIRenderer', StandardRenderer)

local TYPE_RECTANGLE = 0
local TYPE_ELLIPSE = 1
local TYPE_TEXT = 2

function BatchedGDIRenderer:initialize()
    self.IsStable = false
    self.QueuedTypes = {}
    self.QueuedColors = {}
    self.QueuedMisc = {}
    self.QueuedX = {}
    self.QueuedY = {}
    self.QueuedW = {}
    self.QueuedH = {}
end



function BatchedGDIRenderer:DrawRectangle(color, thickness, x, y, w, h)
    self.QueuedTypes[#self.QueuedTypes] = TYPE_RECTANGLE
    self.QueuedColors[#self.QueuedColors] = color
    self.QueuedMisc[#self.QueuedMisc] = nil
    self.QueuedX[#self.QueuedX] = x
    self.QueuedY[#self.QueuedY] = y
    self.QueuedW[#self.QueuedW] = w
    self.QueuedH[#self.QueuedH] = h
end

function BatchedGDIRenderer:FillRectangle(color, x, y, w, h)
    self.QueuedTypes[#self.QueuedTypes] = TYPE_RECTANGLE
    self.QueuedColors[#self.QueuedColors] = color
    self.QueuedMisc[#self.QueuedMisc] = nil
    self.QueuedX[#self.QueuedX] = x
    self.QueuedY[#self.QueuedY] = y
    self.QueuedW[#self.QueuedW] = w
    self.QueuedH[#self.QueuedH] = h
end

function BatchedGDIRenderer:DrawEllipse(color, thickness, x, y, w, h)
    self.QueuedTypes[#self.QueuedTypes] = TYPE_ELLIPSE
    self.QueuedColors[#self.QueuedColors] = color
    self.QueuedMisc[#self.QueuedMisc] = nil
    self.QueuedX[#self.QueuedX] = x
    self.QueuedY[#self.QueuedY] = y
    self.QueuedW[#self.QueuedW] = w
    self.QueuedH[#self.QueuedH] = h
    -- wgui.setpen(color, thickness)
    -- wgui.ellipse(x, y, x + w, y + h)
end

function BatchedGDIRenderer:FillEllipse(color, x, y, w, h)
    self.QueuedTypes[#self.QueuedTypes] = TYPE_ELLIPSE
    self.QueuedColors[#self.QueuedColors] = color
    self.QueuedMisc[#self.QueuedMisc] = nil
    self.QueuedX[#self.QueuedX] = x
    self.QueuedY[#self.QueuedY] = y
    self.QueuedW[#self.QueuedW] = w
    self.QueuedH[#self.QueuedH] = h
    -- wgui.setbrush(color)
    -- wgui.setpen(color)
    -- wgui.ellipse(x, y, x + w, y + h)
end

function BatchedGDIRenderer:DrawText(color, text, x, y)
    self.QueuedTypes[#self.QueuedTypes] = TYPE_TEXT
    self.QueuedColors[#self.QueuedColors] = color
    self.QueuedMisc[#self.QueuedMisc] = text
    self.QueuedX[#self.QueuedX] = x
    self.QueuedY[#self.QueuedY] = y
    self.QueuedW[#self.QueuedW] = nil
    self.QueuedH[#self.QueuedH] = nil
    -- wgui.setcolor(color)
    -- wgui.setfont(Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE,
    --     Appearance.Themes[Appearance.CurrentTheme].FONT_NAME, "c")
    -- wgui.text(x, y, text)
end

function BatchedGDIRenderer:DrawLine(color, thickness, x1, y1, x2, y2)
    wgui.setpen(color, thickness)
    wgui.line(x1, y1, x2, y2)
end

function BatchedGDIRenderer:FinalizeFrame()
    for i = 1, #self.QueuedTypes, 1 do
            
        if self.QueuedTypes[i] == TYPE_RECTANGLE then
            wgui.setbrush(self.QueuedColors[i])
            wgui.setpen(self.QueuedColors[i])
            wgui.rect(self.QueuedX[i],self.QueuedY[i],self.QueuedX[i]+self.QueuedW[i],self.QueuedY[i]+self.QueuedH[i])
        end

        if self.QueuedTypes[i] == TYPE_ELLIPSE then
            wgui.setbrush(self.QueuedColors[i])
            wgui.setpen(self.QueuedColors[i])
            wgui.ellipse(self.QueuedX[i],self.QueuedY[i],self.QueuedX[i]+self.QueuedW[i],self.QueuedY[i]+self.QueuedH[i])
        end
        
        if self.QueuedTypes[i] == TYPE_TEXT then
            wgui.setcolor(self.QueuedColors[i])
            wgui.setfont(Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE,
                Appearance.Themes[Appearance.CurrentTheme].FONT_NAME, "c")
            wgui.text(self.QueuedX[i], self.QueuedY[i], self.QueuedMisc[i])
        end
        
    end
    self.QueuedColors = {}
    self.QueuedX = {}
    self.QueuedY = {}
    self.QueuedW = {}
    self.QueuedH = {}
end

