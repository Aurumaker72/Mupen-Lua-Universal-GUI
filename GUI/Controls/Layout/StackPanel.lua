StackPanel = middleclass('StackPanel', LayoutControl)

-- Children must inherit from Control
function StackPanel:initialize(containingScene, index, x, y, spacing, children, isHorizontal)
    LayoutControl.initialize(self, containingScene, index, x, y, spacing, children)
    self.IsHorizontal = isHorizontal
end

function StackPanel:GetXForControl(control, i)
    if self.IsHorizontal then
        return self.X + ((i * control:GetLayoutWidth()) + i * self.Spacing)
    else
        return self.X
    end
end

function StackPanel:GetYForControl(control, i)
    if self.IsHorizontal then
        return self.Y
    else
        return self.Y + ((i * control:GetLayoutHeight()) + i * self.Spacing)
    end
end

function StackPanel:Relayout()

    -- TODO:
    --  - labels are broken in horizontal stack direction 
    --  - horizontal stack direction just sucks
    --  - mixing controls of different types is catastrophic    
    
    local lowestIndex = -1
    for key, control in pairs(self.Children) do

        if control.Index < lowestIndex or lowestIndex == -1 then
            lowestIndex = control.Index
        end
    end

    for key, control in pairs(self.Children) do

        control.X = self:GetXForControl(control, control.Index - lowestIndex)
        control.Y = self:GetYForControl(control, control.Index - lowestIndex)

    end

    self:SendChildrenToScene()
end
