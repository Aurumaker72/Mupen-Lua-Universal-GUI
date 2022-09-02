Slider = middleclass('Slider', Control)

function Slider:initialize(containingScene, index, x, y, w, h, value, min, max, isHorizontal, isReadOnly,
    valueChangedCallback)
    Control.initialize(self, containingScene, index, x, y, w, h, nil, nil)
    self.Minimum = min
    self.Maximum = max
    self.Value = Numeric.Clamp(value, min, max)
    self.IsHorizontal = isHorizontal
    self.ValueChangedCallback = valueChangedCallback

    self.HeadColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR))
    self.TrackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_COLOR))

    self:SetReadOnly(isReadOnly)
end

function Slider:SetReadOnly(isReadOnly)
    self.IsReadOnly = isReadOnly
    if self.IsReadOnly then
        self.HeadColor:LockOverride(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR))
    else
        self.HeadColor:UnlockOverride()
    end
end

function Slider:OnMouseEnter(e)
    if not self.IsCapturingMouse then
        self.HeadColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_HOVERED_HEAD_COLOR))
    end
end

function Slider:OnMouseLeave(e)
    if not self.IsCapturingMouse then
        self.HeadColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR))
    end
end

function Slider:OnMouseDown(e)
    if not self.IsReadOnly then
        self.IsCapturingMouse = true
        self:MoveHeadToMouse(e)
        self.HeadColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_PRESSED_HEAD_COLOR))
    end
end

function Slider:OnMouseUp(e)
    self.IsCapturingMouse = false
    self.HeadColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR))
end

function Slider:OnMouseMove(e)
    if self.IsCapturingMouse then
        self:MoveHeadToMouse(e)
    end

end

function Slider:MoveHeadToMouse(mousePositions)
    if self.IsHorizontal then
        self.Value = Numeric.Remap(Numeric.Clamp(self.X - mousePositions.X, -self.Width, 0), 0, -self.Width, self.Minimum,
            self.Maximum)
    else
        self.Value = Numeric.Remap(Numeric.Clamp(self.Y - mousePositions.Y, -self.Height, 0), 0, -self.Height, self.Maximum,
            self.Minimum)
    end
    self.ContainingScene:AddQueuedCallback(self.ValueChangedCallback, self)
end

function Slider:PersistentUpdate()
    self.HeadColor:Update()
    self.TrackColor:Update()
end

function Slider:Draw()

    if self.IsHorizontal then
        CurrentStyler:DrawRaisedFrame(self, CurrentRenderer:RGBToHexadecimalColor(self.TrackColor.CurrentColor),
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR,
            Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y + self.Height / 2 -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT, self.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
    else
        CurrentStyler:DrawRaisedFrame(self, CurrentRenderer:RGBToHexadecimalColor(self.TrackColor.CurrentColor),
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR,
            Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X + self.Width / 2 -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, self.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, self.Height)
    end

    if self.IsHorizontal then
        CurrentStyler:DrawGenericAccentShape(self, CurrentRenderer:RGBToHexadecimalColor(self.HeadColor.CurrentColor),
            (self.Minimum == self.Maximum and self.X or
                Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.X, self.X + self.Width)) -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2, self.Y +
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2 + 1)
    else
        CurrentStyler:DrawGenericAccentShape(self, CurrentRenderer:RGBToHexadecimalColor(self.HeadColor.CurrentColor),
            self.X + 1, (self.Minimum == self.Maximum and self.Y or
                Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.Y + self.Height, self.Y)) -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH)
    end

end
