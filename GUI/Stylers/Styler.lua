Styler = middleclass('Styler')

-- In a styler, you get a reference to the control requesting a styler operation
-- You must not mutate this control's data or instance, only access it
-- Any accessing of the control's data must not include the already provided parameter data (you're not allowed to style based on control's Dimensions, Colors or Positions)

function Styler:initialize()
end

function Styler:DrawButton(button)
end

function Styler:DrawSlider(slider)
end

function Styler:DrawSliderHead(slider)
end

function Styler:DrawTextBox(textBox)
end

function Styler:DrawBorder(borderColor, borderSize, x, y, w, h)
end
