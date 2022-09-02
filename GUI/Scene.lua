Scene = middleclass('Scene')

function Scene:initialize()
    self.Controls = {}
    self.BackColor = AnimatedColor:new(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
    self.CurrentControlIndex = 1
    self.IsActive = false
    self.HasBackColor = true
    self.QueuedLayoutPass = false
    self.QueuedCallbacks = {}
    self.QueuedCallbackParameters = {}

end

function Scene:GetControls()
    return self.Controls
end

function Scene:SetControl(key, control)
    if not self.Controls[key] then
        self.CurrentControlIndex = self.CurrentControlIndex + 1
    end
    self.Controls[key] = control
end

function Scene:AddControls(controls)
    for key, control in pairs(controls) do

        self.CurrentControlIndex = self.CurrentControlIndex + 1
        -- control.Index = self.CurrentControlIndex
        -- TODO: implement automatic index tracker

        self.Controls[key] = control

    end
end

function Scene:AddQueuedCallback(callback, parameter)
    if not callback or not parameter then
        print("Skipping callback")
        return
    end
    self.QueuedCallbacks[#self.QueuedCallbacks + 1] = callback
    self.QueuedCallbackParameters[#self.QueuedCallbackParameters + 1] = parameter
end

function Scene:SetActive(isActive)
    self.IsActive = isActive
    self:QueueLayoutPass()
end

function Scene:QueueLayoutPass()
    self.QueuedLayoutPass = true
end

function Scene:Update()

    if self.HasBackColor then
        self.BackColor:SetTargetColor(CurrentRenderer:HexadecimalColorToRGB(Appearance.Themes[Appearance.CurrentTheme].WINDOW_BACK_COLOR))
    end

    self.BackColor:Update()

    for key, control in pairs(self.Controls) do
        if self.IsActive then
            control:Update()
        end
        control:PersistentUpdate()
    end

end

function Scene:Relayout()
    if self.QueuedLayoutPass then
        for k, v in pairs(self.Controls) do
            if v.Relayout then
                v:Relayout()
            end
        end
        self.QueuedLayoutPass = false
    end
end

function Scene:Draw()
    if self.HasBackColor then
        CurrentRenderer:FillRectangle(CurrentRenderer:RGBToHexadecimalColor(self.BackColor.CurrentColor), Screen.Dimensions.Width - Screen.ExpandedOffset, 0,
            (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2, Screen.Dimensions.Height)
    end
    if self.IsActive then
        for key, control in pairs(self.Controls) do
            control:Draw()
        end
        for key, control in pairs(self.Controls) do
            control:LateDraw()
        end
    end

end
