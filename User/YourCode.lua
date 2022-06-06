-- example for how to write your code
-- DO NOT modify or interact with anything beyond Main.lua, Appearance.lua, Keyboard.lua, Mouse.lua or SceneManager.lua
-- DO write controls and scenes here, mutate state, etc...
-- btw this code sucks but it's just an example
YourCode = {}

function UserCodeAtInputPoll()

    YourCode.JoystickX = joypad.get().X
    YourCode.JoystickY = -joypad.get().Y
    Scenes["Home"].Controls["MainJoystick"].ValueX = YourCode.JoystickX
    Scenes["Home"].Controls["MainJoystick"].ValueY = YourCode.JoystickY

    Scenes["Home"].Controls["XSlider"].Value = YourCode.JoystickX
    Scenes["Home"].Controls["XLabel"].Text = "X: " .. YourCode.JoystickX

    Scenes["Home"].Controls["YSlider"].Value = YourCode.JoystickY
    Scenes["Home"].Controls["YLabel"].Text = "Y: " .. YourCode.JoystickY

end

function UserCodeOnInitialize()

    SceneManager.Initialize({

        -- "Home" is your 1st scene
        -- that one
        Home = Scene:new({ -- scene controls

            TestButton = Button:new(20, 400, 100, 90, "Hi!", function(sender)
                print("HI")
            end),

            MainJoystick = Joystick:new(HORIZONTAL_SAFE_ZONE + 33, VERTICAL_SAFE_ZONE + 40, 128, 128, true,
                function(sender)

                end),
            XSlider = Slider:new(HORIZONTAL_SAFE_ZONE + 60, VERTICAL_SAFE_ZONE * 3 + 128, 128, 30, 0, -128, 127, true,
                true, function(sender)

                end),
            XLabel = Label:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 3 + 133, 128, 30, ""),

            YSlider = Slider:new(HORIZONTAL_SAFE_ZONE + 60, VERTICAL_SAFE_ZONE * 4 + 128, 128, 30, 0, -128, 127, true,
                true, function(sender)

                end),
            YLabel = Label:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 4 + 133, 128, 30, "")

        }),
        Settings = Scene:new({
            FuckThisShit = ComboBox:new(HORIZONTAL_SAFE_ZONE + 20, VERTICAL_SAFE_ZONE + 120, 124, 20,
                {"Classic", "Inverted", "Dark", "Fuck"}, function(sender)
                     Appearance.SetTheme(sender.Items[sender.SelectedItemIndex])
                end),
            SelectYourDisease = Label:new(HORIZONTAL_SAFE_ZONE + 20, VERTICAL_SAFE_ZONE + 90, "Select your theme:"),

        })

    }, {
        HomeButton = Button:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE, 70, 32, "Home", function(sender)
            SceneManager.ChangeScene("Home")
        end),
        SettingsButton = Button:new(HORIZONTAL_SAFE_ZONE * 2 + 70, VERTICAL_SAFE_ZONE, 70, 32, "Settings",
            function(sender)
                SceneManager.ChangeScene("Settings")
            end)
    })

    CurrentScene = Scenes.Home
    CurrentScene.IsActive = true

    UserCodeAtInputPoll()
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

