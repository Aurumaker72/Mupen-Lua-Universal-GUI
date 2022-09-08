EventManager = {}

function EventManager.Initialize()

end

function EventManager.PropagateTo(key, scene)

    local skipOtherControls = false
    local wndInForeground = true
    if emu.ismainwindowinforeground then
        -- TODO: cache this, as it internally calls GetForegroundWindow()
        wndInForeground = emu.ismainwindowinforeground()
    end

    for k, control in pairs(scene.Controls) do

        -- this MUST fire on every single control of every single scene, no exceptions
        if Appearance.HasChanged then
            control:OnThemeChanged(ThemeChangedEvent.new(Appearance.CurrentTheme))
        end

        -- skip propagation of input events when unfocused 
        if not wndInForeground then
            goto iteration_end
        end

        if scene.IsActive then

            local bounds = control:GetBounds()
            local hasInteractionKey = (control.GetInteractionKeys and control:GetInteractionKeys() == nil == false)

            if hasInteractionKey then
                for i = 1, #control:GetInteractionKeys(), 1 do
                    local interactedKey = control:GetInteractionKeys()[i]
                    if Keyboard.KeyPressed(interactedKey) then
                        local _e = PrimaryInteractionEvent.new(interactedKey, InteractionEvent.KeyboardSource)
                        if control:CanBeInteracted(_e) then
                            control:OnPrimaryInteracted(_e)
                        end
                        skipOtherControls = true
                    end
                    if (Keyboard.KeyHeld(interactedKey) and not Keyboard.WasKeyHeld(interactedKey)) then
                        local _e = InteractionBeginEvent.new(InteractionEvent.KeyboardSource)
                        if control:CanBeInteracted(_e) then
                            control:OnInteractionBegin(_e)
                        end
                        
                        skipOtherControls = true
                    end

                    if (not Keyboard.KeyHeld(interactedKey) and Keyboard.WasKeyHeld(interactedKey)) then
                        local _e = InteractionEndEvent.new(InteractionEvent.KeyboardSource)
                        if control:CanBeInteracted(_e) then
                            control:OnInteractionEnd(_e)
                        end
                        skipOtherControls = true
                    end
                end

            end

            if Mouse.IsInside(bounds.X, bounds.Y, bounds.Width, bounds.Height) or control.IsCapturingMouse then

                -- TODO: restructure, this is horrendous

                if Mouse.IsPrimaryClicked() then
                    control:OnMouseDown(MouseDownEvent.new(Mouse.X, Mouse.Y, MOUSE_BUTTON_LEFT))
                    control:OnPrimaryInteracted(PrimaryInteractionEvent.new(nil, InteractionEvent.MouseSource))
                    skipOtherControls = true
                end

                if (Mouse.IsPrimaryClicked()) then
                    control:OnInteractionBegin(InteractionBeginEvent.new(InteractionEvent.MouseSource))
                    skipOtherControls = true
                end

                if (Numeric.PointIsInsideRectangle(Mouse.PositionOnLastClick.X, Mouse.PositionOnLastClick.Y, bounds.X,
                    bounds.Y, bounds.Width, bounds.Height) and (not Mouse.IsPrimaryDown() and Mouse.WasPrimaryDown())) then
                    control:OnInteractionEnd(InteractionEndEvent.new(InteractionEvent.MouseSource))
                    skipOtherControls = true
                end

                if Numeric.PointIsInsideRectangle(Mouse.PositionOnLastClick.X, Mouse.PositionOnLastClick.Y, bounds.X,
                    bounds.Y, bounds.Width, bounds.Height) then
                    if not Mouse.IsPrimaryDown() and Mouse.WasPrimaryDown() then
                        control:OnMouseUp(MouseUpEvent.new(Mouse.X, Mouse.Y, MOUSE_BUTTON_LEFT))
                        skipOtherControls = true
                    end
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

        ::iteration_end::
    end

end
