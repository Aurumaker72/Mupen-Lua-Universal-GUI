-- example for how to write your code
-- DO NOT modify or interact with anything beyond Main.lua, Appearance.lua, Keyboard.lua, Mouse.lua or SceneManager.lua
-- DO write controls and scenes here, mutate state, etc...
-- btw this code sucks but it's just an example
FOLDER_INPUTDIRECTION = AbsolutePathToCurrentFolder() .. "InputDirection" .. "\\"
-- dofile(FOLDER_INPUTDIRECTION .. "")

InputDirection = {}

function InputDirection.SetStrainMode(mode)
    InputDirection.StrainMode = mode
    Scenes.Main.Controls.StrainingDisable.IsChecked = InputDirection.StrainMode == Scenes.Main.Controls.StrainingDisable.Text
    Scenes.Main.Controls.StrainingMatchYaw.IsChecked = InputDirection.StrainMode == Scenes.Main.Controls.StrainingMatchYaw.Text
    Scenes.Main.Controls.StrainingReverseAngle.IsChecked = InputDirection.StrainMode == Scenes.Main.Controls.StrainingReverseAngle.Text
    Scenes.Main.Controls.StrainingMatchAngle.IsChecked = InputDirection.StrainMode == Scenes.Main.Controls.StrainingMatchAngle.Text
    Scenes.Main.Controls.AngleTextBox.IsReadOnly = Scenes.Main.Controls.StrainingMatchAngle.IsChecked == false
end

function UserCodeAtInputPoll()
    local controller = joypad.get(1)
    controller.Y = -controller.Y
    Scenes.Main.Controls.Joystick.ValueX = controller.X
    Scenes.Main.Controls.XLabel.Text = "X: " ..controller.X
    Scenes.Main.Controls.Joystick.ValueY = controller.Y
    Scenes.Main.Controls.YLabel.Text = "Y: " .. controller.Y
    Scenes.Main.Controls.Joystick.Magnitude = math.sqrt( math.max(0, math.abs(controller.X)) ^ 2 + math.max(0, math.abs(controller.Y) ) ^ 2)

end

