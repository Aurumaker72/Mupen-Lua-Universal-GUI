-- i put this shit together in 15 minutes before eating
InputDirection = {
    IsInitialized = false
}

FOLDER_INPUTDIRECTION = FOLDER_USER_CODE_SAMPLES .. "Input Direction Lua" .. "\\" .. "InputDirection" .. "\\"

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

    if InputDirection.IsInitialized then

        Scenes.Main.Controls.Joystick.ValueX = Joypad.input.X
        Scenes.Main.Controls.Joystick.ValueY = -Joypad.input.Y

        Scenes.Encoding.Controls.Joystick.ValueX = Joypad.input.X
        Scenes.Encoding.Controls.Joystick.ValueY = -Joypad.input.Y

        Scenes.Encoding.Controls.XSlider.Value = Joypad.input.X
        Scenes.Encoding.Controls.YSlider.Value = -Joypad.input.Y

        Scenes.Encoding.Controls.PrimaryStackPanel.Children.AButton:SetIsChecked(Joypad.input.A)
        Scenes.Encoding.Controls.PrimaryStackPanel.Children.BButton:SetIsChecked(Joypad.input.B)
        Scenes.Encoding.Controls.PrimaryStackPanel.Children.ZButton:SetIsChecked(Joypad.input.Z)
        Scenes.Encoding.Controls.TriggerStackPanel.Children.LButton:SetIsChecked(Joypad.input.L)
        Scenes.Encoding.Controls.TriggerStackPanel.Children.RButton:SetIsChecked(Joypad.input.R)

        Scenes.Encoding.Controls.XLabel.Text = "X " .. Joypad.input.X
        Scenes.Encoding.Controls.YLabel.Text = "Y " .. -Joypad.input.Y
        Scenes.Encoding.Controls.MLabel.Text = "M " ..
            math.floor(math.sqrt((0 - Joypad.input.X) ^ 2 + ((0 - -Joypad.input.Y) ^ 2)))

        Scenes.Main.Controls.LabelsStackPanel.Children.YawFacing.Text = "Yaw (Facing): " ..
            Engine.getEffectiveAngle(
                Memory.Mario.FacingYaw)
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

        local hSpdStr = "H Spd: " .. math.floor(speed, 2)
        local ySpdStr = "Y Spd: " .. math.floor(MoreMaths.DecodeDecToFloat(Memory.Mario.VSpeed), 2)
        local spdEfficiencyStr = "Spd Efficiency: " .. Engine.GetSpeedEfficiency() .. "%"
        local hSlidingSpeedStr = "H Sliding Spd: " .. MoreMaths.Round(Engine.GetHSlidingSpeed(), 6)
        local xStr = "X: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.X), 4)
        local yStr = "Y: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.Y), 4)
        local zStr = "Z: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.Z), 4)
        local xzMovementStr = "XZ Movement: " .. MoreMaths.Round(Engine.GetDistMoved(), 6)
        local actionStr = "Action: " .. (Engine.GetCurrentAction():gsub("^%l", string.upper))
        local movedDistStr = "Moved Dist: "
        if (Broker.DistanceMeasurement == false) then
            movedDistStr = movedDistStr .. Broker.DistanceMeasurementSaved
        else
            movedDistStr = movedDistStr .. Engine.GetTotalDistMoved()
        end

        Scenes.Main.Controls.LabelsStackPanel.Children.HSpd.Text = hSpdStr
        Scenes.Encoding.Controls.InformationStackPanel.Children.HSpd.Text = hSpdStr

        Scenes.Main.Controls.LabelsStackPanel.Children.YSpd.Text = ySpdStr
        Scenes.Encoding.Controls.InformationStackPanel.Children.YSpd.Text = ySpdStr

        Scenes.Main.Controls.LabelsStackPanel.Children.SpdEfficiency.Text = spdEfficiencyStr
        Scenes.Main.Controls.LabelsStackPanel.Children.HSlidingSpd.Text = hSlidingSpeedStr

        Scenes.Main.Controls.LabelsStackPanel.Children.Action.Text = actionStr
        Scenes.Encoding.Controls.InformationStackPanel.Children.Action.Text = actionStr


        Scenes.Main.Controls.LabelsStackPanel.Children.X.Text = xStr
        Scenes.Main.Controls.LabelsStackPanel.Children.Y.Text = yStr
        Scenes.Main.Controls.LabelsStackPanel.Children.Z.Text = zStr
        Scenes.Main.Controls.LabelsStackPanel.Children.XZMovement.Text = xzMovementStr
        Scenes.Main.Controls.LabelsStackPanel.Children.MovedDist.Text = movedDistStr
    end
end

