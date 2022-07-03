CarrouselButton = middleclass('CarrouselButton', Control)

function CarrouselButton:initialize(containingScene, x, y, w, h, items, wrapAround, onSelectedItemChangedCallback)
    h = math.min(h, 20) -- limit height to 20
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
    self.Items = items -- Must be of type "string" :)
    self.SelectedItemIndex = 1

    self.WrapAround = wrapAround

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR

    self.CurrentLeftChevronX = self.X + Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_MARGIN
    self.CurrentRightChevronX = self.X + self.Width -
                                    Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 -
                                    Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_MARGIN
    self.TargetLeftChevronX = self.CurrentLeftChevronX
    self.TargetRightChevronX = self.CurrentRightChevronX

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback
end

function CarrouselButton:PersistentUpdate()

    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBackColor),
        CurrentRenderer:HexadecimalColorToRGB(((Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                                  Mouse.IsPrimaryDown())) and
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR or
                                                  (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and
                                                      Appearance.Themes[Appearance.CurrentTheme]
                                                          .BUTTON_HOVERED_BACK_COLOR or
                                                      Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR)))
    self.CurrentForeColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentForeColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBorderColor),
        CurrentRenderer:HexadecimalColorToRGB((Mouse.IsInside(self.X, self.Y, self.Width, self.Height)) and
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
                                                  Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.TargetLeftChevronX = (Mouse.IsInside(self.X, self.Y, self.Width / 2, self.Height) and self.X or self.X +
                                  Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_MARGIN)
    self.TargetRightChevronX = (Mouse.IsInside(self.X + self.Width / 2, self.Y, self.Width / 2, self.Height) and
                                   (self.X + self.Width -
                                       Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2) or
                                   (self.X + self.Width -
                                       Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 -
                                       Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_MARGIN))
    self.CurrentLeftChevronX = Numeric.TemporalInterpolateNumberWithSpeed(0.4, self.CurrentLeftChevronX,
        self.TargetLeftChevronX)
    self.CurrentRightChevronX = Numeric.TemporalInterpolateNumberWithSpeed(0.4, self.CurrentRightChevronX,
        self.TargetRightChevronX)
end

function CarrouselButton:Update()
    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        if Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width / 2, self.Height) or Keyboard.KeyPressed("left") then
            if self.WrapAround then
                self.SelectedItemIndex = Numeric.WrappingClamp(self.SelectedItemIndex - 1, 1, #self.Items)
            else
                self.SelectedItemIndex = math.max(self.SelectedItemIndex - 1, 1)
            end
            self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.OnSelectedItemChangedCallback, self)
        end
        if Mouse.IsPrimaryClickedInside(self.X + self.Width / 2, self.Y, self.Width / 2, self.Height) or
            Keyboard.KeyPressed("right") then
            if self.WrapAround then
                self.SelectedItemIndex = Numeric.WrappingClamp(self.SelectedItemIndex + 1, 1, #self.Items)
            else
                self.SelectedItemIndex = math.min(self.SelectedItemIndex + 1, #self.Items)
            end
            self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.OnSelectedItemChangedCallback, self)
        end
    end
end

function CarrouselButton:Draw()
    CurrentRenderer:FillRectangle(self.CurrentBorderColor,
        self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Width + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2,
        self.Height + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2)
    CurrentRenderer:FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width, self.Height)

    CurrentRenderer:DrawText(self.CurrentForeColor, "<", self.CurrentLeftChevronX, self.Y + 1)
    CurrentRenderer:DrawText(self.CurrentForeColor, ">", self.CurrentRightChevronX, self.Y + 1)

    CurrentRenderer:DrawText(self.CurrentForeColor, self.Items[self.SelectedItemIndex],
        self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 *
            self.Items[self.SelectedItemIndex]:len(), self.Y + self.Height / 2 - 6.5, self.Y + self.Height / 2 - 6.5)

end
