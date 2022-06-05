Scene = middleclass('Scene')

function Scene:initialize(controls)
    self.Controls = controls
    self.IsActive = false
end

function Scene:Update()
    for key, control in pairs(self.Controls) do
        control:Update()
    end
end

function Scene:Draw()

    WGUI.FillRectangle(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR,
        Screen.Dimensions.Width - Screen.ExpandedOffset, 0, (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2,
        Screen.Dimensions.Height)

    for key, control in pairs(self.Controls) do
        control:Draw()
    end

end
