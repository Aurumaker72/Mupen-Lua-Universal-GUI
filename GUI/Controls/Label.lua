Label = middleclass('Label', Control)

function Label:initialize(x, y, text)
    Control.initialize(self, x, y, 1, 1)
    self.Text = text
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
end

function Label:Update()
end

function Label:Draw()
    if self.Text then
        WGUI.DrawText(self.CurrentForeColor, self.Text, self.X, self.Y)
    else
        print("Label has no text")
    end 
end

function Label:PersistentUpdate()
    self.CurrentForeColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentForeColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
end

