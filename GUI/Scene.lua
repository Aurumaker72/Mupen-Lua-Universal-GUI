Scene = middleclass('Scene')

function Scene:initialize(controls)
    self.Controls = controls
    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR
    self.IsActive = false
end

function Scene:Update()

    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))

    for key, control in pairs(self.Controls) do
        if self.IsActive then
        control:Update()
        end
        control:PersistentUpdate()
    end
end

function Scene:Draw()

    
    --WGUI.FillRectangle(self.CurrentBackColor,
    --   Screen.Dimensions.Width - Screen.ExpandedOffset, 0, (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2,
    --   Screen.Dimensions.Height)

    if self.IsActive then
        for key, control in pairs(self.Controls) do
            control:Draw()
        end
    end
    

end
