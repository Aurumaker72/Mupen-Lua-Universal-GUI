ComboBox = middleclass('ComboBox', Control)

function ComboBox:initialize(containingScene, x, y, w, h, items, onSelectedItemChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)

    self.Items = items -- Must be of type "string" :)
    self.ItemCurrentBackColors = Table.Create(#self.Items, Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR)
    self.ItemCurrentBorderColors = Table.Create(#self.Items,
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR)

    self.SelectedItemIndex = 1
    self.ItemHeight = 20
    self.IsOpened = false

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR
    self.CurrentForeColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR
    self.CurrentBorderColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR

    self.RightChevronX = self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronY = self.Y
    self.RightChevronWidth = Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronHeight = self.Height
    self.RightChevronText = self.IsOpened and "^" or "v"

    self.TargetDropDownHeight = 0
    self.CurrentDropDownHeight = self.TargetDropDownHeight

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback
end

function ComboBox:PersistentUpdate()
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor),
        WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.CurrentForeColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentForeColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
        self.CurrentBorderColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBorderColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))

    for i = 1, #self.Items, 1 do
        self.ItemCurrentBackColors[i] = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(
            self.ItemCurrentBackColors[i]), WGUI.HexadecimalColorToRGB(
            self.SelectedItemIndex == i and Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR or
                Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.ItemCurrentBorderColors[i] = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(
            self.ItemCurrentBorderColors[i]), WGUI.HexadecimalColorToRGB(
            self.SelectedItemIndex == i and Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR or
                Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))

    end
end

function ComboBox:SetOpen(isOpen)
    self.IsOpened = isOpen
    self.TargetDropDownHeight = self.IsOpened and (self.ItemHeight * #self.Items) or
                                    -self.ItemHeight
    self.RightChevronText = self.IsOpened and "^" or "v"
end

function ComboBox:Update()
    self.CurrentDropDownHeight =
        Numeric.TemporalInterpolateNumber(self.CurrentDropDownHeight, self.TargetDropDownHeight)

    if Mouse.IsPrimaryClickedInside(self.X, self.Y, self.Width, self.Height) then
        self.SetOpen(self, not self.IsOpened)
        self.OnSelectedItemChangedCallback(self)
    end

    if self.CurrentDropDownHeight > self.TargetDropDownHeight / 2 and self.IsOpened then

        if Mouse.IsInside(self.X, self.Y, self.Width, self.Height + self.CurrentDropDownHeight) then
            self.PerformKeyboardNavigation(self)
        end

        local itemWasClicked = false

        local baseY = self.Y - self.ItemHeight * #self.Items + self.ItemHeight / 2 + self.CurrentDropDownHeight
        for i = 1, #self.Items, 1 do
            local thisY = baseY + (i * self.ItemHeight)
            if Mouse.IsPrimaryClickedInside(self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, thisY, self.Width + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE + 1, self.ItemHeight) then
                self.SetSelectedIndex(self, i)
                itemWasClicked = true
            end
        end

        if Mouse.IsPrimaryClicked() and Mouse.IsInside(self.X, self.Y, self.Width, self.Height + self.CurrentDropDownHeight) ==
            false and itemWasClicked == false then
            self.SetOpen(self, false)
        end

    else
        if Mouse.IsInside(self.X, self.Y, self.Width, self.Height) then
            self.PerformKeyboardNavigation(self)
        end

    end
end

function ComboBox:PerformKeyboardNavigation()
    if Keyboard.KeyPressed("down") then
        self.SetSelectedIndex(self, self.SelectedItemIndex + 1)
    end
    if Keyboard.KeyPressed("up") then
        self.SetSelectedIndex(self, self.SelectedItemIndex - 1)
    end
end

function ComboBox:SetSelectedIndex(index)
    self.SelectedItemIndex = Numeric.WrappingClamp(index, 1, #self.Items)
    self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.OnSelectedItemChangedCallback, self)
end

function ComboBox:Draw()

    if self.CurrentDropDownHeight > 0 then

        WGUI.DrawRectangleBounds(self.CurrentBorderColor, Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
            self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.Y + self.Height - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.Width + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE + 1,
            self.CurrentDropDownHeight + self.ItemHeight / 2 + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE + 1)

        local baseY = self.Y - self.ItemHeight * #self.Items + self.ItemHeight / 2 + self.CurrentDropDownHeight

        for i = 1, #self.Items, 1 do

            local thisY = baseY + (i * self.ItemHeight)

            if thisY > self.Y + self.Height - self.ItemHeight then

                WGUI.FillRectangleBounds(self.ItemCurrentBackColors[i], self.X, thisY, self.Width, self.ItemHeight)

                WGUI.DrawText(self.CurrentForeColor, self.Items[i], self.X + 3,
                    thisY + 2)

            end
        end
    end

    WGUI.FillRectangle(self.CurrentBorderColor, self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.Width + self.X + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.Height + self.Y + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE)
    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    WGUI.DrawText(self.CurrentForeColor, self.RightChevronText, self.X +
        self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4, self.Y + 2)

    WGUI.DrawText(self.CurrentForeColor, self.Items[self.SelectedItemIndex],
        self.X + 3, self.Y + 2)

end
