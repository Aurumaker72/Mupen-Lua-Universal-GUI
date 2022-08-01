StackPanel = middleclass('StackPanel', Control)

-- Children must inherit from Control
function StackPanel:initialize(containingScene, index, x, y, spacing, isHorizontal, children)
    Control.initialize(self, containingScene, index, x, y, 0, 0, nil, nil)
    self.IsLayoutControl = true
    self.IsHorizontal = isHorizontal
    self.Spacing = self.IsHorizontal and (spacing * Screen.Dimensions.ScalingX) or (spacing * Screen.Dimensions.ScalingY)
    self.Children = children
end

function StackPanel:GetXForControl(control, i)
    if self.IsHorizontal then
        return self.X
    else
        return self.X + ((i * control:GetLayoutWidth()) + i * self.Spacing)
    end
end

function StackPanel:GetYForControl(control, i)
    if self.IsHorizontal then
        return self.Y + ((i * control:GetLayoutHeight()) + i * self.Spacing)
    else
        return self.Y
    end
end

function StackPanel:Relayout()

    -- TODO:
    --  - labels are broken in horizontal stack direction 
    --  - horizontal stack direction just sucks
    --  - mixing controls of different types is catastrophic    
    --  - REWORK ENTIRE APP TO USE ID-BASED 1D TABLES, NOT HASHTABLES
    
    local lowestIndex = -1
    for key, control in pairs(self.Children) do

        if control.Index < lowestIndex or lowestIndex == -1 then
            lowestIndex = control.Index
        end
    end

    for key, control in pairs(self.Children) do

        control.X = self:GetXForControl(control, control.Index - lowestIndex)
        control.Y = self:GetYForControl(control, control.Index - lowestIndex)

        self.ContainingScene:SetControl(key, control)
    end

    -- local tmpI = 0
    -- if self.IsHorizontal then
    --     table.sort(self.ContainingScene.Controls, function(a, b)
    --         tmpI = tmpI + 1
    --         return self:GetXForControl(a, tmpI) < self:GetXForControl(b, tmpI)
    --     end)
    -- else
    --     table.sort(self.ContainingScene.Controls, function(a, b)
    --         tmpI = tmpI + 1
    --         return self:GetYForControl(a, tmpI) < self:GetYForControl(b, tmpI)
    --     end)
    -- end
end
