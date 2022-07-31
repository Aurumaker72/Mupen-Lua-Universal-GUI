-- i put this shit together in 15 minutes before eating
InputDirection = {}

FOLDER_INPUTDIRECTION = FOLDER_USER_CODE .. "InputDirection" .. "\\"

dofile(FOLDER_INPUTDIRECTION .. "Broker.lua")
dofile(FOLDER_INPUTDIRECTION .. "Memory.lua")
dofile(FOLDER_INPUTDIRECTION .. "Joypad.lua")
dofile(FOLDER_INPUTDIRECTION .. "Angles.lua")
dofile(FOLDER_INPUTDIRECTION .. "Engine.lua")
dofile(FOLDER_INPUTDIRECTION .. "Buttons.lua")
dofile(FOLDER_INPUTDIRECTION .. "Input.lua")
dofile(FOLDER_INPUTDIRECTION .. "Program.lua")
dofile(FOLDER_INPUTDIRECTION .. "MoreMaths.lua")
dofile(FOLDER_INPUTDIRECTION .. "Actions.lua")
dofile(FOLDER_INPUTDIRECTION .. "Swimming.lua")

function UserCodeAtInputPoll()
    Program.initFrame()
    Program.main()
    Joypad.send()
    Swimming.swim("A")

    Scenes.Main.Controls.Joystick.ValueX = Joypad.input.X
    Scenes.Main.Controls.Joystick.ValueY = -Joypad.input.Y

    Scenes.Main.Controls.LabelsStackPanel.Children.YawFacing.Text = "Yaw (Facing): " ..
                                                                        Engine.getEffectiveAngle(Memory.Mario.FacingYaw)
    Scenes.Main.Controls.LabelsStackPanel.Children.YawIntended.Text = "Yaw (Intended): " ..
                                                                          Engine.getEffectiveAngle(
            Memory.Mario.IntendedYaw)
    Scenes.Main.Controls.LabelsStackPanel.Children.OppositeFacing.Text = "Opposite (Intended): " ..
                                                                             (Engine.getEffectiveAngle(
            Memory.Mario.FacingYaw) + 32768) % 65536
    Scenes.Main.Controls.LabelsStackPanel.Children.OppositeIntended.Text = "Opposite (Intended): " ..
                                                                               (Engine.getEffectiveAngle(
            Memory.Mario.IntendedYaw) + 32768) % 65536

    local speed = 0
    if Memory.Mario.HSpeed ~= 0 then
        speed = MoreMaths.DecodeDecToFloat(Memory.Mario.HSpeed)
    end

    Scenes.Main.Controls.LabelsStackPanel.Children.HSpd.Text = "H Spd: " .. MoreMaths.Round(speed, 5)
    Scenes.Main.Controls.LabelsStackPanel.Children.SpdEfficiency.Text = "Spd Efficiency: " ..
                                                                            Engine.GetSpeedEfficiency() .. "%"

    speed = 0
    if Memory.Mario.VSpeed > 0 then
        speed = MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.VSpeed), 6)
    end

    Scenes.Main.Controls.LabelsStackPanel.Children.YSpd.Text = "Y Spd: " .. MoreMaths.Round(speed, 5)
    Scenes.Main.Controls.LabelsStackPanel.Children.HSlidingSpd.Text = "H Sliding Spd: " ..
                                                                          MoreMaths.Round(Engine.GetHSlidingSpeed(), 6)
    Scenes.Main.Controls.LabelsStackPanel.Children.X.Text = "Mario X: " ..
                                                                MoreMaths.Round(
            MoreMaths.DecodeDecToFloat(Memory.Mario.X), 2)
    Scenes.Main.Controls.LabelsStackPanel.Children.Y.Text = "Mario Y: " ..
                                                                MoreMaths.Round(
            MoreMaths.DecodeDecToFloat(Memory.Mario.Y), 2)
    Scenes.Main.Controls.LabelsStackPanel.Children.Z.Text = "Mario Z: " ..
                                                                MoreMaths.Round(
            MoreMaths.DecodeDecToFloat(Memory.Mario.Z), 2)
    Scenes.Main.Controls.LabelsStackPanel.Children.XZMovement.Text = "XZ Movement: " ..
                                                                         MoreMaths.Round(Engine.GetDistMoved(), 6)
    Scenes.Main.Controls.LabelsStackPanel.Children.Action.Text = "Action: " .. Engine.GetCurrentAction()

    local distmoved = Engine.GetTotalDistMoved()
    if (Broker.DistanceMeasurement == false) then
        distmoved = Broker.DistanceMeasurementSaved
    end
    Scenes.Main.Controls.LabelsStackPanel.Children.MovedDist.Text = "Moved Dist: " .. distmoved

