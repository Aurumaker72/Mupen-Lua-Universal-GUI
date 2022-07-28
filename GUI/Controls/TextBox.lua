TextBox = middleclass('TextBox', Control)

function TextBox:initialize(containingScene, x, y, w, h, maxLength, isReadOnly, isNumericOnly, textChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
    self.MaxLength = maxLength and maxLength or 100
    self.TextChangedCallback = textChangedCallback
    self.IsReadOnly = isReadOnly
    self.IsNumericOnly = isNumericOnly
    self.Active = false
    self.Text = ""
    self.CaretPosition = 1
    self.CaretTimer = 0
    self:SetCaretPosition(self.MaxLength)

    self.TargetBackColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    self.CurrentBackColor = self.TargetBackColor
    self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR
    self.CurrentBorderColor = self.TargetBorderColor
    self.TargetCaretColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    self.CurrentCaretColor = self.TargetCaretColor
    self.CurrentCaretX = self:ComputeIntendedCaretPosition()
end

function TextBox:SetCaretPosition(targetPosition)
    self.CaretPosition = Numeric.Clamp(targetPosition, 1, math.min(self.MaxLength, self.Text:len()))
end

function TextBox:ComputeIntendedCaretPosition()
    return self.X + (6.4 * Numeric.Clamp(self.CaretPosition, 0, self.Text:len())) - 3
end

function TextBox:NotifyTextChanged()
    if self.TextChangedCallback then
        self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.TextChangedCallback, self)
    end
end

function TextBox:Update()

    self.CaretTimer = self.CaretTimer + 1

    if self.Active then
        if self.CaretTimer % 100 == 50 then
            self.TargetCaretColor = self.IsReadOnly and
                                        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_FORE_COLOR or
                                        Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
        end
        if self.CaretTimer % 100 == 1 then
            self.TargetCaretColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
        end
    else
        self.TargetCaretColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    end

    self.CurrentCaretColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentCaretColor),
        CurrentRenderer:HexadecimalColorToRGB(self.TargetCaretColor))
    self.CurrentCaretX = Numeric.TemporalInterpolateNumberWithSpeed(0.6, self.CurrentCaretX,
        self:ComputeIntendedCaretPosition())

    if (Mouse.IsPrimaryClicked()) then
        self.Active = Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width, self.Height)
    end

    if self.Active and self.IsReadOnly == false then

        if self.IsNumericOnly then
            for i = 0, 9, 1 do
                if Keyboard.Input[tostring(i)] and not Keyboard.LastInput[tostring(i)] and self.CanTypeCharacter(self) then
                    self.Text = String.InsertAt(self.Text, tostring(i), self.CaretPosition)
                    self:SetCaretPosition(self.CaretPosition + 1)
                    self:NotifyTextChanged()
                end
            end
            if Keyboard.KeyPressed("up") then
                self.Text = tostring(tonumber(self.Text) + 1 * (Keyboard.KeyHeld("control") and 5 or 1))
                self:NotifyTextChanged()
            end
            if Keyboard.KeyPressed("down") then
                self.Text = tostring(tonumber(self.Text) - 1 * (Keyboard.KeyHeld("control") and 5 or 1))
                self:NotifyTextChanged()
            end
        else
            for key, v in pairs(Keyboard.Input) do
                if Keyboard.Input[key] and not Keyboard.LastInput[key] then
                    if key:len() == 1 and self.CanTypeCharacter(self) then
                        self.Text = String.InsertAt(self.Text, tostring(key), self.CaretPosition)
                        self:SetCaretPosition(self.CaretPosition + 1)
                        self:NotifyTextChanged()
                    end
                end
            end
        end

        if (Keyboard.KeyPressed("backspace")) then
            if self.Text:len() > 0 then
                if Keyboard.KeyHeld("control") then
                    self.Text = ""
                else
                    self.Text = String.RemoveAt(self.Text, self.CaretPosition)
                end
                self:SetCaretPosition(self.CaretPosition - 1)
                self:NotifyTextChanged()
            end
        end

        if Keyboard.KeyPressed("left") then
            self:SetCaretPosition(self.CaretPosition - 1)
        end

        if Keyboard.KeyPressed("right") then
            self:SetCaretPosition(self.CaretPosition + 1)
        end

    end

    if self.Active and self.IsReadOnly == false then

        if Keyboard.KeyHeld("control") and Keyboard.KeyPressed("C") then
            ClipboardManager.Copy(tostring(self.Text))
        end

        if Keyboard.KeyHeld("control") and Keyboard.KeyPressed("V") then
            local canTryPaste = false

            if self.IsNumericOnly then
                if Numeric.IsNumeric(ClipboardManager.ClipboardBuffer) then
                    canTryPaste = true
                end
            else
                canTryPaste = true
            end

            if canTryPaste then
                if ClipboardManager.ClipboardBuffer:len() > self.MaxLength then
                    ClipboardManager.Copy(ClipboardManager.ClipboardBuffer:sub(1, self.MaxLength))
                end
                self.Text = ClipboardManager.Paste(self.Text)
                self:NotifyTextChanged()
            else
                print("Can\'t paste this")
            end
        end
    end

end

function TextBox:PersistentUpdate()
    self.TargetBackColor = self.IsReadOnly and Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_BACK_COLOR or
                               Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR

    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_HOVERED_BORDER_COLOR
    end
    if self.Active then
        self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_ACTIVE_BORDER_COLOR
    end
    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBackColor),
        CurrentRenderer:HexadecimalColorToRGB(self.TargetBackColor))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentBorderColor),
        CurrentRenderer:HexadecimalColorToRGB(self.TargetBorderColor))

end

function TextBox:CanTypeCharacter()
    return (self.Text:len() * Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE < self.Width) and
               (self.Text:len() + 1 <= self.MaxLength)
end

function TextBox:Draw()

    RendererHelper.DrawBorderedRectangle(self.CurrentBackColor, self.CurrentBorderColor,
        Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    CurrentRenderer:DrawText(
        self.IsReadOnly and Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_FORE_COLOR or
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + 2, self.Y + 2)

    if self.Text:len() > 0 and self.IsReadOnly == false then
        CurrentRenderer:FillRectangle(self.CurrentCaretColor, self.CurrentCaretX, self.Y + self.Height - 5, 6, 1)
    end
end
