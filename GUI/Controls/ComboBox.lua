ComboBox = middleclass('ComboBox', Control)

function ComboBox:initialize(x, y, w, h, items)
    Control.initialize(self, x, y, w, h)
    self.Items = items
    self.SelectedItemIndex = 0
    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
end

function ComboBox:Update()
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentForeColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
end

function ComboBox:Draw()
   
        WGUI.DrawText(self.CurrentForeColor, self.Text, self.X, self.Y)
    
end