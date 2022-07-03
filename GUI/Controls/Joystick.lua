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
    self.TargetJoystickTipSize = Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE
    self.CurrentJoystickTipSize = self.TargetJoystickTipSize
end

function Joystick:Update()
    if self.IsReadOnly == false then

        if self.IsCapturingMouse then
            if Mouse.IsPrimaryDown() == false then
                self.IsCapturingMouse = false
                self.TargetJoystickTipSize = Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE
            else
                self.ValueX = Numeric.Remap(Numeric.Clamp(self.X - Mouse.X, -self.Width, 0), 0, -self.Width, -128, 127)
                self.ValueY =
                    Numeric.Remap(Numeric.Clamp(self.Y - Mouse.Y, -self.Height, 0), 0, -self.Height, -127, 128)

                self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.ValueChangedCallback, self)

            end
        end

        if Mouse.IsPrimaryDown() and Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
            self.IsCapturingMouse = true
            self.TargetJoystickTipSize = Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE * 2
        end
    end

end

function Joystick:PersistentUpdate()
    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(CurrentRenderer:HexadecimalColorToRGB(self.CurrentBackColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(CurrentRenderer:HexadecimalColorToRGB(self.CurrentBorderColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.CurrentSecondaryBackColor = Color.TemporalInterpolateRGBColor(CurrentRenderer:HexadecimalColorToRGB(
        self.CurrentSecondaryBackColor), CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
    self.CurrentJoystickTipSize = Numeric.TemporalInterpolateNumberWithSpeed(0.2, self.CurrentJoystickTipSize,
        self.TargetJoystickTipSize)
end

function Joystick:Draw()

    RendererHelper.DrawBorderedRectangle(self.CurrentBackColor, self.CurrentBorderColor, Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    CurrentRenderer:FillEllipse(self.CurrentSecondaryBackColor, self.X, self.Y, self.Width, self.Height)
    CurrentRenderer:DrawEllipse(self.CurrentBorderColor, 1, self.X, self.Y, self.Width, self.Height)

    if self.Magnitude and self.Magnitude == 0 == false then
        wgui.setbrush(self.CurrentSecondaryBackColor)
        local clampedMagnitude = Numeric.Clamp(self.Magnitude, 0, math.max(self.Width, self.Height))
        CurrentRenderer:DrawEllipse(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_COLOR, 1, self.X + self.Width / 2 - clampedMagnitude / 2,
            self.Y + self.Height / 2 - clampedMagnitude / 2, clampedMagnitude, clampedMagnitude)
    end

    CurrentRenderer:DrawLine(self.CurrentBorderColor, 1, self.X, self.Y + self.Height / 2, self.X + self.Width,
        self.Y + self.Height / 2)

    CurrentRenderer:DrawLine(self.CurrentBorderColor, 1, self.X + self.Width / 2, self.Y,
        self.X + self.Width / 2, self.Y + self.Height)

    local cX = Numeric.Remap(self.ValueX, -128, 127, self.X, self.X + self.Width)
    local cY = Numeric.Remap(self.ValueY, -127, 128, self.Y, self.Y + self.Height)

    CurrentRenderer:DrawLine(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_LINE_COLOR, 1,
        self.X + self.Width / 2, self.Y + self.Height / 2, cX, cY + 1)

    CurrentRenderer:FillEllipse(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_COLOR,
        cX - self.CurrentJoystickTipSize / 2 + 1, cY - self.CurrentJoystickTipSize / 2 + 2, self.CurrentJoystickTipSize - 1,
        self.CurrentJoystickTipSize - 1)

end

