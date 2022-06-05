-- example for how to write your code
-- DO NOT modify or interact with anything beyond Main.lua, Appearance.lua, Keyboard.lua, Mouse.lua or SceneManager.lua
-- DO write controls and scenes here, mutate state, etc...

-- btw this code sucks but it's just an example

YourCode = {
    Mario = {},
    WatchedFloats = {},
    WatchedDWORDs = {},
    CurrentTextBoxIndex = 10,
    TargetHSpeed = 0,
}

function UserCodeAtInputPoll()
    memory.writefloat(0x00B3B1C4, YourCode.TargetHSpeed)
    YourCode.Mario.HSpeed = memory.readdword(0x00B3B1C4)
    YourCode.Mario.XPosition = memory.readfloat(0x00B3B1AC)
    YourCode.JoystickX = joypad.get().X
    YourCode.JoystickY = joypad.get().Y
    Scenes["Home"].Controls["MarioHSpeedTextBox"].Text = tostring(math.floor(DecodeDecToFloat(YourCode.Mario.HSpeed)))
    Scenes["Home"].Controls["MarioXPositionTextBox"].Text =  YourCode.Mario.XPosition
    Scenes["Home"].Controls["MainJoystick"].ValueX = YourCode.JoystickX
    Scenes["Home"].Controls["MainJoystick"].ValueY = -YourCode.JoystickY

    for k, v in pairs(YourCode.WatchedFloats) do
        YourCode.WatchedFloats[k] = DecodeDecToFloat(memory.readdword(k))
        Scenes.Home.Controls[k].Text = string.format("%08X", k) .. ": " .. YourCode.WatchedFloats[k] .. "f"
    end

    for k, v in pairs(YourCode.WatchedDWORDs) do
        YourCode.WatchedDWORDs[k] = memory.readdword(k)
        Scenes.Home.Controls[k].Text = string.format("%08X", k) .. ": " .. YourCode.WatchedDWORDs[k] .. "DW"
    end
    
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

            NewAddressTextBox = TextBox:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 7, 128, 20, 8, false, nil),
            NewFloatButton = Button:new(HORIZONTAL_SAFE_ZONE + 128 + 5, VERTICAL_SAFE_ZONE * 7, 25, 20, "+f",
                function(sender)
                    local textBox = CurrentScene.Controls["NewAddressTextBox"]
                    if textBox.Text and textBox.Text:len() == 8 then
                        local address = tonumber(textBox.Text, 16)
                        if address then
                            YourCode.WatchedFloats[address] = 0
                            -- creating control at runtime
                            Scenes.Home.Controls[address] = TextBox:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * YourCode.CurrentTextBoxIndex, 128, 20, nil, true, nil)
                            YourCode.CurrentTextBoxIndex = YourCode.CurrentTextBoxIndex + 1
                        end
                    end
                end),
                NewDWORDButton = Button:new(HORIZONTAL_SAFE_ZONE + 128 + 35, VERTICAL_SAFE_ZONE * 7, 25, 20, "+D",
                function(sender)
                    local textBox = CurrentScene.Controls["NewAddressTextBox"]
                    if textBox.Text and textBox.Text:len() == 8 then
                        local address = tonumber(textBox.Text, 16)
                        if address then
                            YourCode.WatchedDWORDs[address] = 0
                            -- creating control at runtime
                            Scenes.Home.Controls[address] = TextBox:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * YourCode.CurrentTextBoxIndex, 128, 20, nil, true, nil)
                            YourCode.CurrentTextBoxIndex = YourCode.CurrentTextBoxIndex + 1
                        end
                    end
                end),
            MarioHSpeedTextBox = TextBox:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 8, 128, 20, nil, false, 
            function(sender)
                local val = tonumber(sender.Text)
                YourCode.TargetHSpeed = val
            end),
            MarioXPositionTextBox = TextBox:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE * 9, 128, 20, nil, false, 
            function(sender)
                local val = tonumber(sender.Text)
                memory.writedword(0x00B3B1AC, val)
            end),

            MainJoystick = Joystick:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE + 40, 128, 128, true,
                function(sender)

                end),

            TheCarrousel = CarrouselButton:new(HORIZONTAL_SAFE_ZONE + 20, VERTICAL_SAFE_ZONE + 290, 124, 20, { "Classic", "Inverted", "Dark"}, function(sender)
                Appearance.SetTheme(sender.Items[sender.SelectedItemIndex])
            end),

        }),

        Memory = Scene:new({

        }),

        Settings = Scene:new({
            DarkModeToggleButton = ToggleButton:new(HORIZONTAL_SAFE_ZONE, VERTICAL_SAFE_ZONE + 40, 90, 20, "Inverted",
                false, function(sender)
                    Appearance.SetTheme(Appearance.CurrentTheme == "Classic" and "Inverted" or "Classic")
                end)
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
end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end

