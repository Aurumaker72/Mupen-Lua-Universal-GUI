Slider = middleclass('Slider', Control)

function Slider:initialize(containingScene, x, y, w, h, value, min, max, staggered, isReadOnly, valueChangedCallback)
    Control.initialize(self, containingScene, x, y, w, h, nil, nil)
    self.Minimum = min
    self.Maximum = max
    self.Value = Numeric.Clamp(value, min, max)
    self.IsStaggered = staggered
    self.IsReadOnly = isReadOnly
    self.ValueChangedCallback = valueChangedCallback

    self.TargetHeadColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR
    self.CurrentHeadColor = self.TargetHeadColor
    self.CurrentTrackColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_COLOR

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

    self.CurrentHeadColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentHeadColor),
        Color.HexadecimalColorToRGB(self.TargetHeadColor))
    self.CurrentTrackColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentTrackColor),
        Color.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_COLOR))
end

function Slider:IsMouseInside()
    return Mouse.IsInside(self.X - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
        self.Y - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2,
        self.Width + Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
        self.Height + Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT)
end

function Slider:Update()
    if self.IsReadOnly then
        return
    end
    if self.IsCapturingMouse then
        if Mouse.IsPrimaryDown() == false then
            self.IsCapturingMouse = false
        else
            local val = Numeric.Remap(Numeric.Clamp(self.X - Mouse.X, -self.Width, 0), 0, -self.Width, self.Minimum,
                self.Maximum)
            self.Value = self.IsStaggered and math.floor(val) or val

            self.ContainingScene.AddQueuedCallback(self.ContainingScene, self.ValueChangedCallback, self)

        end
    end

    if Mouse.IsPrimaryDown() and self.IsMouseInside(self) then
        self.IsCapturingMouse = true
    end

end

function Slider:Draw()
    CurrentRenderer:FillRectangle(self.CurrentTrackColor, self.X, self.Y + self.Height / 2 -
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT, self.Width,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
    CurrentRenderer:FillRectangle(self.CurrentTrackColor,
        self.X - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Y + self.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT -
            -Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        self.Width + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE, Appearance.Themes[Appearance.CurrentTheme]
            .SLIDER_TRACK_HEIGHT + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE)
    if self.IsCapturingMouse then
        self.CurrentHeadColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_PRESSED_HEAD_COLOR
    end

    CurrentRenderer:FillRectangle(self.CurrentHeadColor, (self.Minimum == self.Maximum and self.X or
        Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.X, self.X + self.Width)) -
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
        self.Y + Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT -
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2 + 1)
end