function InputDirection.SetStrainMode(mode)
    Broker.SelectedItem = mode
    Scenes.Main.Controls.StrainingDisable:SetIsChecked(mode == Scenes.Main.Controls.StrainingDisable.Text:gsub('%s+', ''))
    Scenes.Main.Controls.StrainingMatchYaw:SetIsChecked(mode ==
        Scenes.Main.Controls.StrainingMatchYaw.Text:gsub('%s+', ''))
    Scenes.Main.Controls.StrainingMatchAngle:SetIsChecked(mode ==
        Scenes.Main.Controls.StrainingMatchAngle.Text:gsub('%s+',
            ''))
    Scenes.Main.Controls.StrainingReverseAngle:SetIsChecked(mode ==
        Scenes.Main.Controls.StrainingReverseAngle.Text:gsub(
            '%s+', ''))
    Scenes.Main.Controls.AngleTextBox:SetReadOnly(Scenes.Main.Controls.StrainingMatchAngle.IsChecked == false)
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
    Scenes.Main.Controls.Left:SetIsChecked(Broker.Left)
    Scenes.Main.Controls.Right:SetIsChecked(Broker.Right)
end

function InputDirection.SetTargetStrain(targetStrain, always)
    Broker.Always = always
    Broker.TargetStrain = targetStrain

    if not Broker.TargetStrain then
        Broker.Always = false
    end

    Scenes.Main.Controls.StrainTo99:SetIsChecked(Broker.TargetStrain)
    Scenes.Main.Controls.Always99:SetIsChecked(Broker.Always)
end

