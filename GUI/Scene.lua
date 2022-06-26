Scene = middleclass('Scene')

function Scene:initialize(controls)
    self.Controls = controls
    self.CurrentBackColor = Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR
    self.IsActive = false
    self.QueuedCallbacks = {}
    self.QueuedCallbackParameters = {}
end

function Scene:GetControls()
    return self.Controls
end

function Scene:AddControl(key, control)
    self.Controls[key] = control
end

function Scene:AddControls(controls)
    self.Controls = controls
end
function Scene:AddQueuedCallback(callback, parameter)
    self.QueuedCallbacks[#self.QueuedCallbacks + 1] = callback
    self.QueuedCallbackParameters[#self.QueuedCallbackParameters + 1] = parameter
end

function Scene:Update()

    self.CurrentBackColor = Color.TemporalInterpolateRGBColor(Color.HexadecimalColorToRGB(self.CurrentBackColor),
        Color.HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))

    for key, control in pairs(self.Controls) do
        if self.IsActive then
            control:Update()
        end
        control:PersistentUpdate()
    end

end

function Scene:Draw()

    CurrentRenderer:FillRectangle(self.CurrentBackColor, Screen.Dimensions.Width - Screen.ExpandedOffset, 0,
        (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2, Screen.Dimensions.Height)

    if self.IsActive then
        for key, control in pairs(self.Controls) do
            control:Draw()
        end
        for key, control in pairs(self.Controls) do
            control:ModalDraw()
        end
    end

end
