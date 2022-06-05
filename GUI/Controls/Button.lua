Button = middleclass('Button', Control)

function Button:initialize(x, y, w, h, text, clickCallback)
    Control.initialize(self, x, y, w, h)
    self.Text = text
    self.ClickCallback = clickCallback
end

function Button:Update()
    if Mouse.ClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.ClickCallback(self)
    end
end

function Button:Draw()
    local borderColor = Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Appearance.Themes[CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
    Appearance.Themes[CurrentTheme].BUTTON_BORDER_COLOR

    WGUI.FillRectangle(borderColor, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE,
        self.Height + self.Y + BORDER_SIZE)

    local backColor = (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Mouse.IsDown()) and
    Appearance.Themes[CurrentTheme].BUTTON_PUSHED_BACK_COLOR or Appearance.Themes[CurrentTheme].BUTTON_BACK_COLOR

    WGUI.FillRectangle(backColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    if (self.Text) then
        WGUI.DrawText(Appearance.Themes[CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + self.Width / 2 - FONT_SIZE / 3 * self.Text:len(),
            self.Y + self.Height / 2 - 8)
    end
end
