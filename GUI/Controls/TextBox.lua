TextBox = middleclass('TextBox', Control)

function TextBox:initialize(x, y, w, h, maxLength, textChangedCallback)
    Control.initialize(self, x, y, w, h)
    self.MaxLength = maxLength and maxLength or 10
    self.TextChangedCallback = textChangedCallback
    self.Text = ""
    self.Active = false
    self.IsReadOnly = false
    if self.Height == 20 == false then
        print("violation: TextBox has an inappropriate height")
    end
end

function TextBox:Update()

    if (Mouse.IsClicked()) then
        self.Active = Mouse.ClickedInside(self.X, self.Y, self.Width, self.Height)
    end

    if self.Active and self.IsReadOnly == false then
        for i = 0, 9, 1 do
            if (Keyboard.KeyPressed("" .. i)) or (Keyboard.KeyPressed("numpad" .. i)) then
                if self.CanTypeCharacter(self) then
                    self.Text = self.Text .. i
                    self.TextChangedCallback(self)
                end
            end
        end

        if (Keyboard.KeyPressed("backspace")) then
            if self.Text:len() > 0 then
                self.Text = self.Text:sub(1, -2)
                self.TextChangedCallback(self)
            end
        end
    end
end

function TextBox:CanTypeCharacter()
    return (self.Text:len() * FONT_SIZE < self.Width) and (self.Text:len() + 1 <= self.MaxLength)
end

function TextBox:Draw()

    local borderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR

    if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
        borderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_HOVERED_BORDER_COLOR
    end
    if self.Active then
        borderColor = Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_ACTIVE_BORDER_COLOR
    end

    WGUI.FillRectangle(borderColor, self.X - BORDER_SIZE, self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE,
        self.Height + self.Y + BORDER_SIZE)

    local backColor = self.IsReadOnly and Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_READONLY_BACK_COLOR or Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR

    WGUI.FillRectangle(backColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X + 2, self.Y + 2)
end
