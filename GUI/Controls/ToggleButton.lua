ToggleButton = middleclass('ToggleButton', Button)

function ToggleButton:initialize(x, y, w, h, text, clickCallback)
    Button.initialize(self, x, y, w, h, text, clickCallback)
    self.IsChecked = false
end

function ToggleButton:Update()
    if Mouse.ClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.IsChecked = not self.IsChecked
        self.ClickCallback(self)
    end
end

function ToggleButton:Draw()
    local borderColor = Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and BUTTON_HOVERED_BORDER_COLOR or
                            BUTTON_BORDER_COLOR

    if (self.IsChecked) then
        borderColor = BUTTON_HOVERED_BORDER_COLOR
    end

    WGUI.FillRectangle(borderColor, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE,
        self.Height + self.Y + BORDER_SIZE)

    local backColor = (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Mouse.IsDown()) and
                          BUTTON_PUSHED_COLOR or BUTTON_BACK_COLOR

    if (self.IsChecked) then
        backColor = BUTTON_PUSHED_BACK_COLOR
    end

    wgui.setbrush(backColor)
    wgui.setpen(backColor)
    wgui.rect(self.X, self.Y, self.Width + self.X, self.Height + self.Y)
    if (self.Text) then
        WGUI.DrawText(BUTTON_FORE_COLOR, self.Text, self.X + self.Width / 2 - 4 * self.Text:len(),
            self.Y + self.Height / 2 - 8)
    end
end
