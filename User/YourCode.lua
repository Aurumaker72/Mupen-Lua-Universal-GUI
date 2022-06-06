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
        Home = Scene:new({ -- scene controls

            

            MainJoystick = Joystick:new(HORIZONTAL_SAFE_ZONE + 33, VERTICAL_SAFE_ZONE + 40, 128, 128, true,
                function(sender)

                end),
            XSlider = Slider:new(HORIZONTAL_SAFE_ZONE + 60, VERTICAL_SAFE_ZONE * 3 + 128, 128, 30, 
            0, -128, 127, true,  true,
            function(sender)

            end),
            XLabel = Label:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 3 + 133, 128, 30, ""),

            
            YSlider = Slider:new(HORIZONTAL_SAFE_ZONE + 60, VERTICAL_SAFE_ZONE * 4 + 128, 128, 30, 
            0, -127, 128, true, true,
            function(sender)

            end),
            YLabel = Label:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 4 + 133, 128, 30, ""),
            
        }),

        Memory = Scene:new({

        }),

        Settings = Scene:new({
            TheCarrousel = CarrouselButton:new(HORIZONTAL_SAFE_ZONE + 20, VERTICAL_SAFE_ZONE + 90, 124, 20, { "Classic", "Inverted", "Dark"}, true, function(sender)
                Appearance.SetTheme(sender.Items[sender.SelectedItemIndex])
            end),
            FuckThisShit = ComboBox:new(HORIZONTAL_SAFE_ZONE + 20, VERTICAL_SAFE_ZONE + 120, 124, 20, { "Classic", "Inverted", "Dark" }, function(sender)
                Appearance.SetTheme(sender.Items[sender.SelectedItemIndex])
            end),
        }),
        
    }, {
        HomeButton = Button:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE, 70, 32, "Home", function(sender)
            SceneManager.ChangeScene("Home")
        end),
        MemoryButton = Button:new(HORIZONTAL_SAFE_ZONE * 2 + 70, VERTICAL_SAFE_ZONE, 70, 32, "Memory", function(sender)
            SceneManager.ChangeScene("Memory")
        end),

        SettingsButton = Button:new(HORIZONTAL_SAFE_ZONE * 2 + 143, VERTICAL_SAFE_ZONE, 70, 32, "Settings",
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

