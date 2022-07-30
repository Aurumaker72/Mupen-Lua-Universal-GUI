ToggleButton = middleclass('ToggleButton', Button)

function ToggleButton:initialize(containingScene, clickKey, x, y, w, h, text, isChecked, primaryMouseClickCallback,
    secondaryMouseClickCallback)
    Button.initialize(self, containingScene, clickKey, x, y, w, h, text, primaryMouseClickCallback,
        secondaryMouseClickCallback)
    self.IsChecked = isChecked
end

function ToggleButton:Update()
    if Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width, self.Height) or Keyboard.KeyHeld(self.ClickKey) then
        self.IsChecked = not self.IsChecked
        self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.PrimaryMouseClickCallback, self)
    end

    if Mouse.IsSecondaryClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.SecondaryMouseClickCallback, self)
    end
end

function ToggleButton:PersistentUpdate()
    self.TargetBorderColor =
        (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) or Keyboard.KeyHeld(self.ClickKey)) and
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR
    self.TargetBackColor = ((Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Mouse.IsPrimaryDown()) or
                               Keyboard.KeyHeld(self.ClickKey)) and
                               Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR or
                               (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                   Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BACK_COLOR or
                                   Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR)

    if (self.IsChecked) then
        self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR
        self.TargetBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR
    end

    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBackColor),
        CurrentRenderer:HexadecimalColorToRGB(self.TargetBackColor))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBorderColor),
        CurrentRenderer:HexadecimalColorToRGB(self.TargetBorderColor))
end

function ToggleButton:Draw()
    CurrentStyler:DrawButton(self.CurrentBackColor, self.CurrentBorderColor,
        Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    if (self.Text) then
        CurrentRenderer:DrawText(self.IsChecked and
                                     Appearance.Themes[Appearance.CurrentTheme].TOGGLEBUTTON_CHECKED_FORE_COLOR or
                                     Appearance.Themes[Appearance.CurrentTheme].TOGGLEBUTTON_UNCHECKED_FORE_COLOR,
            self.Text, self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 *
                self.Text:len(), self.Y + self.Height / 2 - 7.5)
    end
end
