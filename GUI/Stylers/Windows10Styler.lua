Windows10Styler = middleclass('Windows10Styler', Styler)

function Windows10Styler:initialize()
end

function Windows10Styler:ControlShouldBeDeep(control)
    if control:isInstanceOf(TextBox) then
        return false
    end
    return control.IsChecked or (control.ShouldBePushed and control:ShouldBePushed() or false) or control.IsOpened or
        control.IsActive or control.IsCapturingMouse
end

function Windows10Styler:DrawFluentRectangleExplicit(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(color), x, y, w, h)

end

function Windows10Styler:DrawFluentRectangle(control)
    self:DrawFluentRectangleExplicit(control.BackColor.CurrentColor, control.X, control.Y, control.Width, control.Height)
end

function Windows10Styler:DrawBorder(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(color),
        x - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        w + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2,
        h + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2)
end

function Windows10Styler:DrawButton(button)
    self:DrawBorder(button.BorderColor.CurrentColor, button.X, button.Y, button.Width, button.Height)
    self:DrawFluentRectangle(button)
end

function Windows10Styler:DrawSlider(slider)


    if slider.IsHorizontal then
        local y = slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2
        self:DrawBorder(slider.BackColor.CurrentColor, slider.X, y, slider.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
        self:DrawFluentRectangleExplicit(slider.BackColor.CurrentColor, slider.X, y, slider.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
    else
        local x = slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH / 2
        self:DrawBorder(slider.BackColor.CurrentColor, x, slider.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
        self:DrawFluentRectangleExplicit(slider.BackColor.CurrentColor, x, slider.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
    end
end

function Windows10Styler:DrawSliderHead(slider)
    if slider.IsHorizontal then
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor),
            (
            slider.Minimum == slider.Maximum and slider.X or
                Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.X, slider.X + slider.Width)) -
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
            slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT)
    else
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor),
            slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2,
            (
            slider.Minimum == slider.Maximum and slider.Y or
                Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.Y + slider.Height, slider.Y)) -
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH)
    end
end

function Windows10Styler:DrawTextBox(textBox)
    self:DrawBorder(textBox.BorderColor.CurrentColor, textBox.X, textBox.Y, textBox.Width, textBox.Height)
    self:DrawFluentRectangle(textBox)
end
