LayoutControl = middleclass('LayoutControl', Control)

function LayoutControl:initialize(containingScene, index, x, y, children)
    Control.initialize(self, containingScene, index, x, y, 0, 0, nil, nil)
    self.IsLayoutControl = true
    self.Children = children
end

function LayoutControl:Relayout()
end

function LayoutControl:SendChildrenToScene()
    self.ContainingScene:AddQueuedCallback(function(o)
        for key, control in pairs(self.Children) do
            self.ContainingScene:SetControl(key, control)
        end
    end, self)
end
