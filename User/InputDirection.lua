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
            
            StrainingDisable = ToggleButton:new(5, 5, 126, 30, "Disabled", false, function(o)
                InputDirection.SetStrainMode(o.Text)
            end),
          StrainingMatchYaw = ToggleButton:new(5, 5 + 35 * 1, 126, 30, " Match Yaw ", false, function(o)
              InputDirection.SetStrainMode(o.Text)
          end),
          StrainingReverseAngle = ToggleButton:new(5, 5 + 35 * 2, 126, 30, "   Reverse Angle", false, function(o)
              InputDirection.SetStrainMode(o.Text)
          end),
          StrainingMatchAngle = ToggleButton:new(5, 5 + 35 * 3, 126, 30, "Match Angle", false, function(o)
              InputDirection.SetStrainMode(o.Text)
          end),
          Joystick = Joystick:new(5, 5 + 35 * 4, 128, 128, true, function(o)
           
          end),

          Always99 = ToggleButton:new(136, 5, 55, 22, "Always", false, function(o)
              if Scenes.Main.Controls.StrainTo99.IsChecked then
                  InputDirection.SpeedTrickMode = "Always"
              else
                  o.IsChecked = false
                  InputDirection.SpeedTrickMode = "None"
              end
          end),
     
          StrainTo99 = ToggleButton:new(194, 5, 29, 22, ".99", false, function(o)
              if o.IsChecked == false then
                  Scenes.Main.Controls.Always99.IsChecked = false
                  InputDirection.SpeedTrickMode = "None"
              end
          end),
          Left = ToggleButton:new(136, 31, 40, 22, "    Left", false, function(o)
           
          end),
          Right = ToggleButton:new(179, 31, 44, 22, "   Right", false, function(o)
           
          end),
          DYaw = ToggleButton:new(136, 57, 87, 22, "    DYaw  ", false, function(o)
           
          end),
          Swim = ToggleButton:new(136, 83, 87, 22, " Swim ", false, function(o)
           
          end),
          AngleTextBox = TextBox:new(137, 110, 85, 30, 5, false, true, function(o)
           
          end),
          MagnitudeLabel = Label:new(148, 144, "Magnitude"),
          MagnitudeTextBox = TextBox:new(141, 163, 75, 23, 3, false, true, function(o)
           
          end),
          XLabel = Label:new(148, 194, "X: "),
          YLabel = Label:new(147, 211, "Y: "),
          Speedkick = ToggleButton:new(141, 235, 76, 21, "Speedkick", false, function(o)
           
          end),
          ResetMagnitude = Button:new(141, 260, 76, 21, " Reset Mag.", function(o)
           
          end),

          ParameterDumpLabel1 = Label:new(5, 290 + (FONT_SIZE + 5) * 1, "some value"),
          ParameterDumpLabel2 = Label:new(5, 290 + (FONT_SIZE + 5) * 2, "some value"),
          ParameterDumpLabel3 = Label:new(5, 290 + (FONT_SIZE + 5) * 3, "some value"),
          ParameterDumpLabel4 = Label:new(5, 290 + (FONT_SIZE + 5) * 4, "some value"),
          ParameterDumpLabel5 = Label:new(5, 290 + (FONT_SIZE + 5) * 5, "some value"),
          ParameterDumpLabel6 = Label:new(5, 290 + (FONT_SIZE + 5) * 6, "some value"),
          
          
        }),
        
        Settings = Scene:new({
            Fuck = ComboBox:new(5, 5, 180, 20, {"Classic", "Dark", "Inverted"}, function(o)
                Appearance.SetTheme(o.Items[o.SelectedItemIndex])
            end),
        }),
    })
    PersistentControls = {
        NavigationCarrouselButton = CarrouselButton:new(0, 290 + (FONT_SIZE + 10) * 9, Screen.ExpandedOffset / Screen.Dimensions.ScalingX, 20, {"Main", "Settings"}, true, function(o)
            SceneManager.ChangeScene(o.Items[o.SelectedItemIndex])
        end),
    }

    CurrentScene = Scenes.Main
    CurrentScene.IsActive = true

    InputDirection.SetStrainMode(Scenes.Main.Controls.StrainingDisable.Text)

    UserCodeAtInputPoll()
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end


