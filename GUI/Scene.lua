Scene = middleclass('Scene')

function Scene:initialize(controls)
	self.Controls = controls
    self.IsActive = false
end

function Scene:Update()
    for i = 1, table.getn(self.Controls), 1 do
        self.Controls[i]:Update()
    end
end

function Scene:Draw()

    WGUI.FillRectangle(Appearance.Themes[CurrentTheme].WINDOW_BACK_COLOR, Screen.Dimensions.Width - Screen.ExpandedOffset, 0,
        (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2, Screen.Dimensions.Height)

    for i = 1, table.getn(self.Controls), 1 do
        self.Controls[i]:Draw()
    end
end