ComboBox = middleclass('ComboBox', Control)

function ComboBox:initialize(x, y, w, h, items, onSelectedItemChangedCallback)
    Control.initialize(self, x, y, w, h)

    self.Items = items -- Must be of type "string" :)
    self.SelectedItemIndex = 1
    self.ItemHeight = 20

    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR

    self.RightChevronX = self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronY = self.Y
    self.RightChevronWidth = Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronHeight = self.Height

    self.IsOpened = false

    self.TargetDropDownHeight = 0
    self.CurrentDropDownHeight = self.TargetDropDownHeight

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback
end

function ComboBox:PersistentUpdate()
    self.CurrentBackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentBackColor),
        WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
end

function ComboBox:SetOpen(isOpen)
    self.IsOpened = isOpen
    self.TargetDropDownHeight = self.IsOpened and self.ItemHeight * #self.Items or -self.ItemHeight
end

function ComboBox:Update()
    self.CurrentDropDownHeight =
        Numeric.TemporalInterpolateNumber(self.CurrentDropDownHeight, self.TargetDropDownHeight)

        if Mouse.ClickedInside(self.RightChevronX, self.RightChevronY, self.RightChevronWidth, self.RightChevronHeight) then
            self.SetOpen(self, not self.IsOpened)
            self.OnSelectedItemChangedCallback(self)
        end
    
    if self.CurrentDropDownHeight > self.TargetDropDownHeight / 2 and self.IsOpened then
        local baseY = self.Y - self.ItemHeight * #self.Items + self.ItemHeight / 2 + self.CurrentDropDownHeight
                for i = 1, #self.Items, 1 do
                    local thisY = baseY + (i * self.ItemHeight)
                    if Mouse.ClickedInside(self.X - BORDER_SIZE, 
                thisY, self.Width + BORDER_SIZE + 1, self.ItemHeight) then
                    self.SelectedItemIndex = i
                    self.OnSelectedItemChangedCallback(self)
                end
        end
        
    end
end

function ComboBox:Draw()

    if self.CurrentDropDownHeight > 0 then

        WGUI.FillRectangleBounds(self.CurrentBackColor, self.X, self.Y + self.Height, self.Width, self.CurrentDropDownHeight + self.ItemHeight / 2)

        local baseY = self.Y - self.ItemHeight * #self.Items + self.ItemHeight / 2 + self.CurrentDropDownHeight

        for i = 1, #self.Items, 1 do

            local thisY = baseY + (i * self.ItemHeight)

            if thisY > self.Y + self.Height - self.ItemHeight then

                WGUI.DrawRectangleBounds(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, BORDER_SIZE,
                self.X - BORDER_SIZE, 
                thisY, self.Width + BORDER_SIZE + 1, self.ItemHeight)


                WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, 
            self.Items[i], 
            self.X + 3, 
            thisY)
            end
            

            --WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Items[i], self.X - BORDER_SIZE, self.Y + self.Height - BORDER_SIZE + (i * (20 + BORDER_SIZE)))
        end
    end

    WGUI.FillRectangle(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR, self.X - BORDER_SIZE,
        self.Y - BORDER_SIZE, self.Width + self.X + BORDER_SIZE, self.Height + self.Y + BORDER_SIZE)
    WGUI.FillRectangle(self.CurrentBackColor, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, "v", self.X + self.Width -
        Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4, self.Y + 2)
    WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Items[self.SelectedItemIndex],
        self.X + self.Width / 2 - FONT_SIZE / 3 * self.Items[self.SelectedItemIndex]:len(),
        self.Y + self.Height / 2 - 6.5, self.Y + self.Height / 2 - 6.5)


    

end
