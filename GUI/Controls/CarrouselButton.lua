CarrouselButton = middleclass('CarrouselButton', Control)

function CarrouselButton:initialize(x, y, w, h, items, onSelectedItemChangedCallback)
    Control.initialize(self, x, y, w, h)
    self.Items = items -- Must be of type "string" :)
    self.SelectedItemIndex = 1

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
    self.CurrentBackColor = 
    WGUI.TemporalInterpolateRGBColor(
        WGUI.HexadecimalColorToRGB(self.CurrentBackColor), 
        WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
end

function CarrouselButton:Update()

    if Mouse.ClickedInside(self.LeftChevronX, self.LeftChevronY, self.LeftChevronWidth, self.LeftChevronHeight) then
        self.SelectedItemIndex = math.max(self.SelectedItemIndex - 1, 1)
        self.OnSelectedItemChangedCallback(self)
    end

    if Mouse.ClickedInside(self.RightChevronX, self.RightChevronY, self.RightChevronWidth, self.RightChevronHeight) then
        self.SelectedItemIndex = math.min(self.SelectedItemIndex + 1, #self.Items)
        self.OnSelectedItemChangedCallback(self)
    end

    self.Ticks = self.Ticks + 1
end

function CarrouselButton:Draw()
    WGUI.FillRectangle(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE, self.Height + self.Y + BORDER_SIZE)
    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    --WGUI.DrawRectangleBounds(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1, self.LeftChevronX, self.LeftChevronY, self.LeftChevronWidth, self.LeftChevronHeight)
    --WGUI.DrawRectangleBounds(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1, self.RightChevronX, self.RightChevronY, self.RightChevronWidth, self.RightChevronHeight)

    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, "<", self.X + Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 5, self.Y + 2)
    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, ">", self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4, self.Y + 2)
    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Items[self.SelectedItemIndex], self.X + self.Width / 2 - FONT_SIZE / 3 * self.Items[self.SelectedItemIndex]:len(), self.Y + self.Height / 2 - 6.5, self.Y + self.Height / 2 - 6.5)
    
end