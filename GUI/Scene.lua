Scene = middleclass('Scene')

function Scene:initialize(controls)
    self.Controls = controls
    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR
    self.IsActive = false
end

function Scene:Update()
    for key, control in pairs(self.Controls) do
        control:Update()
    end
end

function Scene:Draw()

    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
    
    WGUI.FillRectangle(self.CurrentBackColor,
        Screen.Dimensions.Width - Screen.ExpandedOffset, 0, (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2,
        Screen.Dimensions.Height)

    for key, control in pairs(self.Controls) do
        control:Draw()
    end

end
