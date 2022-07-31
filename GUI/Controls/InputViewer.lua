InputViewer = middleclass('InputViewer', Control)

function InputViewer:initialize(containingScene, index, x, y, w, h)
    Control.initialize(self, containingScene, index, x, y, w, h, primaryMouseClickCallback, secondaryMouseClickCallback)
    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
end

function Button:PersistentUpdate()

    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBackColor),
        CurrentRenderer:HexadecimalColorToRGB(((Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                                  Mouse.IsPrimaryDown()) or Keyboard.KeyHeld(self.ClickKey)) and
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR or
                                                  (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                                      Appearance.Themes[Appearance.CurrentTheme]
                                                          .BUTTON_HOVERED_BACK_COLOR or
                                                      Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR)))

    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBorderColor),
        CurrentRenderer:HexadecimalColorToRGB((Mouse.IsInside(self.X, self.Y, self.Width, self.Height) or
                                                  Keyboard.KeyHeld(self.ClickKey)) and
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.CurrentForeColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentForeColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
end

function Button:Update()

    if Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width, self.Height) or Keyboard.KeyPressed(self.ClickKey) then
        self.ContainingScene:AddQueuedCallback( self.PrimaryMouseClickCallback, self)
    end

    if Mouse.IsSecondaryClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.ContainingScene:AddQueuedCallback( self.SecondaryMouseClickCallback, self)
    end
end

function Button:Draw()

    CurrentStyler:DrawButton(self, self.CurrentBackColor, self.CurrentBorderColor, Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)
    
    if (self.Text) then
        CurrentRenderer:DrawText(self.CurrentForeColor, self.Text, self.X + self.Width / 2 -
            Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 * self.Text:len(), self.Y + self.Height / 2 - 7.5)
    end

end
