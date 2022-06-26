TextBox = middleclass('TextBox', Control)

function TextBox:initialize(containingScene, x, y, w, h, maxLength, isReadOnly, numericOnly, textChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
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
end

function TextBox:Update()

    if (Mouse.IsPrimaryClicked()) then
        self.Active = Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width, self.Height)
    end

    if self.Active and self.IsReadOnly == false then

        if self.NumericOnly then
            for i = 0, 9, 1 do
                if Keyboard.Input[tostring(i)] and not Keyboard.LastInput[tostring(i)] and self.CanTypeCharacter(self) then
                    self.Text = self.Text .. tostring(i)
                    if self.TextChangedCallback then
                        self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.TextChangedCallback, self)
                    end
                end
            end
        else
            for key, v in pairs(Keyboard.Input) do
                if Keyboard.Input[key] and not Keyboard.LastInput[key] then
                    if key:len() == 1 and self.CanTypeCharacter(self) then
                        self.Text = self.Text .. key
                        if self.TextChangedCallback then
                            self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.TextChangedCallback, self)
                        end
                    end
                end
            end
        end

        if (Keyboard.KeyPressed("backspace")) then
            if self.Text:len() > 0 then
                self.Text = self.Text:sub(1, -2)
                if self.TextChangedCallback then
                    self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.TextChangedCallback, self)
                end
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
    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentBackColor),
        Color.HexadecimalColorToRGB(self.TargetBackColor))
    self.CurrentBorderColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentBorderColor),
        Color.HexadecimalColorToRGB(self.TargetBorderColor))
end

function TextBox:CanTypeCharacter()
    if type(self.Text) == "string" == false then
        print("TextBox text was set to string")
        return false
    end
    return (self.Text:len() * Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE < self.Width) and
               (self.Text:len() + 1 <= self.MaxLength)
end

function TextBox:Draw()

    CurrentRenderer:FillRectangle(self.CurrentBorderColor,
        self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Width + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2,
        self.Height + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2)
    CurrentRenderer:FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width, self.Height)

    CurrentRenderer:DrawText(
        self.IsReadOnly and Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_FORE_COLOR or
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + 2, self.Y + 2)
end