function UserCodeOnInitialize()

    local mainScene = Scene:new(nil)
    local settingsScene = Scene:new(nil)

    mainScene:AddControls({

        StrainingDisable = ToggleButton:new(mainScene, "M", 5, 5, 126, 30, "Disabled", false, function(o)
            InputDirection.SetStrainMode(o.Text)
        end),
        StrainingMatchYaw = ToggleButton:new(mainScene, "Y", 5, 5 + 35 * 1, 126, 30, " Match Yaw ", false, function(o)
            InputDirection.SetStrainMode(o.Text)
        end),
        StrainingReverseAngle = ToggleButton:new(mainScene, "R", 5, 5 + 35 * 2, 126, 30, "   Reverse Angle", false, function(o)
            InputDirection.SetStrainMode(o.Text)
        end),
        StrainingMatchAngle = ToggleButton:new(mainScene, "A", 5, 5 + 35 * 3, 126, 30, "Match Angle", false, function(o)
            InputDirection.SetStrainMode(o.Text)
        end),
        Joystick = Joystick:new(mainScene, 5, 5 + 35 * 4, 128, 128, true, function(o)

        end),

        Always99 = ToggleButton:new(mainScene, "N", 136, 5, 55, 22, "Always", false, function(o)
            if Scenes.Main.Controls.StrainTo99.IsChecked then
                InputDirection.SpeedTrickMode = "Always"
            else
                o.IsChecked = false
                InputDirection.SpeedTrickMode = "None"
            end
        end),

        StrainTo99 = ToggleButton:new(mainScene, "S", 194, 5, 29, 22, ".99", false, function(o)
            if o.IsChecked == false then
                Scenes.Main.Controls.Always99.IsChecked = false
                InputDirection.SpeedTrickMode = "None"
            end
        end),
        Left = ToggleButton:new(mainScene, nil, 136, 31, 40, 22, "    Left", false, function(o)

        end),
        Right = ToggleButton:new(mainScene, nil, 179, 31, 44, 22, "   Right", false, function(o)

        end),
        DYaw = ToggleButton:new(mainScene, nil, 136, 57, 87, 22, "DYaw", false, function(o)

        end),
        Swim = ToggleButton:new(mainScene, nil, 136, 83, 87, 22, "Swim", false, function(o)

        end),
        AngleTextBox = TextBox:new(mainScene, 137, 110, 85, 30, 5, false, true, function(o)

        end),
        MagnitudeLabel = Label:new(mainScene, 148, 144, "Magnitude"),
        MagnitudeTextBox = TextBox:new(mainScene, 141, 163, 75, 23, 3, false, true, function(o)

        end),
        XLabel = Label:new(mainScene, 148, 194, "X: "),
        YLabel = Label:new(mainScene, 147, 211, "Y: "),
        Speedkick = ToggleButton:new(mainScene, nil, 141, 235, 76, 21, "Speedkick", false, function(o)

        end),
        ResetMagnitude = Button:new(mainScene, "G", 141, 260, 76, 21, "Reset Mag.", function(o)

        end),
        ParameterDumpLabel1 = Label:new(mainScene, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 5) * 1, "some value"),
        ParameterDumpLabel2 = Label:new(mainScene, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 5) * 2, "some value"),
        ParameterDumpLabel3 = Label:new(mainScene, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 5) * 3, "some value"),
        ParameterDumpLabel4 = Label:new(mainScene, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 5) * 4, "some value"),
        ParameterDumpLabel5 = Label:new(mainScene, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 5) * 5, "some value"),
        ParameterDumpLabel6 = Label:new(mainScene, 5, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 5) * 6, "some value"),
        SwitchScene = Button:new(mainScene, nil, 141, 300, 76, 21, "settings", function(o)
            print("Changing to Settings")
            SceneManager.ChangeScene("Settings")
        end),
        Test2 = Slider:new(mainScene, 141, 340, 76, 21, 0, 0, 5, false, false, function(o)
            print(o.Value)
        end),
        
    })

    settingsScene:AddControls({
        RendererLabel = Label:new(settingsScene, 5, 30, "Renderer"),
        ThemeLabel = Label:new(settingsScene, 5, 5, "Theme"),

        SwitchScene = Button:new(settingsScene, nil, 141, 300, 76, 21, "home", function(o)
            print("Changing to Main")
            SceneManager.ChangeScene("Main")
        end),
        Fuck = ComboBox:new(settingsScene, 50, 5, 150, 20, {"Classic", "Dark", "Inverted", "DarkFlat"}, function(o)
            Appearance.SetTheme(o.Items[o.SelectedItemIndex])
        end),
        
        RendererBackendComboBox = ComboBox:new(settingsScene, 70, 30, 120, 20, {"GDI", "GDI+" }, function(o)
            -- when the GC pressure is high
            if o.Items[o.SelectedItemIndex] == "GDI" then
                CurrentRenderer = GDIRenderer:new()
            end
            if o.Items[o.SelectedItemIndex] == "GDI+" then
                CurrentRenderer = GDIPlusRenderer:new()
            end
        end),
        Test39 = CarrouselButton:new(mainScene, 40, 200, 140, 20, {"a", "b", "c", "d"}, true, function(o)
            
        end)
    })

    SceneManager.Initialize({
        Main = mainScene,
        Settings = settingsScene,
    },
    {
    NavigationCarrouselButton = CarrouselButton:new(mainScene, 0, 290 + (Appearance.Themes[Appearance.CurrentTheme].FONT_SIZE + 10) * 9, Screen.ExpandedOffset / Screen.Dimensions.ScalingX, 20, {"Main", "Settings"}, true, function(o)
        SceneManager.ChangeScene(o.Items[o.SelectedItemIndex])
    end)
    },
    GDIRenderer:new())
    
    
    CurrentScene = Scenes.Main
    CurrentScene.IsActive = true

    --InputDirection.SetStrainMode(Scenes.Main.Controls.StrainingDisable.Text)

    UserCodeAtInputPoll()
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