end

function InputDirection.SetStrainMode(mode)
    Broker.SelectedItem = mode
    Scenes.Main.Controls.StrainingDisable.IsChecked = mode == Scenes.Main.Controls.StrainingDisable.Text:gsub('%s+', '')
    Scenes.Main.Controls.StrainingMatchYaw.IsChecked = mode ==
                                                           Scenes.Main.Controls.StrainingMatchYaw.Text:gsub('%s+', '')
    Scenes.Main.Controls.StrainingMatchAngle.IsChecked = mode ==
                                                             Scenes.Main.Controls.StrainingMatchAngle.Text:gsub('%s+',
            '')
    Scenes.Main.Controls.StrainingReverseAngle.IsChecked = mode ==
                                                               Scenes.Main.Controls.StrainingReverseAngle.Text:gsub(
            '%s+', '')
    Scenes.Main.Controls.AngleTextBox.IsReadOnly = Scenes.Main.Controls.StrainingMatchAngle.IsChecked == false
end

function InputDirection.SetGoalAngle(goalAngle)
    Broker.GoalAngle = goalAngle
    Scenes.Main.Controls.AngleTextBox.Text = tostring(goalAngle)
end

function InputDirection.SetGoalMag(goalMag)
    Broker.GoalMagnitude = goalMag
    Scenes.Main.Controls.Joystick.Magnitude = goalMag
    Scenes.Main.Controls.MagnitudeTextBox.Text = tostring(goalMag) -- CAREFUL! Type swap is scary, it can fuck up the entire control and cause cryptic error messages deep inside rendering/styling system
end

function InputDirection.SetBias(left, right)
    Broker.Left = left
    Broker.Right = right
    Scenes.Main.Controls.Left.IsChecked = Broker.Left
    Scenes.Main.Controls.Right.IsChecked = Broker.Right
end

function InputDirection.SetTargetStrain(targetStrain, always)
    Broker.Always = always
    Broker.TargetStrain = targetStrain

    if not Broker.TargetStrain then
        Broker.Always = false
    end

    Scenes.Main.Controls.StrainTo99.IsChecked = Broker.TargetStrain
    Scenes.Main.Controls.Always99.IsChecked = Broker.Always
end

