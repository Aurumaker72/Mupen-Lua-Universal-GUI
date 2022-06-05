Slider = middleclass('Slider', Control)

function Slider:initialize(x, y, w, h, min, max, staggered, valueChangedCallback)
    Control.initialize(self, x, y, w, h)
    self.Minimum = min
    self.Maximum = max
    self.Value = self.Minimum
    self.IsStaggered = staggered
    self.ValueChangedCallback = valueChangedCallback
end

function Slider:IsMouseInside()
    return Mouse.IsInside(self.X - SLIDER_HEAD_WIDTH, self.Y - SLIDER_HEAD_HEIGHT / 2, self.Width + SLIDER_HEAD_WIDTH,
        self.Height + SLIDER_HEAD_HEIGHT)
end

function Slider:Update()

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

    WGUI.FillRectangle(BUTTON_BACK_COLOR, self.X, self.Y, self.Width + self.X, self.Height + self.Y)

    WGUI.FillRectangle(SLIDER_TRACK_COLOR, self.X, self.Y + self.Height / 2 - SLIDER_TRACK_HEIGHT, self.Width + self.X,
        self.Y + self.Height / 2 + SLIDER_TRACK_HEIGHT)

    local x = Numeric.Remap(self.Value, self.Minimum, self.Maximum, self.X, self.X + self.Width) - SLIDER_HEAD_WIDTH / 2
    local y = self.Y + self.Height / 2 - SLIDER_HEAD_HEIGHT / 2;

    local headColor = self.IsMouseInside(self) and SLIDER_HOVERED_HEAD_COLOR or
                          SLIDER_HEAD_COLOR
    if self.IsCapturingMouse then
        headColor = SLIDER_PRESSED_HEAD_COLOR
    end
    WGUI.FillRectangle(headColor, x, y, x + SLIDER_HEAD_WIDTH, y + SLIDER_HEAD_HEIGHT)
end
