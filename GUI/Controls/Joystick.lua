Joystick = middleclass('Joystick', Control)

function Joystick:initialize(containingScene, x, y, w, h, readOnly, valueChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
    self.ValueChangedCallback = valueChangedCallback
    self.ValueX = 0
    self.ValueY = 0
    self.Magnitude = nil
    self.IsReadOnly = readOnly

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR
    self.CurrentSecondaryBackColor = Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR
end

function Joystick:Update()
    if self.IsReadOnly == false then

        if self.IsCapturingMouse then
            if Mouse.IsDown() == false then
                self.IsCapturingMouse = false
            else
                self.ValueX = Numeric.Remap(Numeric.Clamp(self.X - Mouse.X, -self.Width, 0), 0, -self.Width, -128, 127)
                self.ValueY =
                    Numeric.Remap(Numeric.Clamp(self.Y - Mouse.Y, -self.Height, 0), 0, -self.Height, -127, 128)

                self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.ValueChangedCallback, self)

            end
        end

        if Mouse.IsDown() and Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
            self.IsCapturingMouse = true
        end
    end

end

function Joystick:PersistentUpdate()
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor),
        WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.CurrentBorderColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBorderColor),
        WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.CurrentSecondaryBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(
        self.CurrentSecondaryBackColor), WGUI.HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
end

function Joystick:Draw()

    

    WGUI.FillRectangle(self.CurrentBorderColor, self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE + 1, self.Y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE + 1,
        self.Width + self.X + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE - 2, self.Height + self.Y + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE - 2)

    WGUI.FillRectangle(self.CurrentBackColor, self.X + 1, self.Y + 1, self.Width + self.X - 2, self.Height + self.Y - 2)

    WGUI.FillEllipse(self.CurrentSecondaryBackColor, self.X, self.Y, self.Width - 1, self.Height - 1)
    WGUI.DrawEllipse(self.CurrentBorderColor, 1, self.X, self.Y, self.Width - 1, self.Height - 1)

    if self.Magnitude and self.Magnitude == 0 == false then
        wgui.setbrush(self.CurrentSecondaryBackColor)
        local clampedMagnitude = Numeric.Clamp(self.Magnitude, 0, math.max(self.Width, self.Height))
        WGUI.DrawEllipse(self.CurrentBorderColor,
        1,
        self.X + self.Width / 2 - clampedMagnitude / 2,
        self.Y + self.Height / 2- clampedMagnitude / 2,
        clampedMagnitude,
        clampedMagnitude)
    end
    
    WGUI.DrawLine(self.CurrentBorderColor, 1, self.X, self.Y + self.Height / 2 - 1, self.X + self.Width - 1,
        self.Y + self.Height / 2 - 1)

    WGUI.DrawLine(self.CurrentBorderColor, 1, self.X + self.Width / 2 - 1, self.Y, self.X + self.Width / 2 - 1,
        self.Y + self.Height - 2)

    local cX = Numeric.Remap(self.ValueX, -128, 127, self.X, self.X + self.Width)
    local cY = Numeric.Remap(self.ValueY, -127, 128, self.Y, self.Y + self.Height)

    WGUI.DrawLine(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_LINE_COLOR, 1, self.X + self.Width / 2 - 1,
        self.Y + self.Height / 2 - 1, cX - 1, cY)
    
        

    WGUI.FillEllipse(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_COLOR,
        cX - Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE / 2,
        cY - Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE / 2 + 1,
        Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE - 1,
        Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE - 1) -- idk what the fuck is going on here
    -- ellipse draw routine in gdi side is exhibiting small pixel precision issues

    
end

