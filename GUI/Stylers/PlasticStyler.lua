PlasticStyler = middleclass('PlasticStyler', Styler)

local COLOR_SHIFT_AMOUNT = 20

function PlasticStyler:initialize()
end

function PlasticStyler:ControlShouldBeDeep(control)
    if control:isInstanceOf(TextBox) then
        return false
    end
    return control.IsChecked or (control.ShouldBePushed and control:ShouldBePushed() or false) or control.IsOpened or
        control.IsActive or control.IsCapturingMouse
end

function PlasticStyler:DrawPlasticRectangleExplicit(color, x, y, w, h)
    if w >= h then
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(0, color)), x, y, w, h)
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT, color)), x, y, w, h / 4)
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT, color)), x, y + h / 2, w, h / 2)
    end
    if h > w then
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(0, color)), x, y, w, h)
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT, color)), x, y, w / 4, h)
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT, color)), x + w /2, y, w / 2, h)
    end


end

function PlasticStyler:DrawPlasticRectangle(control)
    self:DrawPlasticRectangleExplicit(control.BackColor.CurrentColor, control.X, control.Y, control.Width, control.Height)
end

function PlasticStyler:DrawBorder(color, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(color),
        x - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        y - Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE,
        w + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2,
        h + Appearance.Themes[Appearance.CurrentTheme].BORDER_SIZE * 2)
end

function PlasticStyler:DrawButton(button)
    self:DrawBorder(button.BorderColor.CurrentColor, button.X, button.Y, button.Width, button.Height)
    self:DrawPlasticRectangle(button)
end

function PlasticStyler:DrawSlider(slider)
     
    
    if slider.IsHorizontal then
        local y = slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT / 2
        self:DrawBorder(slider.BackColor.CurrentColor, slider.X, y, slider.Width, Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
        self:DrawPlasticRectangleExplicit(slider.BackColor.CurrentColor, slider.X, y, slider.Width, Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT)
     else
        local x = slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH / 2
        self:DrawBorder(slider.BackColor.CurrentColor, x, slider.Y, Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
        self:DrawPlasticRectangleExplicit(slider.BackColor.CurrentColor, x, slider.Y,Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_WIDTH, slider.Height)
     end
end

function PlasticStyler:DrawSliderHead(slider)
    if slider.IsHorizontal then
        CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor),             (slider.Minimum == slider.Maximum and slider.X or Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.X, slider.X + slider.Width)) - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2, 
        slider.Y + slider.Height / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT)
    else
        CurrentRenderer:FillEllipse(CurrentRenderer:RGBToHexadecimalColor(slider.ForeColor.CurrentColor), slider.X + slider.Width / 2 - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT / 2, 
        (slider.Minimum == slider.Maximum and slider.Y or Numeric.Remap(slider.Value, slider.Minimum, slider.Maximum, slider.Y + slider.Height, slider.Y)) - Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH / 2,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_HEIGHT,
        Appearance.Themes[Appearance.CurrentTheme].SLIDER_HEAD_WIDTH)
    end
end

function PlasticStyler:DrawTextBox(textBox)
    self:DrawBorder(textBox.BorderColor.CurrentColor, textBox.X, textBox.Y, textBox.Width, textBox.Height)
    self:DrawPlasticRectangle(textBox)
end
