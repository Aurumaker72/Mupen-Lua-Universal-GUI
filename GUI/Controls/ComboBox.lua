ComboBox = middleclass('ComboBox', Button)

function ComboBox:initialize(containingScene, index, x, y, w, h, items, onSelectedItemChangedCallback)
    Button.initialize(self, containingScene, index, nil, x, y, w, h, nil, onSelectedItemChangedCallback, nil)

    self.Items = items -- Must be of type "string" :)

    self.SelectedItemIndex = 1
    self.ItemHeight = 20
    self.IsOpened = false

    self.BackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.ForeColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
    self.ItemBackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
    self.SelectedItemBackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    self.DropdownHeight = AnimatedNumber:new(0)
    self.DropdownHeight.Epsilon = 5

    self.ItemSelectorY = AnimatedNumber:new(self:GetYForIndex(1))
    self.ItemSelectorY.Epsilon = self.ItemHeight / 5
    self.ItemSelectorY.Speed = 0.5

    self.CurrentRightChevronY = self.Y
    self.TargetRightChevronY = self.CurrentRightChevronY

    self.RightChevronWidth = Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH
    self.RightChevronHeight = self.Height
    self.RightChevronText = self.IsOpened and "^" or "v"

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback
end

function ComboBox:GetBounds()
    return {
        X = self.X,
        Y = self.Y,
        Width = self.Width,
        Height = self.IsOpened and self.Height + self.DropdownHeight.CurrentNumber + self.ItemHeight / 2 or self.Height
    }
end

function ComboBox:OnMouseDown(e)
    if MouseEvent.IsInside(e, self.X, self.Y, self.Width, self.Height) then
        self:SetOpen(not self.IsOpened)
    else
        if self.DropdownHeight.CurrentNumber > self.ItemHeight then
            for i = 1, #self.Items, 1 do
                local thisY = self:GetYForIndex(i)
                if thisY > self.Y + self.Height - self.ItemHeight then
                    if MouseEvent.IsInside(e, self.X, thisY, self.Width, self.ItemHeight) then
                        self:SetSelectedIndex(i)
                    end
                end
            end
        end
    end
end

function ComboBox:OnMouseMove(e)

end

function ComboBox:PersistentUpdate()
    self.BackColor:Update()
    self.BorderColor:Update()
    self.ForeColor:Update()
    self.ItemBackColor:Update()
    self.SelectedItemBackColor:Update()
    self.DropdownHeight:Update()
    -- if not self.DropdownHeight:HasFinished() then
    --     self.ItemSelectorY:SetNumberImmediately(self:GetYForIndex(self.SelectedItemIndex))
    -- end
    self.ItemSelectorY:SetTargetNumber(self:GetYForIndex(self.SelectedItemIndex)) -- TODO: improve this shit

    self.ItemSelectorY:Update()
end

function ComboBox:GetOpenComboBoxes()
    -- TODO: refactor to O(1) using dict cache
    local t = {}
    for key, control in pairs(self.ContainingScene.Controls) do
        if control:isInstanceOf(ComboBox) and control.IsOpened and control == self == false then
            t[#t + 1] = control
        end
    end
    return t
end

function ComboBox:SetOpen(isOpen)
    local openComboBoxes = self:GetOpenComboBoxes()
    if #openComboBoxes > 0 then
        -- for i = 1, #openComboBoxes, 1 do
        --     openComboBoxes[i]:SetOpen(false)
        -- end
        return
    end
    self.IsOpened = isOpen
    self.DropdownHeight:SetTargetNumber(self.IsOpened and (#self.Items * self.ItemHeight) - self.ItemHeight / 2 or
        -self.ItemHeight)
    self.RightChevronText = self.IsOpened and "^" or "v"
end

function ComboBox:OnThemeChanged(e)
    if self.ContainingScene.IsActive then
        self.ItemBackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
        self.SelectedItemBackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    else
        self.ItemBackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BACK_COLOR))
        self.SelectedItemBackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    end

    self:HandleGenericThemeChange(e)
end

function ComboBox:SetSelectedIndex(index)
    self.SelectedItemIndex = Numeric.WrappingClamp(index, 1, #self.Items)
    self.ContainingScene:AddQueuedCallback(self.OnSelectedItemChangedCallback, self)
end

function ComboBox:GetBaseY()
    return self.Y - self.ItemHeight * (#self.Items) + self.DropdownHeight.CurrentNumber + self.ItemHeight / 2
end

function ComboBox:GetYForIndex(i)
    return self:GetBaseY() + (i * self.ItemHeight) -- what
end

function ComboBox:LateDraw()
    if self.DropdownHeight.CurrentNumber > 1 then

        CurrentStyler:DrawBorder(self.BorderColor.CurrentColor, self.X, self.Y, self.Width,
            self.DropdownHeight.CurrentNumber + self.ItemHeight / 2 + self.ItemHeight)

        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(self.ItemBackColor.CurrentColor), self.X,
            self.Y, self.Width, self.DropdownHeight.CurrentNumber + self.ItemHeight / 2 + self.ItemHeight)

        if self.ItemSelectorY.CurrentNumber >= self.Y then
            CurrentRenderer:FillRectangle(
                CurrentRenderer:RGBToHexadecimalColor(self.SelectedItemBackColor.CurrentColor), self.X,
                self.ItemSelectorY.CurrentNumber, self.Width, self.ItemHeight)
        end

        for i = 1, #self.Items, 1 do

            local thisY = self:GetYForIndex(i)

            if thisY > self.Y + self.Height - self.ItemHeight then

                CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor),
                    self.Items[i], self.X + 3, thisY + 2)

            end
        end
        self:Draw()
    end

end

function ComboBox:Draw()

    CurrentStyler:DrawButton(self)

    CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor), self.RightChevronText,
        self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_WIDTH / 2 - 4,
        self.CurrentRightChevronY)

    CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor),
        self.Items[self.SelectedItemIndex], self.X + 3, self.Y + 2)
end

function ComboBox:GetInteractionKeys()
    return { "enter", "up", "down" }
end

function ComboBox:CanBeInteracted(e)
    return e.Source == InteractionEvent.KeyboardSource and Mouse.IsInside(self.X, self.Y, self.Width, self.Height)
end

function ComboBox:OnPrimaryInteracted(e)
    if e.Key == "enter" then
        self:SetOpen(not self.IsOpened)
    end
    if e.Key == "up" then
        self:SetSelectedIndex(self.SelectedItemIndex - 1)
    end
    if e.Key == "down" then
        self:SetSelectedIndex(self.SelectedItemIndex + 1)
    end

end

function ComboBox:OnInteractionBegin(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
end

function ComboBox:OnInteractionEnd(e)
    if e.Source == InteractionEvent.MouseSource then
        self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BACK_COLOR))
        self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
    elseif e.Source == InteractionEvent.KeyboardSource then
        self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    end

end

function ComboBox:OnMouseEnter(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
end

function ComboBox:OnMouseLeave(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
end
