Slider = middleclass('Slider', Control)

function Slider:initialize(containingScene, index, x, y, w, h, value, min, max, isHorizontal, isReadOnly,
    valueChangedCallback)
    Control.initialize(self, containingScene, index, x, y, w, h, nil, nil)
    self.Minimum = min
    self.Maximum = max
    self.Value = Numeric.Clamp(value, min, max)
    self.IsHorizontal = isHorizontal
    self.IsReadOnly = isReadOnly
    self.ValueChangedCallback = valueChangedCallback

    self.TargetHeadColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR
    self.CurrentHeadColor = self.TargetHeadColor
    self.CurrentTrackColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_COLOR

end

function Slider:IsMouseInside()
    return Mouse.IsInside(self.X, self.Y, self.Width, self.Height)
end

function Slider:PersistentUpdate()
    self.TargetHeadColor = self.IsMouseInside(self) and
                               Appearance.Themes[Appearance.CurrentTheme].SLIDER_HOVERED_HEAD_COLOR or
                               Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR
    -- do we want to do this though
    -- looks shit
    if self.IsReadOnly then
        self.TargetHeadColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR
    end

    self.CurrentHeadColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentHeadColor),
        CurrentRenderer:HexadecimalColorToRGB(self.TargetHeadColor))
    self.CurrentTrackColor = Color.TemporalInterpolateRGBColor(
        CurrentRenderer:HexadecimalColorToRGB(self.CurrentTrackColor),
        CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_COLOR))
end

function Slider:Update()
    if self.IsReadOnly then
        return
    end
    if self.IsCapturingMouse then
        if Mouse.IsPrimaryDown() == false then
            self.IsCapturingMouse = false
        else
            if self.IsHorizontal then
                self.Value = Numeric.Remap(Numeric.Clamp(self.X - Mouse.X, -self.Width, 0), 0, -self.Width,
                    self.Minimum, self.Maximum)
            else
                self.Value = Numeric.Remap(Numeric.Clamp(self.Y - Mouse.Y, -self.Height, 0), 0, -self.Height,
                    self.Maximum, self.Minimum)
            end

            self.ContainingScene:AddQueuedCallback(self.ValueChangedCallback, self)

        end
    end

    if Mouse.IsPrimaryClicked() and self.IsMouseInside(self) then
        self.IsCapturingMouse = true
    end

end

function Slider:Draw()

    if self.IsHorizontal then
        CurrentStyler:DrawRaisedFrame(self, self.CurrentTrackColor,
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR,
            Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X, self.Y + self.Height / 2 -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT, self.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
    else
        CurrentStyler:DrawRaisedFrame(self, self.CurrentTrackColor,
            Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR,
            Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, self.X + self.Width / 2 -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, self.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, self.Height)
    end

    if self.IsCapturingMouse then
        self.CurrentHeadColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_PRESSED_HEAD_COLOR
    end

    if self.IsHorizontal then
        CurrentStyler:DrawGenericAccentShape(self, 
        self.CurrentHeadColor, 
        (self.Minimum == self.Maximum and self.X or Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.X, self.X + self.Width)) - 
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2, 
        self.Y + Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT -
                Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2 + 1)
    else
        CurrentStyler:DrawGenericAccentShape(self, 
        self.CurrentHeadColor, 
        self.X + 1,
            (self.Minimum == self.Maximum and self.Y or
                Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.Y + self.Height, self.Y)) - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH)
    end

end
