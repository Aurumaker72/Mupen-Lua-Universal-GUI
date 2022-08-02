Grid = middleclass('Grid', LayoutControl)

-- Children must inherit from Control
function Grid:initialize(containingScene, index, x, y, spacing, children, rowCount, columnCount)
    LayoutControl.initialize(self, containingScene, index, x, y, spacing, children)
    self.Rows = rowCount
    self.Columns = columnCount
end

function Grid:Relayout()

    -- uh

end
