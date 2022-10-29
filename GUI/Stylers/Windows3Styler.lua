Windows3Styler = middleclass('Windows3Styler', Styler)

local borderRadius = 4

function Windows3Styler:initialize()
end

function Windows3Styler:ControlShouldBeDeep(control)
    if control:isInstanceOf(TextBox) then
        return false
    end
    return control.IsChecked or (control.ShouldBePushed and control:ShouldBePushed() or false) or control.IsOpened or
        control.IsActive or control.IsCapturingMouse
end

function Windows3Styler:DrawLegacyRectangleExplicit(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(0, color)), x, y, w
        , h, borderRadius, borderRadius)

    local thickness = 3
    local colorShift = 40
    local reliefBorderRadius = 1

    -- upper line and left line
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-colorShift, color))
        , x, y, w, thickness, reliefBorderRadius, reliefBorderRadius)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-colorShift, color))
        , x, y, thickness, h, reliefBorderRadius, reliefBorderRadius)

    -- lower line and right line
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(colorShift, color))
        , x, y + h - thickness, w, thickness, reliefBorderRadius, reliefBorderRadius)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(colorShift, color))
        , x + w - thickness, y, thickness, h, reliefBorderRadius, reliefBorderRadius)
    -- CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(colorShift, color)), x, y, thickness, h, borderRadius, borderRadius)


end

function Windows3Styler:DrawLegacyRectangle(control)
    self:DrawLegacyRectangleExplicit(control.BackColor.CurrentColor, control.X, control.Y, control.Width, control.Height)
end

function Windows3Styler:DrawBorder(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(80, color)),
        x - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        w + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2,
        h + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2, borderRadius, borderRadius)
end

function Windows3Styler:DrawButton(button)
    self:DrawBorder(button.BorderColor.CurrentColor, button.X, button.Y, button.Width, button.Height)
    self:DrawLegacyRectangle(button)
end

function Windows3Styler:DrawSlider(slider)


    if slider.IsHorizontal then
        local y = slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2
        self:DrawBorder(slider.BackColor.CurrentColor, slider.X, y, slider.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
        self:DrawLegacyRectangleExplicit(slider.BackColor.CurrentColor, slider.X, y, slider.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
    else
        local x = slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH / 2
        self:DrawBorder(slider.BackColor.CurrentColor, x, slider.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
        self:DrawLegacyRectangleExplicit(slider.BackColor.CurrentColor, x, slider.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
    end
end

function Windows3Styler:DrawSliderHead(slider)
    if slider.IsHorizontal then
        self:DrawLegacyRectangleExplicit(slider.ForeColor.CurrentColor,
            (
            slider.Minimum == slider.Maximum and slider.X or
                Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.X, slider.X + slider.Width)) -
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
            slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT)
    else
        self:DrawLegacyRectangleExplicit(slider.ForeColor.CurrentColor,
            slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2,
            (
            slider.Minimum == slider.Maximum and slider.Y or
                Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.Y + slider.Height, slider.Y)) -
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH)
    end
end

function Windows3Styler:DrawTextBox(textBox)
    self:DrawBorder(textBox.BorderColor.CurrentColor, textBox.X, textBox.Y, textBox.Width, textBox.Height)
    self:DrawLegacyRectangle(textBox)
end
