Control = middleclass('Control')

function Control:initialize(containingScene, index, x, y, w, h, primaryMouseClickCallback, secondaryMouseClickCallback)
    self.ContainingScene = containingScene -- TODO: type check
    -- best code ever? this code is just 2 years old
    if x then
        self.X = (x * Screen.Dimensions.ScalingX + Screen.Dimensions.Width - Screen.ExpandedOffset)
    end
    if y then
        self.Y = y * Screen.Dimensions.ScalingY
    end
    if w then
        self.Width = w * Screen.Dimensions.ScalingX
    end
    if h then
        self.Height = h * Screen.Dimensions.ScalingY
    end
    self.IsCapturingMouse = false
    self.IsCapturingKeyboard = false
    self.PrimaryMouseClickCallback = primaryMouseClickCallback
    self.SecondaryMouseClickCallback = secondaryMouseClickCallback
    self.Ticks = 0
    self.Index = index
end

function Control:GetRight()
    return self.X + self.Width
end

function Control:GetBottom()
    return self.Y + self.Height
end

function Control:PersistentUpdate()
end
function Control:Update()
end
function Control:Draw()
end
function Control:ModalDraw()
end
function Control:PointToSelf(x, y)

end
function Control:GetLayoutWidth()
    return self.Width
end
function Control:GetLayoutHeight()
    return self.Height
end

function Control:GetBounds()
    return {
        X = self.X,
        Y = self.Y,
        Width = self.Width,
        Height = self.Height
    }
end

function Control:OnKeyDown(e)
end

function Control:OnKeyUp(e)
end

function Control:OnMouseDown(e)
end
function Control:OnMouseUp(e)
end
function Control:OnMouseMove(e)
end
function Control:OnMouseEnter(e)
end
function Control:OnMouseLeave(e)
end
function Control:OnThemeChanged(e)
end