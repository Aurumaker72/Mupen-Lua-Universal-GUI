ToggleButton = middleclass('ToggleButton', Button)

function ToggleButton:initialize(x, y, w, h, text, isChecked, clickCallback)
    Button.initialize(self, x, y, w, h, text, clickCallback)
    self.IsChecked = isChecked
end

function ToggleButton:Update()
    if Mouse.ClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.IsChecked = not self.IsChecked
        self.ClickCallback(self)
    end


end

function ToggleButton:PersistentUpdate()
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor), WGUI.HexadecimalColorToRGB(self.TargetBackColor))
    self.CurrentBorderColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBorderColor), WGUI.HexadecimalColorToRGB(self.TargetBorderColor))
end

function ToggleButton:Draw()
    self.TargetBorderColor = Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
    Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR

    if (self.IsChecked) then
        self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR
    end

    WGUI.FillRectangle(self.CurrentBorderColor, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE,
        self.Height + self.Y + BORDER_SIZE)

    self.TargetBackColor = (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Mouse.IsDown()) and
    Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_COLOR or Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR

    if (self.IsChecked) then
        self.TargetBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR
    end

    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    if (self.Text) then
        WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + self.Width / 2 - 4 * self.Text:len(),
            self.Y + self.Height / 2 - 8)
    end
end
