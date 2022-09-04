ToggleButton = middleclass('ToggleButton', Button)

function ToggleButton:initialize(containingScene, index, clickKey, x, y, w, h, text, isChecked, primaryMouseClickCallback,
    secondaryMouseClickCallback)
    Button.initialize(self, containingScene, index, clickKey, x, y, w, h, text, primaryMouseClickCallback,
        secondaryMouseClickCallback)
    self.IsChecked = isChecked
end

function ToggleButton:SetIsChecked(isChecked)
    self.IsChecked = isChecked

    if self.IsChecked then
        self.BackColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
        self.BorderColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))
    else
        self.BackColor:UnlockOverride()
        self.BorderColor:UnlockOverride()
        if not self.ContainingScene.IsActive then
            self.BackColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BACK_COLOR))
            self.BorderColor:SetColorImmediately(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
        else
            -- Uh
        end
    end
end


function ToggleButton:OnThemeChanged(e)
    self:HandleGenericThemeChange(e)
    
    -- workaround for togglebuttons having diarrhea FFS, same thing is done for TextBoxes
    self:SetIsChecked(self.IsChecked)
end

function ToggleButton:OnMouseDown(e)
    
    self:SetIsChecked(not self.IsChecked)
    
    self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_PUSHED_BACK_COLOR))
    self.BorderColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_HOVERED_BORDER_COLOR))

    self.ContainingScene:AddQueuedCallback(self.PrimaryMouseClickCallback, self)
end


function ToggleButton:Draw()
    CurrentStyler:DrawRaisedFrame(self, CurrentRenderer:RGBToHexadecimalColor(self.BackColor.CurrentColor), CurrentRenderer:RGBToHexadecimalColor(self.BorderColor.CurrentColor),
        Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y, self.Width, self.Height)

    if (self.Text) then
        CurrentRenderer:DrawText(self.IsChecked and
                                     Appearance.Themes[Appearance.CurrentTheme].TOGGLEBUTTON_CHECKED_FORE_COLOR or
                                     Appearance.Themes[Appearance.CurrentTheme].TOGGLEBUTTON_UNCHECKED_FORE_COLOR,
            self.Text, self.X + self.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE / 3 *
                self.Text:len(), self.Y + self.Height / 2 - 7.5)
    end
end
