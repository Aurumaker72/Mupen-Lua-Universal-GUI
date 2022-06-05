-- GUI Framework for mupen lua
-- by Aurumaker72
---------------------------------------------------------------------------------------------------------------------------------------
function AbsolutePathToCurrentFile()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end

function AbsolutePathToCurrentFolder()
    return AbsolutePathToCurrentFile():sub(1, -("Main.lua"):len() - 1)
end

FOLDER_LIBRARY = AbsolutePathToCurrentFolder() .. "Library" .. "\\"
FOLDER_EMULATOR = AbsolutePathToCurrentFolder() .. "Emulator" .. "\\"
FOLDER_HELPER = AbsolutePathToCurrentFolder() .. "Helper" .. "\\"
FOLDER_GUI = AbsolutePathToCurrentFolder() .. "GUI" .. "\\"
FOLDER_GUI_CONTROLS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Controls" .. "\\"
FOLDER_PROVIDER = AbsolutePathToCurrentFolder() .. "Provider" .. "\\"

dofile(FOLDER_LIBRARY .. "middleclass.lua")
dofile(FOLDER_EMULATOR .. "Screen.lua")
dofile(FOLDER_HELPER .. "Numeric.lua")
dofile(FOLDER_HELPER .. "WGUI.lua")
dofile(FOLDER_HELPER .. "Table.lua")
dofile(FOLDER_GUI .. "Scene.lua")
dofile(FOLDER_GUI .. "SceneManager.lua")
dofile(FOLDER_GUI_CONTROLS .. "Control.lua")
dofile(FOLDER_GUI_CONTROLS .. "Button.lua")
dofile(FOLDER_GUI_CONTROLS .. "ToggleButton.lua")
dofile(FOLDER_GUI_CONTROLS .. "TextBox.lua")
dofile(FOLDER_GUI_CONTROLS .. "Slider.lua")
dofile(FOLDER_PROVIDER .. "Mouse.lua")
dofile(FOLDER_PROVIDER .. "Keyboard.lua")
dofile(FOLDER_PROVIDER .. "Appearance.lua")
---------------------------------------------------------------------------------------------------------------------------------------

-- Expand window for our drawing area
Screen.Expand()

-- Current theme
CurrentTheme = "Classic"
Appearance.Initialize()

-- Create scenes with their controls
SceneManager.Initialize({

    Home = Scene:new(
        {
            -- scene controls
            Button:new(20, VERTICAL_SAFE_ZONE * 2, 120, 32, "Go to settings", function(sender) 
                SceneManager.ChangeScene("Settings")
            end), 

            ToggleButton:new(20, VERTICAL_SAFE_ZONE * 5, 128, 64, CurrentTheme, function(sender) 
                CurrentTheme = CurrentTheme == "Classic" and "Dark" or "Classic" 
                sender.Text = CurrentTheme
            end),

            TextBox:new(20, VERTICAL_SAFE_ZONE * 10, 128, 20, 30, function(sender)
                if sender.Text == "17" then
                    sender.Text = "39"
                end
            end),

            Slider:new(20, VERTICAL_SAFE_ZONE * 12, 128, Appearance.Themes[CurrentTheme].SLIDER_TRACK_HEIGHT + 4, 0, 10, false, function(sender) end)
        }
    ),

    Settings = Scene:new(
        {
            -- scene controls
            Button:new(20, VERTICAL_SAFE_ZONE * 2, 120, 32, "Go to main page", function(sender) 
                SceneManager.ChangeScene("Home")
            end),
        }
    )
})

CurrentScene = Scenes.Home
CurrentScene.IsActive = true

---------------------------------------------------------------------------------------------------------------------------------------

function AtStop()
    -- Restore pre-resize window dimensions
    Screen.Contract()
end

function AtVisualInterrupt()

    Mouse.Update()
    Keyboard.Update()

    if CurrentScene.IsActive then
        CurrentScene:Update(CurrentScene)
        CurrentScene:Draw(CurrentScene)
    end
end

function AtInputPoll()

end

-- Register callbacks
emu.atstop(AtStop)
emu.atinput(AtInputPoll)
emu.atvi(AtVisualInterrupt)
