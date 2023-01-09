Joystick = middleclass('Joystick', Control)

function Joystick:initialize(containingScene, index, x, y, w, h, readOnly, valueChangedCallback)
    Control.initialize(self, containingScene, index, x, y, w, h, nil, nil)
    self.ValueChangedCallback = valueChangedCallback
    self.ValueX = 0
    self.ValueY = 0
    self.Magnitude = nil
    self.IsReadOnly = readOnly

    self.BackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.SecondaryBackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
    self.BorderColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.JoystickTipSize = AnimatedNumber:new(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE)
end

function Joystick:Update()

end

function Joystick:OnMouseDown(e)
    if self.IsReadOnly then
        -- dont allow moving and dont animate
        return
    end
    self.IsCapturingMouse = true
    self.JoystickTipSize:SetTargetNumber(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE * 2)
    self:MoveJoystickToMouse(e)
end

function Joystick:OnMouseUp(e)
    self.IsCapturingMouse = false
    self.JoystickTipSize:SetTargetNumber(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE)
end

function Joystick:OnMouseMove(e)
    self:MoveJoystickToMouse(e)
end

function Joystick:MoveJoystickToMouse(mousePositions)
    if self.IsReadOnly == false then
        if self.IsCapturingMouse then
            self.ValueX = Numeric.Remap(Numeric.Clamp(self.X - mousePositions.X, -self.Width, 0), 0, -self.Width, -128,
                127)
            self.ValueY = Numeric.Remap(Numeric.Clamp(self.Y - mousePositions.Y, -self.Height, 0), 0, -self.Height, -127
                , 128)

            self.ContainingScene:AddQueuedCallback(self.ValueChangedCallback, self)
        end
    end
end

function Joystick:PersistentUpdate()
    self.BackColor:Update()
    self.BorderColor:Update()
    self.SecondaryBackColor:Update()
    self.JoystickTipSize:Update()
end

function Joystick:OnThemeChanged(e)
    if self.ContainingScene.IsActive then
        self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.SecondaryBackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
        self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
        self.JoystickTipSize:SetTargetNumber(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE)
    else
        self.BackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.SecondaryBackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
        self.BorderColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
        self.JoystickTipSize:SetNumberImmediately(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_SIZE)
    end
end

function Joystick:Draw()

    CurrentStyler:DrawButton(self)

    CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(self.SecondaryBackColor.CurrentColor), self.X,
        self.Y, self.Width - 1, self.Height - 1)
    CurrentRenderer:DrawEllipse(CurrentRenderer:RGBToHexadecimalColor(self.BorderColor.CurrentColor), 1, self.X, self.Y,
        self.Width - 1, self.Height - 1)

    if self.Magnitude and self.Magnitude == 0 == false and self.Magnitude < 127 then
        local clampedMagnitude = Numeric.Clamp(self.Magnitude, 0, math.max(self.Width, self.Height))
        CurrentRenderer:DrawEllipse(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_COLOR, 1,
            self.X + self.Width / 2 - clampedMagnitude / 2, self.Y + self.Height / 2 - clampedMagnitude / 2,
            clampedMagnitude, clampedMagnitude)
    end

    CurrentRenderer:DrawLine(CurrentRenderer:RGBToHexadecimalColor(self.BorderColor.CurrentColor), 1, self.X,
        self.Y + self.Height / 2 - 1, self.X + self.Width - 1, self.Y + self.Height / 2 - 1)

    CurrentRenderer:DrawLine(CurrentRenderer:RGBToHexadecimalColor(self.BorderColor.CurrentColor), 1,
        self.X + self.Width / 2 - 1, self.Y, self.X + self.Width / 2 - 1, self.Y + self.Height - 2)

    local cX = Numeric.Remap(self.ValueX, -128, 127, self.X, self.X + self.Width)
    local cY = Numeric.Remap(self.ValueY, -127, 128, self.Y, self.Y + self.Height)

    CurrentRenderer:DrawLine(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_LINE_COLOR, 3,
        self.X + self.Width / 2 - 1, self.Y + self.Height / 2 - 1, cX - 1, cY)

    CurrentRenderer:FillEllipse(Appearance.Themes[Appearance.CurrentTheme].JOYSTICK_TIP_COLOR,
        cX - self.JoystickTipSize.CurrentNumber / 2, cY - self.JoystickTipSize.CurrentNumber / 2 + 1,
        self.JoystickTipSize.CurrentNumber - 1, self.JoystickTipSize.CurrentNumber - 1) -- idk what the fuck is going on here
    -- ellipse draw routine in gdi side is exhibiting small pixel precision issues
end
