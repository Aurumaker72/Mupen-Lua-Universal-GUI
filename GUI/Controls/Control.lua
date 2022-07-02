Control = middleclass('Control')

function Control:initialize(containingScene, x, y, w, h, primaryMouseClickCallback, secondaryMouseClickCallback)
    if not containingScene then -- nvm the parameters shift to left this is useless
        print("You forgot to pass in a reference to the containing scene!")
    end
    self.ContainingScene = containingScene -- let's hope this is a pointer to scene table and not a copy lmfao
    self.X = (x * Screen.Dimensions.ScalingX + Screen.Dimensions.Width - Screen.ExpandedOffset)
    self.Y = y * Screen.Dimensions.ScalingY
    self.Width = w * Screen.Dimensions.ScalingX
    self.Height = h * Screen.Dimensions.ScalingY
    self.IsCapturingMouse = false
    self.PrimaryMouseClickCallback = primaryMouseClickCallback
    self.SecondaryMouseClickCallback = secondaryMouseClickCallback
    self.Ticks = 0
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
