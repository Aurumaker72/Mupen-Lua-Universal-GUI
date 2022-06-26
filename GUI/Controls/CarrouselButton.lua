CarrouselButton = middleclass('CarrouselButton', Control)

function CarrouselButton:initialize(containingScene, x, y, w, h, items, wrapAround, onSelectedItemChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
    self.Items = items -- Must be of type "string" :)
    self.SelectedItemIndex = 1

    self.WrapAround = wrapAround

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR

    self.LeftChevronX = self.X
    self.LeftChevronY = self.Y
    self.LeftChevronWidth = Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.LeftChevronHeight = self.Height

    self.RightChevronX = self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronY = self.Y
    self.RightChevronWidth = Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronHeight = self.Height

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback
end

function CarrouselButton:PersistentUpdate()
    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentBackColor),
        Color.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.CurrentForeColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentForeColor),
        Color.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentBorderColor),
        Color.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))

end

function CarrouselButton:Update()
    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        if Mouse.IsPrimaryClickedInside(self.LeftChevronX, self.LeftChevronY, self.LeftChevronWidth,
            self.LeftChevronHeight) or Keyboard.KeyPressed("left") then
            if self.WrapAround then
                self.SelectedItemIndex = Numeric.WrappingClamp(self.SelectedItemIndex - 1, 1, #self.Items)
            else
                self.SelectedItemIndex = math.max(self.SelectedItemIndex - 1, 1)
            end
            self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.OnSelectedItemChangedCallback, self)
        end
        if Mouse.IsPrimaryClickedInside(self.RightChevronX, self.RightChevronY, self.RightChevronWidth,
            self.RightChevronHeight) or Keyboard.KeyPressed("right") then
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

    CurrentRenderer:DrawText(self.CurrentForeColor, "<", self.X +
        Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 5, self.Y + 2)
    CurrentRenderer:DrawText(self.CurrentForeColor, ">", self.X + self.Width -
        Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4, self.Y + 2)
    CurrentRenderer:DrawText(self.CurrentForeColor, self.Items[self.SelectedItemIndex],
        self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 *
            self.Items[self.SelectedItemIndex]:len(), self.Y + self.Height / 2 - 6.5, self.Y + self.Height / 2 - 6.5)

end
