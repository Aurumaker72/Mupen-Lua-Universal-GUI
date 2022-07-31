PlasticStyler = middleclass('PlasticStyler', Styler)

local COLOR_SHIFT_AMOUNT = 20

function PlasticStyler:initialize()
end

function PlasticStyler:ControlShouldBeDeep(control)
    return control.IsChecked or (control.ShouldBePushed and control:ShouldBePushed() or false) or control.IsOpened or control.IsActive
end

function PlasticStyler:DrawButton(control, backColor, borderColor, borderSize, x, y, w, h)

    local lightenedBorderColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(borderColor)))
    local darkenedBorderColor = CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(borderColor)))

    if not self:ControlShouldBeDeep(control) then
        self:DrawBorder(borderColor, borderSize, x, y, w - borderSize, h - borderSize)
    end
    
    self:DrawBorder(borderColor, borderSize, x + borderSize, y + borderSize, w, h)

    if self:ControlShouldBeDeep(control) then
        x = x + borderSize
        y = y + borderSize
    end

    CurrentRenderer:FillRectangle(backColor, x, y, w, h)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(-COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor))), x, y, w, h / 4)
    CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(RendererHelper.DarkenRGBColor(COLOR_SHIFT_AMOUNT,
    CurrentRenderer:HexadecimalColorToRGB(backColor))), x, y + h / 2, w, h / 2)
end
function PlasticStyler:DrawBorder(borderColor, borderSize, x, y, w, h)
    CurrentRenderer:FillRectangle(borderColor, x - borderSize, y - borderSize, w + borderSize * 2, h + borderSize * 2)
end