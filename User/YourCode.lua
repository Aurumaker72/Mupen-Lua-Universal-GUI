-- example for how to write your code
-- DO NOT modify or interact with anything beyond Main.lua, Appearance.lua, Keyboard.lua, Mouse.lua or SceneManager.lua
-- DO write controls and scenes here, mutate state, etc...
YourCode = {
    Mario = {}
}

function UserCodeAtInputPoll()
    YourCode.Mario.HSpeed = memory.readdword(0x00B3B1C4)
    YourCode.GlobalTimer = memory.readdword(0x00B2D5D4)
    YourCode.JoystickX = joypad.get().X
    YourCode.JoystickY = joypad.get().Y
    Scenes["Home"].Controls["MarioHSpeedLabel"].Text = "HSpeed: " .. math.floor(DecodeDecToFloat(YourCode.Mario.HSpeed))
    Scenes["Home"].Controls["GlobalTimerLabel"].Text = "Global Timer: " .. math.floor(YourCode.GlobalTimer)
    Scenes["Home"].Controls["MainJoystick"].ValueX = YourCode.JoystickX
    Scenes["Home"].Controls["MainJoystick"].ValueY = -YourCode.JoystickY
end

MoreMaths = {
    tab = {
        ["0"] = "0000",
        ["1"] = "0001",
        ["2"] = "0010",
        ["3"] = "0011",
        ["4"] = "0100",
        ["5"] = "0101",
        ["6"] = "0110",
        ["7"] = "0111",
        ["8"] = "1000",
        ["9"] = "1001",
        ["a"] = "1010",
        ["b"] = "1011",
        ["c"] = "1100",
        ["d"] = "1101",
        ["e"] = "1110",
        ["f"] = "1111",
        ["A"] = "1010",
        ["B"] = "1011",
        ["C"] = "1100",
        ["D"] = "1101",
        ["E"] = "1110",
        ["F"] = "1111"
    }
}

function DecodeDecToFloat(input)
    local str = string.format("%x", input)
    local str1 = ""
    local a, z
    for z = 1, string.len(str) do
        a = string.sub(str, z, z)
        str1 = str1 .. MoreMaths.tab[a]
    end
    local pm = string.sub(str1, 1, 1)
    local exp = string.sub(str1, 2, 9)
    local c = tonumber(exp, 2) - 127
    local p = math.pow(2, c)
    local man = "1" .. string.sub(str1, 10, 32)
    local x = 0
    for z = 1, string.len(man) do
        if string.sub(man, z, z) == "1" then
            x = x + p
        end
        p = p / 2
    end
    if pm == "1" then
        x = -x
    end
    return (x)
end

function UserCodeOnInitialize()

    SceneManager.Initialize({
        Home = Scene:new({ -- scene controls

            MarioHSpeedLabel = Label:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE + 20 * 2, 128, 20, ""),
            GlobalTimerLabel = Label:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE + 20 * 3, 128, 20, ""),

            MainJoystick = Joystick:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE + 20 * 4, 128, 128, false,
                function(sender)

                end),
            TestSlider = Slider:new(HORIZONTAL_SAFE_ZONE + 20, VERTICAL_SAFE_ZONE + 20 * 12, 128, 20, 0, 0, 10, false,
                function(sender)

                end)
            -- FunSlider2 = Slider:new(20, VERTICAL_SAFE_ZONE * 13, 128,
            --     Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT + 4, -128, -128, 127, false, function(sender)
            --         Scenes["Home"].Controls["MainJoystick"].ValueY = sender.Value
            --     end),
            -- FunSlider = Slider:new(20, VERTICAL_SAFE_ZONE * 12, 128,
            --     Appearance.Themes[Appearance.CurrentTheme].SLIDER_TRACK_HEIGHT + 4, -127, -127, 128, false, function(sender)
            --         Scenes["Home"].Controls["MainJoystick"].ValueX = sender.Value
            --     end)
        }),

        Settings = Scene:new({
            DarkModeToggleButton = ToggleButton:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 4, 120, 32, "Dark",
                false, function(sender)
                    Appearance.SetTheme(Appearance.CurrentTheme == "Classic" and "Dark" or "Classic")
                end)
        })
    }, 
    {
        HomeButton = Button:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE, 70, 32, "Home", function(sender)
            SceneManager.ChangeScene("Home")
        end),

        SettingsButton = Button:new(HORIZONTAL_SAFE_ZONE * 2 + 70, VERTICAL_SAFE_ZONE, 70, 32, "Settings",
            function(sender)
                SceneManager.ChangeScene("Settings")
            end),
    })

    CurrentScene = Scenes.Home
    CurrentScene.IsActive = true
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

