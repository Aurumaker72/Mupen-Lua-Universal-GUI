TextBox = middleclass('TextBox', Control)

function TextBox:initialize(x, y, w, h, maxLength, isReadOnly, numericOnly, textChangedCallback)
    Control.initialize(self, x, y, w, h)
    self.MaxLength = maxLength and maxLength or 10
    self.TextChangedCallback = textChangedCallback
    self.Text = ""
    self.Active = false
    self.IsReadOnly = isReadOnly
    self.NumericOnly = numericOnly
    self.TargetBackColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    self.CurrentBackColor = self.TargetBackColor
    self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR
    self.CurrentBorderColor = self.TargetBorderColor
    if self.Height == 20 == false then
        print("violation: TextBox has an inappropriate height")
    end
end

function TextBox:Update()

    if (Mouse.IsClicked()) then
        self.Active = Mouse.ClickedInside(self.X, self.Y, self.Width, self.Height)
    end

    if self.Active and self.IsReadOnly == false then

        if self.NumericOnly then
            for i = 0, 9, 1 do
                if Keyboard.Input[tostring(i)] and not Keyboard.LastInput[tostring(i)] and self.CanTypeCharacter(self) then
                               self.Text = self.Text .. tostring(i)
                               if self.TextChangedCallback then
                                self.TextChangedCallback(self)
                               end
                end
            end
        else
            for key, v in pairs(Keyboard.Input) do
                if Keyboard.Input[key] and not Keyboard.LastInput[key] then
                if key:len() == 1 and self.CanTypeCharacter(self) then
                           self.Text = self.Text .. key
                           if self.TextChangedCallback then
                            self.TextChangedCallback(self)
                           end
                        end
                    end
                end
        end

        

        if (Keyboard.KeyPressed("backspace")) then
            if self.Text:len() > 0 then
                self.Text = self.Text:sub(1, -2)
                if self.TextChangedCallback then
                    self.TextChangedCallback(self)
                end
            end
        end
    end


end

function TextBox:PersistentUpdate()
    self.TargetBackColor = self.IsReadOnly and Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_BACK_COLOR or Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR
    self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR

    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_HOVERED_BORDER_COLOR
    end
    if self.Active then
        self.TargetBorderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_ACTIVE_BORDER_COLOR
    end
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor), WGUI.HexadecimalColorToRGB(self.TargetBackColor))
    self.CurrentBorderColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBorderColor), WGUI.HexadecimalColorToRGB(self.TargetBorderColor))
end

function TextBox:CanTypeCharacter()
    if type(self.Text) == "string" == false then
        print("TextBox text was set to string")
        return false
    end
    return (self.Text:len() * FONT_SIZE < self.Width) and (self.Text:len() + 1 <= self.MaxLength)
end

function TextBox:Draw()

    WGUI.FillRectangle(self.CurrentBorderColor, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE,
        self.Height + self.Y + BORDER_SIZE)

    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + 2, self.Y + 2)
end
