Styler = middleclass('Styler')

-- In a styler, you get a reference to the control requesting a styler operation
-- You must not mutate this control's data or instance, only access it
-- Any accessing of the control's data must not include the already provided parameter data (you're not allowed to style based on control's Dimensions, Colors or Positions)

function Styler:initialize()
end

function Styler:DrawRaisedFrame(control, backColor, borderColor, borderSize, x, y, w, h)
end

function Styler:DrawBorder(control, borderColor, borderSize, x, y, w, h)
end

function Styler:DrawGenericAccentShape(control, backColor, x, y, w, h)
end


function Styler:ControlShouldBeDeep(control)
    if control:isInstanceOf(TextBox) then
        return false
    end
    return control.IsChecked or (control.ShouldBePushed and control:ShouldBePushed() or false) or control.IsOpened or control.IsActive or control.IsCapturingMouse
end