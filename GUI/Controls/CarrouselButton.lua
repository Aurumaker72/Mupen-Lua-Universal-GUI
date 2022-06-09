CarrouselButton = middleclass('CarrouselButton', Control)

function CarrouselButton:initialize(containingScene, x, y, w, h, items, wrapAround, onSelectedItemChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
    self.Items = items -- Must be of type "string" :)
    self.SelectedItemIndex = 1

    self.WrapAround = wrapAround

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR

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
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor),
        WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
end

function CarrouselButton:Update()
    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
    if Mouse.IsPrimaryClickedInside(self.LeftChevronX, self.LeftChevronY, self.LeftChevronWidth, self.LeftChevronHeight) or Keyboard.KeyPressed("left") then
        if self.WrapAround then
            self.SelectedItemIndex = Numeric.WrappingClamp(self.SelectedItemIndex - 1, 1, #self.Items)
        else
            self.SelectedItemIndex = math.max(self.SelectedItemIndex - 1, 1)
        end
        self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.OnSelectedItemChangedCallback, self)
    end
    if Mouse.IsPrimaryClickedInside(self.RightChevronX, self.RightChevronY, self.RightChevronWidth, self.RightChevronHeight) or Keyboard.KeyPressed("right") then
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
    WGUI.FillRectangle(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.Width + self.X + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.Height + self.Y + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE)
    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    -- WGUI.DrawRectangleBounds(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1, self.LeftChevronX, self.LeftChevronY, self.LeftChevronWidth, self.LeftChevronHeight)
    -- WGUI.DrawRectangleBounds(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1, self.RightChevronX, self.RightChevronY, self.RightChevronWidth, self.RightChevronHeight)

    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, "<",
        self.X + Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 5, self.Y + 2)
    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, ">", self.X + self.Width -
        Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4, self.Y + 2)
    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Items[self.SelectedItemIndex],
        self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 * self.Items[self.SelectedItemIndex]:len(),
        self.Y + self.Height / 2 - 6.5, self.Y + self.Height / 2 - 6.5)

end
