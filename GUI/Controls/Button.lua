Button = middleclass('Button', Control)

function Button:initialize(containingScene, index, clickKey, x, y, w, h, text, primaryMouseClickCallback,
    secondaryMouseClickCallback)
    Control.initialize(self, containingScene, index, x, y, w, h, primaryMouseClickCallback, secondaryMouseClickCallback)
    self.Text = text
    self.ClickKey = clickKey
    self.BackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.BorderColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    self.ForeColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
end

function Button:GetInteractionKeys()
    return {self.ClickKey}
end

function Button:PersistentUpdate()
    self.BackColor:Update()
    self.BorderColor:Update()
    self.ForeColor:Update()
end

function Button:HandleGenericThemeChange(e)
    if self.ContainingScene.IsActive then
        self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
        self.ForeColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
        return true
    else
        self.BackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
        self.BorderColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
        self.ForeColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR))
        return false
    end
end

function Button:OnThemeChanged(e)
    self:HandleGenericThemeChange(e)
end

function Button:Update()
end

function Button:ShouldBePushed()
    return (Mouse.IsInside(self.X, self.Y, self.Width, self.Height) and Mouse.IsPrimaryDown()) or
               Keyboard.KeyHeld(self.ClickKey)
end

function Button:Draw()

    CurrentStyler:DrawRaisedFrame(self, CurrentRenderer:RGBToHexadecimalColor(self.BackColor.CurrentColor),
        CurrentRenderer:RGBToHexadecimalColor(self.BorderColor.CurrentColor),
        Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    if (self.Text) then
        CurrentRenderer:DrawText(CurrentRenderer:RGBToHexadecimalColor(self.ForeColor.CurrentColor), self.Text,
            self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 * self.Text:len(),
            self.Y + self.Height / 2 - 7.5)
    end

end

function Button:OnPrimaryInteracted(e)
    self.ContainingScene:AddQueuedCallback(self.PrimaryMouseClickCallback, self)
end

function Button:OnInteractionBegin(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
end

function Button:OnInteractionEnd(e)
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

function Button:OnMouseEnter(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
end

function Button:OnMouseLeave(e)
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
end
