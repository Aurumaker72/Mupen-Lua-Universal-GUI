-- NOTE: this breaks everything mentioned in the arhitecture README section
-- i put this shit together in 15 minutes before eating
InputDirection = {}

FOLDER_INPUTDIRECTION = FOLDER_USER_CODE .. "InputDirection" .. "\\"
print(FOLDER_INPUTDIRECTION)

dofile(FOLDER_INPUTDIRECTION .. "Memory.lua")
dofile(FOLDER_INPUTDIRECTION .. "Settings.lua")
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

    Scenes.Main.Controls.YawFacing.Text = "Yaw (Facing): " .. Engine.getEffectiveAngle(Memory.Mario.FacingYaw)
    Scenes.Main.Controls.YawIntended.Text = "Yaw (Intended): " .. Engine.getEffectiveAngle(Memory.Mario.IntendedYaw)
    Scenes.Main.Controls.OppositeFacing.Text = "Opposite (Intended): " .. (Engine.getEffectiveAngle(Memory.Mario.FacingYaw) + 32768) % 65536
    Scenes.Main.Controls.OppositeIntended.Text = "Opposite (Intended): " .. (Engine.getEffectiveAngle(Memory.Mario.IntendedYaw) + 32768) % 65536

    local speed = 0
	if Memory.Mario.HSpeed ~= 0 then
		speed = MoreMaths.DecodeDecToFloat(Memory.Mario.HSpeed)
	end

	Scenes.Main.Controls.HSpd.Text = "H Spd: " .. MoreMaths.Round(speed, 5)
	Scenes.Main.Controls.SpdEfficiency.Text = "Spd Efficiency: " .. Engine.GetSpeedEfficiency() .. "%"

    speed = 0
	if Memory.Mario.VSpeed > 0 then
		speed = MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.VSpeed), 6)
	end
	Scenes.Main.Controls.YSpd.Text = "Y Spd: " .. MoreMaths.Round(speed, 5)

	Scenes.Main.Controls.HSlidingSpd.Text = "H Sliding Spd: " .. MoreMaths.Round(Engine.GetHSlidingSpeed(), 6)
	Scenes.Main.Controls.X.Text = "Mario X: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.X), 2)
	Scenes.Main.Controls.Y.Text = "Mario Y: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.Y), 2)
	Scenes.Main.Controls.Z.Text = "Mario Z: " .. MoreMaths.Round(MoreMaths.DecodeDecToFloat(Memory.Mario.Z), 2)
	Scenes.Main.Controls.XZMovement.Text = "XZ Movement: " .. MoreMaths.Round(Engine.GetDistMoved(), 6)
	Scenes.Main.Controls.Action.Text = "Action: " .. Engine.GetCurrentAction()
    
    local distmoved = Engine.GetTotalDistMoved()
	if (Settings.DistanceMeasurement == false) then
		distmoved = Settings.DistanceMeasurementSaved
	end
	Scenes.Main.Controls.MovedDist.Text = "Moved Dist: " .. distmoved

end

function InputDirection.SetStrainMode(mode)
    Settings.SelectedItem = mode
    Scenes.Main.Controls.StrainingDisable.IsChecked = mode == Scenes.Main.Controls.StrainingDisable.Text:gsub('%s+', '')
    Scenes.Main.Controls.StrainingMatchYaw.IsChecked = mode ==
                                                           Scenes.Main.Controls.StrainingMatchYaw.Text:gsub('%s+', '')
    Scenes.Main.Controls.StrainingMatchAngle.IsChecked = mode ==
                                                             Scenes.Main.Controls.StrainingMatchAngle.Text:gsub('%s+',
            '')
    Scenes.Main.Controls.StrainingReverseAngle.IsChecked = mode ==
                                                               Scenes.Main.Controls.StrainingReverseAngle.Text:gsub(
            '%s+', '')
end

function InputDirection.SetGoalMag(goalMag)
    Settings.goalMag = goalMag
    Scenes.Main.Controls.Joystick.Magnitude = goalMag
    Scenes.Main.Controls.MagnitudeTextBox.Text = tostring(goalMag) -- CAREFUL! Type swap scary
end

function InputDirection.SetBias(left, right)
    Settings.Left = left
    Settings.Right = right
    Scenes.Main.Controls.Left.IsChecked = Settings.Left
    Scenes.Main.Controls.Right.IsChecked = Settings.Right
end

function InputDirection.SetTargetStrain(targetStrain, always)
    Settings.Always = always
    Settings.TargetStrain = targetStrain

    if not Settings.TargetStrain then
        Settings.Always = false
    end

    Scenes.Main.Controls.StrainTo99.IsChecked = Settings.TargetStrain
    Scenes.Main.Controls.Always99.IsChecked = Settings.Always
end

