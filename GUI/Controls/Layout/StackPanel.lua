StackPanel = middleclass('StackPanel', LayoutControl)

-- Children must inherit from Control
function StackPanel:initialize(containingScene, index, x, y, spacing, children, isHorizontal)
    LayoutControl.initialize(self, containingScene, index, x, y, children)
    self.IsHorizontal = isHorizontal
    self.Spacing = self.IsHorizontal and (spacing * Screen.Dimensions.ScalingX) or
        (spacing * Screen.Dimensions.ScalingY)
    print(self.X .. " " .. self.Y)
end

function StackPanel:Relayout()

    local lowestIndex = -1
    for key, control in pairs(self.Children) do
        if control.Index < lowestIndex or lowestIndex == -1 then
            lowestIndex = control.Index
        end
    end

    local childrenSortedByIndex = {};
    for key, value in pairs(self.Children) do
        childrenSortedByIndex[#childrenSortedByIndex + 1] = {
            key = key,
            control = value,
        };
    end
    table.sort(childrenSortedByIndex, function(k1, k2) return k1.control.Index < k2.control.Index end)

    if self.IsHorizontal then
        local currentX = self.X;
        for i = 1, #childrenSortedByIndex, 1 do

            childrenSortedByIndex[i].control.X = currentX;
            childrenSortedByIndex[i].control.Y = self.Y;

            currentX = currentX + childrenSortedByIndex[i].control:GetLayoutWidth() + self.Spacing;
        end
    else
        local currentY = self.Y;
        for i = 1, #childrenSortedByIndex, 1 do

            childrenSortedByIndex[i].control.X = self.X;
            childrenSortedByIndex[i].control.Y = currentY;

            currentY = currentY + childrenSortedByIndex[i].control:GetLayoutHeight() + self.Spacing;
        end
    end

    for i = 1, #childrenSortedByIndex, 1 do
        self.Children[childrenSortedByIndex[i].key] = childrenSortedByIndex[i].control;
    end

    self:SendChildrenToScene()
end
