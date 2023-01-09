Windows11Styler = middleclass('Windows11Styler', Styler)

local borderRadius = 4
function Windows11Styler:initialize()
end

function Windows11Styler:ControlShouldBeDeep(control)
    if control:isInstanceOf(TextBox) then
        return false
    end
    return control.IsChecked or (control.ShouldBePushed and control:ShouldBePushed() or false) or control.IsOpened or
        control.IsActive or control.IsCapturingMouse
end

function Windows11Styler:DrawMicaRectangleExplicit(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(color), x, y, w, h, borderRadius, borderRadius)
end

function Windows11Styler:DrawMicaRectangle(control)
    self:DrawMicaRectangleExplicit(control.BackColor.CurrentColor, control.X, control.Y, control.Width, control.Height)
end

function Windows11Styler:DrawBorder(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(color),
        x - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        w + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2,
        h + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2, borderRadius, borderRadius)
end

function Windows11Styler:DrawButton(button)
    self:DrawBorder(button.BorderColor.CurrentColor, button.X, button.Y, button.Width, button.Height)
    self:DrawMicaRectangle(button)
end

function Windows11Styler:DrawSlider(slider)


    if slider.IsHorizontal then
        local y = slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2
        self:DrawBorder(slider.BackColor.CurrentColor, slider.X, y, slider.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
        self:DrawMicaRectangleExplicit(slider.BackColor.CurrentColor, slider.X, y, slider.Width,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
    else
        local x = slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH / 2
        self:DrawBorder(slider.BackColor.CurrentColor, x, slider.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
        self:DrawMicaRectangleExplicit(slider.BackColor.CurrentColor, x, slider.Y,
            Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
    end
end

function Windows11Styler:DrawSliderHead(slider)
    local radius = Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT

    local x = slider.IsHorizontal and
        (slider.Minimum == slider.Maximum and slider.X or
            Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.X, slider.X + slider.Width) -
            radius / 2) or (slider.X + slider.Width / 2 - radius / 2)

    local y = slider.IsHorizontal and (slider.Y + slider.Height / 2 - radius / 2) or
        (slider.Minimum == slider.Maximum and slider.Y or
            Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.Y + slider.Height, slider.Y) -
            radius / 2)

    CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor), x, y, radius,
        radius)
    CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(20,
        slider.ForeColor.CurrentColor)), x + radius / 4, y + radius / 4, radius / 2, radius / 2)

    -- if slider.IsHorizontal then
    --     CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor),
    --         (
    --         slider.Minimum == slider.Maximum and slider.X or
    --             Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.X, slider.X + slider.Width)) -
    --         radius / 2,
    --         slider.Y + slider.Height / 2 - radius / 2,
    --         radius,
    --         radius)
    -- else
    --     CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor),
    --         slider.X + slider.Width / 2 - radius / 2,
    --         (
    --         slider.Minimum == slider.Maximum and slider.Y or
    --             Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.Y + slider.Height, slider.Y)) -
    --         radius / 2,
    --         radius,
    --         radius)
    -- end
end

function Windows11Styler:DrawTextBox(textBox)
    self:DrawBorder(textBox.BorderColor.CurrentColor, textBox.X, textBox.Y, textBox.Width, textBox.Height)
    self:DrawMicaRectangle(textBox)

    local focusMarkHeight = 1
    -- local focusMarkHexColor = textBox.IsActive and
    -- textBox.BorderColor.CurrentColor or
    -- RendererHelper.DarkenRGBColor(-10, CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].TEXTBOX_BORDER_COLOR))
    local focusMarkColor = textBox.BorderColor.CurrentColor

    self:DrawMicaRectangleExplicit(focusMarkColor
        , textBox.X
        , textBox.Y + textBox.Height - focusMarkHeight, textBox.Width, focusMarkHeight)

end
