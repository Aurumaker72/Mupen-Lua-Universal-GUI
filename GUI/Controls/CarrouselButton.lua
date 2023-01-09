CarrouselButton = middleclass('CarrouselButton', Button)

function CarrouselButton:initialize(containingScene, index, x, y, w, h, items, wrapAround, onSelectedItemChangedCallback)
    h = math.min(h, 20) -- limit height to 20
    Button.initialize(self, containingScene, index, nil, x, y, w, h, items[0], onSelectedItemChangedCallback, nil)

    self.Items = items -- Must be of type "string" :)
    self.SelectedItemIndex = 1

    self.WrapAround = wrapAround

    self.OnSelectedItemChangedCallback = onSelectedItemChangedCallback

    self.LeftChevronX = AnimatedNumber:new(self:GetBaseLeftChevronX())
    self.RightChevronX = AnimatedNumber:new(self:GetBaseRightChevronX())
    self.LeftChevronX.Epsilon = 0
    self.RightChevronX.Epsilon = 0
    self.LeftChevronX.Speed = 0.25
    self.RightChevronX.Speed = 0.25
end

function CarrouselButton:GetInteractionKeys()
    return { "left", "right" }
end

function CarrouselButton:GetBaseLeftChevronX()
    return self.X - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE +
        Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_MARGIN
end

function CarrouselButton:GetBaseRightChevronX()
    return self.X + self.Width - Appearance.Themes[Appearance.CurrentTheme].CARROUSEL_BUTTON_CHEVRON_MARGIN
end

function CarrouselButton:Update()
    self.LeftChevronX:Update()
    self.RightChevronX:Update()
end

function CarrouselButton:Draw()

    CurrentStyler:DrawButton(self)

    CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor), "<",
        self.LeftChevronX.CurrentNumber, self.Y + 1)
    CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor), ">",
        self.RightChevronX.CurrentNumber, self.Y + 1)

    CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor),
        self.Items[self.SelectedItemIndex],
        self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 *
        self.Items[self.SelectedItemIndex]:len(), self.Y + self.Height / 2 - 6.5, self.Y + self.Height / 2 - 6.5)

end

function CarrouselButton:CanBeInteracted(e)
    return e.Source == InteractionEvent.KeyboardSource and Mouse.IsInside(self.X, self.Y, self.Width, self.Height)
end

function CarrouselButton:OnPrimaryInteracted(e)
    if e.Key == "left" then
        self:AdvanceIndexBy(-1)
    end
    if e.Key == "right" then
        self:AdvanceIndexBy(1)
    end
end

function CarrouselButton:AdvanceIndexBy(i)
    if self.WrapAround then
        self.SelectedItemIndex = Numeric.WrappingClamp(self.SelectedItemIndex + i, 1, #self.Items)
    else
        self.SelectedItemIndex = math.max(self.SelectedItemIndex + i, 1)
    end
    self.ContainingScene:AddQueuedCallback(self.OnSelectedItemChangedCallback, self)
end

function CarrouselButton:OnMouseEnter(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
end

function CarrouselButton:OnMouseLeave(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
end

function CarrouselButton:OnMouseDown(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))

    if MouseEvent.IsInside(e, self.X, self.Y, self.Width / 2, self.Height) then
        self:AdvanceIndexBy(1)
    end
    if MouseEvent.IsInside(e, self.X + self.Width / 2, self.Y, self.Width / 2, self.Height) then
        self:AdvanceIndexBy(-1)
    end
end

function CarrouselButton:OnMouseLeave(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.LeftChevronX:SetTargetNumber(self:GetBaseLeftChevronX())
    self.RightChevronX:SetTargetNumber(self:GetBaseRightChevronX())
end

function CarrouselButton:OnMouseMove(e)

    if MouseEvent.IsInside(e, self.X, self.Y, self.Width / 2, self.Height) then
        self.LeftChevronX:SetTargetNumber(self:GetBaseLeftChevronX() - 10)
    else
        self.LeftChevronX:SetTargetNumber(self:GetBaseLeftChevronX())
    end

    if MouseEvent.IsInside(e, self.X + self.Width / 2, self.Y, self.Width / 2, self.Height) then
        self.RightChevronX:SetTargetNumber(self:GetBaseRightChevronX() + 10)
    else
        self.RightChevronX:SetTargetNumber(self:GetBaseRightChevronX())
    end

end
