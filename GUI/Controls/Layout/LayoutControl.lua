LayoutControl = middleclass('LayoutControl', Control)

function LayoutControl:initialize(containingScene, index, x, y, spacing, children)
    Control.initialize(self, containingScene, index, x, y, 0, 0, nil, nil)
    self.IsLayoutControl = true
    self.Spacing = self.IsHorizontal and (spacing * Screen.Dimensions.ScalingX) or (spacing * Screen.Dimensions.ScalingY)
    self.Children = children
end

function LayoutControl:GetXForControl(control, i)
    if self.IsHorizontal then
        return self.X + ((i * control:GetLayoutWidth()) + i * self.Spacing)
    else
        return self.X
    end
end

function LayoutControl:GetYForControl(control, i)
    if self.IsHorizontal then
        return self.Y
    else
        return self.Y + ((i * control:GetLayoutHeight()) + i * self.Spacing)
    end
end

function LayoutControl:SetChild(key, control)
    self.ContainingScene:SetControl(key, control)
end

function LayoutControl:Relayout()
end