function UserCodeOnInitialize()

    RendererManager.SetCurrentRenderer(StandardRenderer:new())

    local mainScene = Scene:new()
    local encodingScene = Scene:new()
    local settingsScene = Scene:new()
    local persistentScene = Scene:new()


    mainScene:AddControls({

        StrainingDisable = ToggleButton:new(mainScene, 0, "I", 5, 5, 127, 30, "Disabled", false, function(o)
            InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
        end),
        StrainingMatchYaw = ToggleButton:new(mainScene, 1, "J", 5, 5 + 35 * 1, 127, 30, " Match Yaw ", false,
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
        Joystick = Joystick:new(mainScene, 4, 5, 145, 128, 128, false, function(o)

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
        Speedkick = Button:new(mainScene, 14, "R", 142, 229, 76, 21, "Speedkick", function(o)
            InputDirection.SetGoalMag(48)
        end),
        ResetMagnitude = Button:new(mainScene, 15, "G", 142, 253, 76, 21, "Reset Mag.", function(o)
            InputDirection.SetGoalMag(127)
        end),

        LabelsStackPanel = StackPanel:new(mainScene, 16, 5,
            265 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE), 5, {
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
            }, false)
    })

    encodingScene:AddControls({

        Joystick = Joystick:new(encodingScene, nil, (Screen.ExpandedOffset / Screen.Dimensions.ScalingX) / 2 - 128 / 2,
            10, 128, 128, true, function(o)

        end),
        XLabel = Label:new(encodingScene, nil, (Screen.ExpandedOffset / Screen.Dimensions.ScalingX) / 2 - 128 / 2,
            128 + 30, "X ?"),
        YLabel = Label:new(encodingScene, nil, (Screen.ExpandedOffset / Screen.Dimensions.ScalingX) / 2 + 128 / 4,
            128 + 30, "Y ?"),
        MLabel = Label:new(encodingScene, nil,
            (Screen.ExpandedOffset / Screen.Dimensions.ScalingX) / 2 + 128 / 4 - 64 / 2 - 16,
            128 + 30, "M ?"),
        XSlider = Slider:new(encodingScene, nil, (Screen.ExpandedOffset / Screen.Dimensions.ScalingX) / 2 - 128 / 2,
            128 + 10 + 5, 128, 20, 0, -128, 127, true, false, nil),
        YSlider = Slider:new(encodingScene, nil,
            (Screen.ExpandedOffset / Screen.Dimensions.ScalingX) / 2 - 128 / 2 + 128 + 5, 10, 20, 128, 0, 128, -127,
            false, false, nil),
        PrimaryStackPanel = StackPanel:new(encodingScene, nil, 45, 128 + 60, 128 / 3 / 2, {
            AButton = ToggleButton:new(encodingScene, 1, nil, nil, nil, 32, 32, "A", false),
            BButton = ToggleButton:new(encodingScene, 2, nil, nil, nil, 32, 32, "B", false),
            ZButton = ToggleButton:new(encodingScene, 3, nil, nil, nil, 32, 32, "Z", false)
        }, true),
        TriggerStackPanel = StackPanel:new(encodingScene, nil, 45, 128 + 60 + 32 + 10, 10, {
            LButton = ToggleButton:new(encodingScene, 4, nil, nil, nil, 128 / 2, 32, "L", false),
            RButton = ToggleButton:new(encodingScene, 5, nil, nil, nil, 128 / 2, 32, "R", false)
        }, true),
        InformationStackPanel = StackPanel:new(encodingScene, nil, 45, 128 + 60 + 32 + 50, 10, {
            Action = Label:new(encodingScene, 6, nil, nil, ""),
            HSpd = Label:new(encodingScene, 7, nil, nil, ""),
            YSpd = Label:new(encodingScene, 8, nil, nil, ""),
        }, false)
    })

    settingsScene:AddControls({
        ThemeLabel = Label:new(settingsScene, 1, 5, 5, "Theme"),
        RendererLabel = Label:new(settingsScene, 2, 5, 30, "Renderer"),
        StylerLabel = Label:new(settingsScene, 3, 5, 55, "Styler"),

        Fuck = ComboBox:new(settingsScene, 4, 50, 5, 150, 20, { "Classic", "Dark", "DarkFlat", "DarkMica", "Inverted" },
            function(o)
                Appearance.SetTheme(o.Items[o.SelectedItemIndex])
            end),
        FuckTextBox = TextBox:new(settingsScene, 11, 138, 110, 85, 30, nil, false, false, function(o)
        end),
        FuckTestA = Button:new(settingsScene, 14, nil, 132, 229, 76, 21, "Text A", function(o)
            print(o.Text)
        end),
        FuckTestB = Button:new(settingsScene, 14, nil, 140, 239, 76, 21, "Text B", function(o)
            print(o.Text)
        end),
        RendererBackendComboBox = ComboBox:new(settingsScene, 5, 70, 30, 120, 20, { "Standard", "Pure GDI+" },
            function(o)
                -- when the GC pressure is high
                if o.Items[o.SelectedItemIndex] == "Standard" then
                    RendererManager.SetCurrentRenderer(StandardRenderer:new())
                end
                if o.Items[o.SelectedItemIndex] == "Pure GDI+" then
                    RendererManager.SetCurrentRenderer(GDIPlusRenderer:new())
                end
            end),
        StylerComboBox = ComboBox:new(settingsScene, 6, 70, 55, 120, 20,
            { "Windows 11", "Windows 10", "Windows 3", "Plastic" }, function(o)
            if o.Items[o.SelectedItemIndex] == "Windows 10" then
                StylerManager.SetCurrentStyler(Windows10Styler:new())
            end
            if o.Items[o.SelectedItemIndex] == "Windows 11" then
                StylerManager.SetCurrentStyler(Windows11Styler:new())
            end
            if o.Items[o.SelectedItemIndex] == "Windows 3" then
                StylerManager.SetCurrentStyler(Windows3Styler:new())
            end
            if o.Items[o.SelectedItemIndex] == "Plastic" then
                StylerManager.SetCurrentStyler(PlasticStyler:new())
            end
        end),
        -- TestStackPanel = StackPanel:new(settingsScene, 7, 5, 90, 10, {
        --     -- LabelA = Label:new(settingsScene, nil, nil, "Dame tu"),
        --     -- LabelB = Label:new(settingsScene, nil, nil, "Cosita"),
        --     -- LabelC = Label:new(settingsScene, nil, nil, "Ah ah"),
        --     ButtonA = Button:new(settingsScene, 8, nil, nil, nil, 80, 20, "Button", nil, nil),
        --     ButtonB = Button:new(settingsScene, 9, nil, nil, nil, 80, 20, "Button", nil, nil),
        --     ButtonC = Button:new(settingsScene, 10, nil, nil, nil, 80, 20, "Button", nil, nil),
        --     SliderA = Slider:new(settingsScene, 11, nil, nil, 20, 80, 0, 0, 100, false, false, function(o)
        --         print(o.Value)
        --     end)
        -- }, false),
        -- OverlappingButtonA = Button:new(settingsScene, nil, nil, 90, 120, 80, 20, "First", nil, nil),
        -- OverlappingButtonB = Button:new(settingsScene, nil, nil, 110, 130, 80, 20, "Second", nil, nil),
    })
    persistentScene:AddControls({
        NavigationCarrouselButton = CarrouselButton:new(persistentScene, 1, 5, 290 +
            (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 10) * 10,
            Screen.ExpandedOffset / Screen.Dimensions.ScalingX - 10, 20, { "Main", "Encoding", "Settings" }, true,
            function(o)
                SceneManager.ChangeScene(Scenes[o.Items[o.SelectedItemIndex]])
            end),
        -- TestStackPanel = StackPanel:new(persistentScene, 2, 5,
        --     290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 10) * 12, 10, {
        --         ButtonA = Button:new(settingsScene, 3, nil, nil, nil, 66, 20, "Test", nil, nil),
        --         ButtonB = Button:new(settingsScene, 4, nil, nil, nil, 66, 20, "Test", nil, nil),
        --         ButtonC = Button:new(settingsScene, 5, nil, nil, nil, 66, 20, "Test", nil, nil)
        --     }, true)
    })

    SceneManager.Initialize({
        Main = mainScene,
        Encoding = encodingScene,
        Settings = settingsScene
    }, persistentScene)

    SceneManager.ChangeScene(Scenes.Main)

    InputDirection.IsInitialized = true

    InputDirection.SetStrainMode("Disabled")
    InputDirection.SetGoalAngle(0)
    InputDirection.SetGoalMag(127)
    InputDirection.SetBias(true, false)

    UserCodeAtInputPoll()

    StylerManager.SetCurrentStyler(Windows11Styler:new())
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end
