LayoutControl = middleclass('LayoutControl', Control)

function LayoutControl:initialize(containingScene, index, x, y, spacing, children)
    Control.initialize(self, containingScene, index, x, y, 0, 0, nil, nil)
    self.IsLayoutControl = true
    self.Spacing = self.IsHorizontal and (spacing * Screen.Dimensions.ScalingX) or
                       (spacing * Screen.Dimensions.ScalingY)
    self.Children = children
end

function LayoutControl:Relayout()
end

function LayoutControl:SendChildrenToScene()
    self.ContainingScene:AddQueuedCallback(function(o)
        for key, control in pairs(o.Children) do
            o.ContainingScene:SetControl(key, control)
        end
    end, self)
end
