TextBox = middleclass('TextBox', Control)

function TextBox:initialize(containingScene, index, x, y, w, h, maxLength, isReadOnly, isNumericOnly,
    textChangedCallback)
    Control.initialize(self, containingScene, index, x, y, w, h, nil, nil)
    self.MaxLength = maxLength and maxLength or 100
    self.TextChangedCallback = textChangedCallback

    self.IsNumericOnly = isNumericOnly
    self.Text = ""
    self.CaretTimer = 0

    self.BackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
    self.BorderColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR))
    self.ForeColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    self.CaretColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
    
    self.CaretX = AnimatedNumber:new(self.X)
    self.CaretX.Speed = 0.5

    self:SetCaretIndex(1)

    self:SetReadOnly(isReadOnly)
    self:SetActive(false)
end

function TextBox:SetText(text)
    self.Text = text
    if self.TextChangedCallback then
        self.ContainingScene:AddQueuedCallback(self.TextChangedCallback, self)
    end
end

function TextBox:SetReadOnly(isReadOnly)
    self.IsReadOnly = isReadOnly
    if self.IsReadOnly then
        self.BackColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_BACK_COLOR))
        self.ForeColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_FORE_COLOR))
    else
        self.BackColor:UnlockOverride()
        self.ForeColor:UnlockOverride()
        self.BackColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
        self.ForeColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    end
end

function TextBox:SetActive(isActive)
    self.IsActive = isActive

    if self.IsActive then
        self.BorderColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_ACTIVE_BORDER_COLOR))
    else
        self.BorderColor:UnlockOverride()
        self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR))
    end
end

function TextBox:SetCaretIndex(i)
    self.CaretIndex = Numeric.Clamp(i, 1, math.min(self.MaxLength, self.Text:len()))
    self.CaretX:SetTargetNumber(self.X + (6.4 * Numeric.Clamp(self.CaretIndex, 1, self.Text:len())) - 3)
end

function TextBox:GetTextAfterIncrementingNumberAtIndex(increment, index)
    if self.Text and self.Text:len() > 1 then 
        local str = tostring(Numeric.Clamp(tonumber(String.GetCharAt(self.Text, self.CaretIndex)) + increment, 0, 9))
        return String.SetAt(self.Text, str, self.CaretIndex)
    else
       -- uhh
       return ""
    end
end

function TextBox:CanTypeCharacter()
    return (self.Text:len() * Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE < self.Width) and
               (self.Text:len() + 1 <= self.MaxLength)
end

function TextBox:IsTextEmpty()
    return self.Text == nil or self.Text:gsub('%s', ''):len() == 0
end

function TextBox:OnThemeChanged(e)
    self.CaretX.Epsilon = Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 4
    if self.ContainingScene.IsActive then
        self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
        self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR))
        self.ForeColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    else
        self.BackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
        self.BorderColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR))
        self.ForeColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    end
    self:SetActive(self.IsActive)
    self:SetReadOnly(self.IsReadOnly)
end

function TextBox:OnMouseDown(e)
    if self.IsReadOnly == false then
        if self.IsCapturingMouse and MouseEvent.IsInside(e, self.X, self.Y, self.Width, self.Height) == false then
            self.IsCapturingMouse = false
            self.IsCapturingKeyboard = false
            self:SetActive(false)
            return
        end
        self.IsCapturingMouse = true
        self.IsCapturingKeyboard = true
        self:SetActive(true)
    end
end

function TextBox:OnMouseEnter(e)
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_HOVERED_BORDER_COLOR))
end

function TextBox:OnMouseLeave(e)
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR))
end

function TextBox:OnKeyDown(e)

    if e.Key == "backspace" then
        if not self:IsTextEmpty() then
            if Keyboard.KeyHeld("control") then
                self:SetText("")
            else
                self:SetText(String.RemoveAt(self.Text, self.CaretIndex))
            end
            self:SetCaretIndex(self.Text:len())
        end
        return
    end

    if e.Key == "left" then
        self:SetCaretIndex(self.CaretIndex - 1)
        return
    end
    if e.Key == "right" then
        self:SetCaretIndex(self.CaretIndex + 1)
        return
    end

    if self.IsNumericOnly then
        if e.Key == "up" then
            self:SetText(self:GetTextAfterIncrementingNumberAtIndex(1, self.CaretIndex))
            return
        end
        if e.Key == "down" then
            self:SetText(self:GetTextAfterIncrementingNumberAtIndex(-1, self.CaretIndex))
            return
        end
    end

    if Keyboard.KeyHeld("control") and e.Key == "C" then
        ClipboardManager.Copy(tostring(self.Text))
    end

    if Keyboard.KeyHeld("control") and e.Key == "V" then
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
            self:SetText(ClipboardManager.Paste(self.Text))
        else
            print("Can\'t paste this")
        end
    end

    if self:CanTypeCharacter() == false then
        return
    end

    local appendedText = nil

    if self.IsNumericOnly then
        if Keyboard.IsNumeric(e.Key) then
            appendedText = tostring(tonumber(e.Key))
        end
    else
        if Keyboard.IsAlphanumericKey(e.Key) then 
            appendedText = tostring(e.Key)
        end
    end

    if appendedText then
        self:SetText(String.InsertAt(self.Text, appendedText, self.CaretIndex))
        self:SetCaretIndex(self.CaretIndex + 1)
    else
        -- bad key
    end
end



function TextBox:Update()

    self.CaretTimer = self.CaretTimer + 1

    if self.IsActive then
        if self.CaretTimer % 100 == 50 then
            self.CaretColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(self.IsReadOnly and
                                                                                     Appearance.Themes[Appearance.CurrentTheme]
                                                                                         .TEXTBOX_READONLY_FORE_COLOR or
                                                                                     Appearance.Themes[Appearance.CurrentTheme]
                                                                                         .BUTTON_FORE_COLOR))
        end
        if self.CaretTimer % 100 == 1 then
            self.CaretColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
                Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
        end
    else
        self.CaretColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
    end
end

function TextBox:PersistentUpdate()
    self.BackColor:Update()
    self.BorderColor:Update()
    self.ForeColor:Update()
    self.CaretColor:Update()
    self.CaretX:Update()
end

function TextBox:Draw()

    CurrentStyler:DrawRaisedFrame(self, CurrentRenderer:RGBToHexadecimalColor(self.BackColor.CurrentColor),
        CurrentRenderer:RGBToHexadecimalColor(self.BorderColor.CurrentColor),
        Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor), self.Text, self.X + 2,
        self.Y + 2)
    if self.Text:len() > 0 and self.IsReadOnly == false then
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(self.CaretColor.CurrentColor),
            self.CaretX.CurrentNumber, self.Y + self.Height - 5, 6, 1)
    end

end
