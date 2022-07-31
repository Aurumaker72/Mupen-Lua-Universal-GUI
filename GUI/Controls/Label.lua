Label = middleclass('Label', Control)

function Label:initialize(containingScene, index, x, y, text)
    Control.initialize(self, containingScene, index, x, y, 1, 1, nil, nil)
    self.Text = text
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].LABEL_FORE_COLOR
end

function Label:Update()
end

function Label:Draw()
    if self.Text then
        CurrentRenderer:DrawText(self.CurrentForeColor, self.Text, self.X, self.Y)
    else
        print("Label has no text")
    end
end

function Label:PersistentUpdate()
    self.CurrentForeColor = Color.TemporalInterpolateRGBColor(CurrentRenderer:HexadecimalColorToRGB(self.CurrentForeColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
end

function Label:GetLayoutWidth()
    return Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 * self.Text:len()
end

function Label:GetLayoutHeight()
    return Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE
end

