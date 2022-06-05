Label = middleclass('Label', Control)

function Label:initialize(x, y, w, h, text)
    Control.initialize(self, x, y, w, h)
    self.Text = text
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
end

function Label:Update()
    self.CurrentForeColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentForeColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
end

function Label:Draw()
    if (self.Text) then
        WGUI.DrawText(self.CurrentForeColor, self.Text, self.X, self.Y)
    end
end
