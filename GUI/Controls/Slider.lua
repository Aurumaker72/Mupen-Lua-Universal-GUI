Slider = middleclass('Slider', Control)

function Slider:initialize(x, y, w, h, value, min, max, staggered, isReadOnly, valueChangedCallback)
    Control.initialize(self, x, y, w, h)
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
    self.TargetHeadColor = self.IsMouseInside(self) and Appearance.Themes[Appearance.CurrentTheme].SLIDER_HOVERED_HEAD_COLOR or
    Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_COLOR
    -- do we want to do this though
    -- looks shit
    if self.IsReadOnly then
        self.TargetHeadColor = Appearance.Themes[Appearance.CurrentTheme].BUTTON_BORDER_COLOR
    end

    self.CurrentHeadColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentHeadColor), WGUI.HexadecimalColorToRGB(self.TargetHeadColor))
    self.CurrentTrackColor = WGUI.TemporalInterpolateRGBColor(WGUI.HexadecimalColorToRGB(self.CurrentTrackColor), WGUI.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_COLOR))
end

function Slider:IsMouseInside()
    return Mouse.IsInside(self.X - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH, self.Y - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2, self.Width + Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
        self.Height + Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT)
end

function Slider:Update()
    if self.IsReadOnly then
        return
    end
    if self.IsCapturingMouse then
        if Mouse.IsDown() == false then
            self.IsCapturingMouse = false
        else
            local val = Numeric.Remap(Numeric.Clamp(self.X - Mouse.X, -self.Width, 0), 0, -self.Width, self.Minimum,
                self.Maximum)
            self.Value = self.IsStaggered and math.floor(val) or val

            self.ValueChangedCallback(self)
        end
    end

    if Mouse.IsDown() and self.IsMouseInside(self) then
        self.IsCapturingMouse = true
    end

end

function Slider:Draw()
    WGUI.FillRectangle(self.CurrentTrackColor, self.X, self.Y + self.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT, self.Width + self.X,
        self.Y + self.Height / 2 + Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)

    local x = Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.X, self.X + self.Width) - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2
    local y = self.Y + self.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2;

    if self.IsCapturingMouse then
        self.TargetHeadColor = Appearance.Themes[Appearance.CurrentTheme].SLIDER_PRESSED_HEAD_COLOR
    end

    WGUI.FillRectangle(self.CurrentHeadColor, x, y, x + Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH, y + Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT)
end
