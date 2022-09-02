Label = middleclass('Label', Control)

function Label:initialize(containingScene, index, x, y, text)
    Control.initialize(self, containingScene, index, x, y, 1, 1, nil, nil)
    self.Text = text
    self.ForeColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].LABEL_FORE_COLOR))
end

function Label:Update()
end

function Label:Draw()
    if self.Text then
        CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor), self.Text, self.X,
            self.Y)
    else
        print("Label has no text")
    end
end

function Label:PersistentUpdate()
    self.ForeColor:Update()
end

function Label:OnThemeChanged(e)
    if self.ContainingScene.IsActive then
        self.ForeColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].LABEL_FORE_COLOR))
    else
        self.ForeColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].LABEL_FORE_COLOR))
    end
end

function Label:GetLayoutWidth()
    return Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 * self.Text:len()
end

function Label:GetLayoutHeight()
    return Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE
end

