Joystick = middleclass('Joystick', Control)

function Joystick:initialize(x, y, w, h, readOnly, valueChangedCallback)
    Control.initialize(self, x, y, w, h)
    self.ValueChangedCallback = valueChangedCallback
    self.ValueX = 0
    self.ValueY = 0
    self.IsReadOnly = readOnly
end

function Joystick:Update()
    if self.IsReadOnly then
        return
    end

    if self.IsCapturingMouse then
        if Mouse.IsDown() == false then
            self.IsCapturingMouse = false
        else
            self.ValueX = Numeric.Remap(Numeric.Clamp(self.X - Mouse.X, -self.Width, 0), 0, -self.Width, -128, 127)
            self.ValueY = Numeric.Remap(Numeric.Clamp(self.Y - Mouse.Y, -self.Height, 0), 0, -self.Height, -127, 128)

            self.ValueChangedCallback(self)
        end
    end

    if Mouse.IsDown() and Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        self.IsCapturingMouse = true
    end

end

function Joystick:Draw()

    WGUI.FillRectangle(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, self.X - BORDER_SIZE + 1,
        self.Y - BORDER_SIZE + 1, self.Width + self.X + BORDER_SIZE - 2, self.Height + self.Y + BORDER_SIZE - 2)

    WGUI.FillRectangle(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR, self.X + 1, self.Y + 1,
        self.Width + self.X - 2, self.Height + self.Y - 2)

    WGUI.FillEllipse(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR, self.X, self.Y, self.Width - 1,
        self.Height - 1)
    WGUI.DrawEllipse(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1, self.X, self.Y, self.Width - 1,
        self.Height - 1)

    local cX = Numeric.Remap(self.ValueX, -128, 127, self.X, self.X + self.Width)
    local cY = Numeric.Remap(self.ValueY, -127, 128, self.Y, self.Y + self.Height)

    WGUI.DrawLine(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1,
    self.X,
    self.Y + self.Height / 2 - 1, 
    self.X + self.Width - 2, 
    self.Y + self.Height / 2 - 1)

    WGUI.DrawLine(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, 1,
    self.X + self.Width / 2 - 1,
    self.Y, 
    self.X + self.Width / 2 - 1, 
    self.Y + self.Height - 2)

    WGUI.DrawLine(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_LINE_COLOR, 1, self.X + self.Width / 2 - 1,
        self.Y + self.Height / 2 - 1, cX - 1, cY)

    WGUI.FillEllipse(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_COLOR,
        cX - Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE / 2,
        cY - Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE / 2 + 1, 
        Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE - 1, 
        Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE - 1)

end
