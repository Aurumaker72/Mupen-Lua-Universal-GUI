Button = middleclass('Button', Control)

function Button:initialize(x, y, w, h, text, clickCallback)
    Control.initialize(self, x, y, w, h)
    self.Text = text
    self.ClickCallback = clickCallback
    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR
end

function Button:PersistentUpdate()
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor), WGUI.HexadecimalColorToRGB((Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Mouse.IsDown()) and
    Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR or Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.CurrentBorderColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBorderColor), WGUI.HexadecimalColorToRGB(Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
    Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
end

function Button:Update()
    if Mouse.ClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.ClickCallback(self)
    end
end

function Button:Draw()

    WGUI.FillRectangle(self.CurrentBorderColor, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE,
        self.Height + self.Y + BORDER_SIZE)

    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    if (self.Text) then
        WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + self.Width/2 - FONT_SIZE/3 * self.Text:len(),
            self.Y + self.Height / 2 - 7.5)
    end

    
end