function UserCodeOnInitialize()

    local mainScene = Scene:new(nil)
    local settingsScene = Scene:new(nil)

    mainScene:AddControls({

        StrainingDisable = ToggleButton:new(mainScene, nil, 5, 5, 127, 30, "Disabled", false, function(o)
            InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
        end),
        StrainingMatchYaw = ToggleButton:new(mainScene, nil, 5, 5 + 35 * 1, 127, 30, " Match Yaw ", false, function(o)
            InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
        end),
        StrainingReverseAngle = ToggleButton:new(mainScene, nil, 5, 5 + 35 * 2, 127, 30, "   Reverse Angle", false,
            function(o)
                InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
            end),
        StrainingMatchAngle = ToggleButton:new(mainScene, nil, 5, 5 + 35 * 3, 127, 30, "Match Angle", false, function(o)
            InputDirection.SetStrainMode(o.Text:gsub('%s+', ''))
        end),
        Joystick = Joystick:new(mainScene, 5, 145, 128, 128, true, function(o)

        end),

        Always99 = ToggleButton:new(mainScene, nil, 137, 5, 54, 22, "Always", false, function(o)
            InputDirection.SetTargetStrain(Scenes.Main.Controls.StrainTo99.IsChecked, o.IsChecked)
        end),

        StrainTo99 = ToggleButton:new(mainScene, nil, 195, 5, 29, 22, ".99", false, function(o)
            InputDirection.SetTargetStrain(o.IsChecked, Scenes.Main.Controls.Always99.IsChecked)
        end),
        Left = ToggleButton:new(mainScene, nil, 137, 31, 39, 22, "    Left", false, function(o)
            InputDirection.SetBias(o.IsChecked, Scenes.Main.Controls.Right.IsChecked)
        end),
        Right = ToggleButton:new(mainScene, nil, 180, 31, 44, 22, "   Right", false, function(o)
            InputDirection.SetBias(Scenes.Main.Controls.Left.IsChecked, o.IsChecked)
        end),
        DYaw = ToggleButton:new(mainScene, nil, 137, 57, 87, 22, "DYaw", false, function(o)
            Settings.DYaw = o.IsChecked
        end),
        Swim = ToggleButton:new(mainScene, nil, 137, 83, 87, 22, "Swim", false, function(o)
            Settings.Swimming = o.IsChecked
        end),
        AngleTextBox = TextBox:new(mainScene, 138, 110, 85, 30, 5, false, true, function(o)
            if not (o.Text == "" or o.Text:find("%D")) then
                Settings.goalAngle = tonumber(o.Text)
            end
        end),
        MagnitudeLabel = Label:new(mainScene, 147, 144, "Magnitude"),
        MagnitudeTextBox = TextBox:new(mainScene, 142, 163, 76, 23, 3, false, true, function(o)
            if not (o.Text == "" or o.Text:find("%D")) then
                InputDirection.SetGoalMag(tonumber(o.Text))
            end
        end),
        Speedkick = Button:new(mainScene, nil, 142, 253 - 21 - 3, 76, 21, "Speedkick", function(o)
            InputDirection.SetGoalMag(48)
        end),
        ResetMagnitude = Button:new(mainScene, "G", 142, 253, 76, 21, "Reset Mag.", function(o)
            InputDirection.SetGoalMag(127)
        end),
        YawFacing =         Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 1,  ""),
        YawIntended =       Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 2,  ""),
        OppositeFacing =    Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 3,  ""),
        OppositeIntended =  Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 4,  ""),
        HSpd =              Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 5,  ""),
        HSlidingSpd =       Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 6,  ""),
        XZMovement =        Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 7,  ""),
        SpdEfficiency =     Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 8,  ""),
        YSpd =              Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 9,  ""),
        X =                 Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 10, ""),
        Y =                 Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 11, ""),
        Z =                 Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 12, ""),
        Action =            Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 13, ""),
        MovedDist =         Label:new(mainScene, 5, 265-15 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE) + 15 * 14, ""),
    })

    settingsScene:AddControls({
        RendererLabel = Label:new(settingsScene, 5, 30, "Renderer"),
        ThemeLabel = Label:new(settingsScene, 5, 5, "Theme"),

        Fuck = ComboBox:new(settingsScene, 50, 5, 150, 20, {"Classic", "Dark", "DarkFlat", "Inverted"}, function(o)
            Appearance.SetTheme(o.Items[o.SelectedItemIndex])
        end),

        RendererBackendComboBox = ComboBox:new(settingsScene, 70, 30, 120, 20, {"GDI", "GDI+"}, function(o)
            -- when the GC pressure is high
            if o.Items[o.SelectedItemIndex] == "GDI" then
                RendererManager.SetCurrentRenderer(GDIRenderer:new())
            end
            if o.Items[o.SelectedItemIndex] == "GDI+" then
                RendererManager.SetCurrentRenderer(GDIPlusRenderer:new())
            end
        end)
    })

    SceneManager.Initialize({
        Main = mainScene,
        Settings = settingsScene
    }, {
        NavigationCarrouselButton = CarrouselButton:new(mainScene, 5, 290 +
            (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 10) * 10,
            Screen.ExpandedOffset / Screen.Dimensions.ScalingX - 10, 20, {"Main", "Settings"}, true, function(o)
                SceneManager.ChangeScene(o.Items[o.SelectedItemIndex])
            end)
    }, GDIRenderer:new())

    CurrentScene = Scenes.Main
    CurrentScene.IsActive = true

    InputDirection.SetStrainMode("Disabled")
    InputDirection.SetGoalMag(127)
    InputDirection.SetBias(true, false)

    UserCodeAtInputPoll()

end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

