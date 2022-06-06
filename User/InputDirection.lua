-- example for how to write your code
-- DO NOT modify or interact with anything beyond Main.lua, Appearance.lua, Keyboard.lua, Mouse.lua or SceneManager.lua
-- DO write controls and scenes here, mutate state, etc...
-- btw this code sucks but it's just an example

FOLDER_INPUTDIRECTION = AbsolutePathToCurrentFolder() .. "InputDirection" .. "\\"
--dofile(FOLDER_INPUTDIRECTION .. "")

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

    

end

function UserCodeOnInitialize()

    SceneManager.Initialize({

        Main = Scene:new({
            
            StrainingDisable = ToggleButton:new(5, 5, 120, 30, "Disabled", false, function(o)
                InputDirection.SetStrainMode(o.Text)
            end),
            StrainingMatchYaw = ToggleButton:new(5, 5 + 35 * 1, 120, 30, "Match Yaw", false, function(o)
                InputDirection.SetStrainMode(o.Text)
            end),
            StrainingReverseAngle = ToggleButton:new(5, 5 + 35 * 2, 120, 30, "Reverse Angle", false, function(o)
                InputDirection.SetStrainMode(o.Text)
            end),
            StrainingMatchAngle = ToggleButton:new(5, 5 + 35 * 3, 120, 30, "Match Angle", false, function(o)
                InputDirection.SetStrainMode(o.Text)
            end),
            Joystick = Joystick:new(5, 5 + 35 * 4, 128, 128, true, function(o)
                
            end),

            Always99 = ToggleButton:new(129, 5, 56, 22, "Always", false, function(o)
                if Scenes.Main.Controls.StrainTo99.IsChecked then
                    InputDirection.SpeedTrickMode = "Always"
                else
                    o.IsChecked = false
                    InputDirection.SpeedTrickMode = "None"
                end
            end),
            
            StrainTo99 = ToggleButton:new(188, 5, 32, 22, ".99", false, function(o)
                if o.IsChecked == false then
                    Scenes.Main.Controls.Always99.IsChecked = false
                    InputDirection.SpeedTrickMode = "None"
                end
            end),
            Left = ToggleButton:new(130, 31, 40, 22, "Left", false, function(o)
                
            end),
            Right = ToggleButton:new(173, 31, 47, 22, "Right", false, function(o)
                
            end),
            DYaw = ToggleButton:new(130, 57, 87, 22, "DYaw", false, function(o)
                
            end),
            Swim = ToggleButton:new(130, 83, 87, 22, "Swim", false, function(o)
                
            end),
            AngleTextBox = TextBox:new(131, 110, 85, 30, 5, false, true, function(o)
                
            end),
            MagnitudeLabel = Label:new(146, 146, "Magnitude"),
            MagnitudeTextBox = TextBox:new(140, 165, 75, 25, 3, false, true, function(o)
                
            end),
            XLabel = Label:new(146, 200, "X: "),
            YLabel = Label:new(146, 220, "Y: "),
            Speedkick = ToggleButton:new(134, 240, 85, 22, "Speedkick", false, function(o)
                
            end),
            ResetMagnitude = Button:new(134, 265, 85, 22, "Reset Mag.", function(o)
                
            end),

            ParameterDumpLabel1 = Label:new(5, 290 + (FONT_SIZE + 5) * 1, "some value"),
            ParameterDumpLabel2 = Label:new(5, 290 + (FONT_SIZE + 5) * 2, "some value"),
            ParameterDumpLabel3 = Label:new(5, 290 + (FONT_SIZE + 5) * 3, "some value"),
            ParameterDumpLabel4 = Label:new(5, 290 + (FONT_SIZE + 5) * 4, "some value"),
            ParameterDumpLabel5 = Label:new(5, 290 + (FONT_SIZE + 5) * 5, "some value"),
            ParameterDumpLabel6 = Label:new(5, 290 + (FONT_SIZE + 5) * 6, "some value"),
            Fuck = ComboBox:new(5, 290 + (FONT_SIZE + 10) * 7, 180, 20, {"Classic", "Dark", "Inverted"}, function(o)
                Appearance.SetTheme(o.Items[o.SelectedItemIndex])
            end),

        }),

    }, {
        
    })

    CurrentScene = Scenes.Main
    CurrentScene.IsActive = true

    InputDirection.SetStrainMode(Scenes.Main.Controls.StrainingDisable.Text)

    UserCodeAtInputPoll()
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

