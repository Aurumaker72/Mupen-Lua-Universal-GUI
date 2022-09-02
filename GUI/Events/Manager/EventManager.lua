EventManager = {}

function EventManager.Initialize()

end

function EventManager.PropagateTo(key, scene)

    local skipOtherControls = false

    for k, control in pairs(scene.Controls) do

        -- this MUST fire on every single control of every single scene, no exceptions
        if Appearance.HasChanged then
            control:OnThemeChanged(ThemeChangedEvent.new(Appearance.CurrentTheme))
        end

        if scene.IsActive then

            local bounds = control:GetBounds()

            if Mouse.IsInside(bounds.X, bounds.Y, bounds.Width, bounds.Height) or control.IsCapturingMouse then
                if Mouse.IsPrimaryClicked() then
                    control:OnMouseDown(MouseDownEvent.new(Mouse.X, Mouse.Y, MOUSE_BUTTON_LEFT))
                    skipOtherControls = true
                end
                if Mouse.IsSecondaryClicked() then
                    control:OnMouseDown(MouseDownEvent.new(Mouse.X, Mouse.Y, MOUSE_BUTTON_RIGHT))
                    skipOtherControls = true
                end
                if not Mouse.IsPrimaryDown() and Mouse.WasPrimaryDown() then
                    control:OnMouseUp(MouseUpEvent.new(Mouse.X, Mouse.Y, MOUSE_BUTTON_LEFT))
                    skipOtherControls = true
                end
                if not Mouse.IsSecondaryDown() and Mouse.WasSecondaryDown() then
                    control:OnMouseUp(MouseUpEvent.new(Mouse.X, Mouse.Y, MOUSE_BUTTON_RIGHT))
                    skipOtherControls = true
                end
                if Mouse.HasMoved() then
                    control:OnMouseMove(MouseMoveEvent.new(Mouse.X, Mouse.Y))
                    skipOtherControls = true
                end
            end

            if not control.IsCapturingMouse then
                -- dont send enter/leave events while control captures mouse
                if Mouse.IsInside(bounds.X, bounds.Y, bounds.Width, bounds.Height) and
                    (not Mouse.IsLastInside(bounds.X, bounds.Y, bounds.Width, bounds.Height)) then
                    control:OnMouseEnter(MouseEnterEvent.new(Mouse.X, Mouse.Y))
                    skipOtherControls = true
                end
                if Mouse.IsLastInside(bounds.X, bounds.Y, bounds.Width, bounds.Height) and
                    (not Mouse.IsInside(bounds.X, bounds.Y, bounds.Width, bounds.Height)) then
                    control:OnMouseLeave(MouseLeaveEvent.new(Mouse.X, Mouse.Y))
                    skipOtherControls = true
                end

            end

            if control.IsCapturingKeyboard then
                for key, v in pairs(Keyboard.PushedKeys) do
                    control:OnKeyDown(KeyDownEvent.new(key))
                    skipOtherControls = true
                end
                for key, v in pairs(Keyboard.ReleasedKeys) do
                    control:OnKeyUp(KeyUpEvent.new(key))
                    skipOtherControls = true
                end
            end

        end
    end

end