function UserCodeOnInitialize()

    local mainScene = Scene:new()
    local settingsScene = Scene:new()
    local persistentScene = Scene:new()

    mainScene:AddControls({

        StrainingDisable = ToggleButton:new(mainScene, 0, nil, 5, 5, 127, 30, "Disabled", false, function(o)
            InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
        end),
        StrainingMatchYaw = ToggleButton:new(mainScene, 1, nil, 5, 5 + 35 * 1, 127, 30, " Match Yaw ", false,
            function(o)
                InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
            end),
        StrainingReverseAngle = ToggleButton:new(mainScene, 2, nil, 5, 5 + 35 * 2, 127, 30, "   Reverse Angle", false,
            function(o)
                InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
            end),
        StrainingMatchAngle = ToggleButton:new(mainScene, 3, nil, 5, 5 + 35 * 3, 127, 30, "Match Angle", false,
            function(o)
                InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
            end),
        Joystick = Joystick:new(mainScene, 4, 5, 145, 128, 128, true, function(o)

        end),

        Always99 = ToggleButton:new(mainScene, 5, nil, 137, 5, 54, 22, "Always", false, function(o)
            InputDirection.SetTargetStrain(Scenes.Main.Controls.StrainTo99.IsChecked, o.IsChecked)
        end),

        StrainTo99 = ToggleButton:new(mainScene, 6, nil, 195, 5, 29, 22, ".99", false, function(o)
            InputDirection.SetTargetStrain(o.IsChecked, Scenes.Main.Controls.Always99.IsChecked)
        end),
        Left = ToggleButton:new(mainScene, 7, nil, 137, 31, 39, 22, "    Left", false, function(o)
            InputDirection.SetBias(o.IsChecked, Scenes.Main.Controls.Right.IsChecked)
        end),
        Right = ToggleButton:new(mainScene, 8, nil, 180, 31, 44, 22, "   Right", false, function(o)
            InputDirection.SetBias(Scenes.Main.Controls.Left.IsChecked, o.IsChecked)
        end),
        DYaw = ToggleButton:new(mainScene, 9, nil, 137, 57, 87, 22, "DYaw", false, function(o)
            Broker.DYaw = o.IsChecked
        end),
        Swim = ToggleButton:new(mainScene, 10, nil, 137, 83, 87, 22, "Swim", false, function(o)
            Broker.Swimming = o.IsChecked
        end),
        AngleTextBox = TextBox:new(mainScene, 11, 138, 110, 85, 30, 5, false, true, function(o)
            if o.Text and o.Text:len() == 0 == false and tonumber(o.Text) then
                Broker.GoalAngle = tonumber(o.Text)
            end
        end),
        MagnitudeLabel = Label:new(mainScene, 12, 147, 144, "Magnitude"),
        MagnitudeTextBox = TextBox:new(mainScene, 13, 142, 163, 76, 23, 3, false, true, function(o)
            if o.Text and o.Text:len() == 0 == false and tonumber(o.Text) then
                InputDirection.SetGoalMag(Numeric.Clamp(tonumber(o.Text), 0, 127))
            end
        end),
        Speedkick = Button:new(mainScene, 14, nil, 142, 229, 76, 21, "Speedkick", function(o)
            InputDirection.SetGoalMag(48)
        end),
        ResetMagnitude = Button:new(mainScene, 15, "G", 142, 253, 76, 21, "Reset Mag.", function(o)
            InputDirection.SetGoalMag(127)
        end),

        LabelsStackPanel = StackPanel:new(mainScene, 16, 5,
            265 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE), 5, true, {
                YawFacing = Label:new(mainScene, 17, nil, nil, ""),
                YawIntended = Label:new(mainScene, 18, nil, nil, ""),
                OppositeFacing = Label:new(mainScene, 19, nil, nil, ""),
                OppositeIntended = Label:new(mainScene, 20, nil, nil, ""),
                HSpd = Label:new(mainScene, 21, nil, nil, ""),
                HSlidingSpd = Label:new(mainScene, 22, nil, nil, ""),
                XZMovement = Label:new(mainScene, 23, nil, nil, ""),
                SpdEfficiency = Label:new(mainScene, 24, nil, nil, ""),
                YSpd = Label:new(mainScene, 25, nil, nil, ""),
                X = Label:new(mainScene, 26, nil, nil, ""),
                Y = Label:new(mainScene, 27, nil, nil, ""),
                Z = Label:new(mainScene, 28, nil, nil, ""),
                Action = Label:new(mainScene, 29, nil, nil, ""),
                MovedDist = Label:new(mainScene, 30, nil, nil, "")
            })
    })
    settingsScene:AddControls({
        ThemeLabel = Label:new(settingsScene, 1, 5, 5, "Theme"),
        RendererLabel = Label:new(settingsScene, 2, 5, 30, "Renderer"),
        StylerLabel = Label:new(settingsScene, 3, 5, 55, "Styler"),

        Fuck = ComboBox:new(settingsScene, 4, 50, 5, 150, 20, {"Classic", "Dark", "DarkFlat", "Inverted"}, function(o)
            Appearance.SetTheme(o.Items[o.SelectedItemIndex])
        end),

        RendererBackendComboBox = ComboBox:new(settingsScene, 5, 70, 30, 120, 20, {"GDI", "GDI+", "Batched GDI"},
            function(o)
                -- when the GC pressure is high
                if o.Items[o.SelectedItemIndex] == "GDI" then
                    RendererManager.SetCurrentRenderer(GDIRenderer:new())
                end
                if o.Items[o.SelectedItemIndex] == "GDI+" then
                    RendererManager.SetCurrentRenderer(GDIPlusRenderer:new())
                end
                if o.Items[o.SelectedItemIndex] == "Batched GDI" then
                    RendererManager.SetCurrentRenderer(BatchedGDIRenderer:new())
                end
            end),
        StylerComboBox = ComboBox:new(settingsScene, 6, 70, 55, 120, 20, {"Windows 10", "Windows 3", "Flat", "3D", "Plastic"}, function(o)
            if o.Items[o.SelectedItemIndex] == "Windows 10" then
                StylerManager.SetCurrentStyler(Windows10Styler:new())
            end
            if o.Items[o.SelectedItemIndex] == "Windows 3" then
                StylerManager.SetCurrentStyler(Windows3Styler:new())
            end
            if o.Items[o.SelectedItemIndex] == "Flat" then
                StylerManager.SetCurrentStyler(FlatStyler:new())
            end
            if o.Items[o.SelectedItemIndex] == "3D" then
                StylerManager.SetCurrentStyler(DimensionalStyler:new())
            end
            if o.Items[o.SelectedItemIndex] == "Plastic" then
                StylerManager.SetCurrentStyler(PlasticStyler:new())
            end
        end),
        TestStackPanel = StackPanel:new(settingsScene, 7, 5, 90, 10, true, {
            -- LabelA = Label:new(settingsScene, nil, nil, "Dame tu"),
            -- LabelB = Label:new(settingsScene, nil, nil, "Cosita"),
            -- LabelC = Label:new(settingsScene, nil, nil, "Ah ah"),
            ButtonA = Button:new(settingsScene, 8, nil, nil, nil, 80, 20, "Button", nil, nil),
            ButtonB = Button:new(settingsScene, 9, nil, nil, nil, 80, 20, "Button", nil, nil),
            ButtonC = Button:new(settingsScene, 10, nil, nil, nil, 80, 20, "Button", nil, nil)
        })
    })
    persistentScene:AddControls({
        NavigationCarrouselButton = CarrouselButton:new(persistentScene, 1, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 10) * 10, Screen.ExpandedOffset / Screen.Dimensions.ScalingX - 10, 20, {"Main", "Settings"}, true, function(o)
            SceneManager.ChangeScene(Scenes[o.Items[o.SelectedItemIndex]])
        end),
        TestStackPanel = StackPanel:new(persistentScene, 2, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 10) * 12, 10, false, {
            ButtonA = Button:new(settingsScene, 3, nil, nil, nil, 66, 20, "Test", nil, nil),
            ButtonB = Button:new(settingsScene, 4, nil, nil, nil, 66, 20, "Test", nil, nil),
            ButtonC = Button:new(settingsScene, 5, nil, nil, nil, 66, 20, "Test", nil, nil)
        })
    })

    SceneManager.Initialize({
        Main = mainScene,   
        Settings = settingsScene
    }, persistentScene, GDIRenderer:new(), Windows10Styler:new())

    SceneManager.ChangeScene(Scenes.Main)

    InputDirection.SetStrainMode("Disabled")
    InputDirection.SetGoalAngle(0)
    InputDirection.SetGoalMag(127)
    InputDirection.SetBias(true, false)

    UserCodeAtInputPoll()

end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

