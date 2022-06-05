-- GUI Framework for mupen lua
-- by Aurumaker72


---------------------------------------------------------------------------------------------------------------------------------------
function AbsolutePathToCurrentFile()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end

function AbsolutePathToCurrentFolder()
    return AbsolutePathToCurrentFile():sub(1, -("Main.lua"):len()-1)
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

-- Define your controls and their callbacks!
Controls = {
     Button:new(
         20,
         VERTICAL_SAFE_ZONE*2,
         128,
         64,
         "button",
         function(sender)
          
         end),

     ToggleButton:new(
         20,
         VERTICAL_SAFE_ZONE*5,
         128,
         64,
         "click me",
         function(sender)

         end),
    
    TextBox:new(
        20,
        VERTICAL_SAFE_ZONE*10,
        128,
        20,
        30,
        function(sender)
            if sender.Text == "17" then
                sender.Text = "39"
            end
        end),

    Slider:new(
        20,
        VERTICAL_SAFE_ZONE*12,
        128,
        SLIDER_TRACK_HEIGHT + 4,
        0,
        10,
        false,
        function(sender)
            
        end),
}

function AtStop()
    -- Restore pre-resize window dimensions
    Screen.Contract()
end

function AtVisualInterrupt()

    Mouse.Update()
    Keyboard.Update()

    wgui.setbrush(WINDOW_BACK_COLOR)
    wgui.setpen(WINDOW_BACK_COLOR)
    wgui.rect(Screen.Dimensions.Width - Screen.ExpandedOffset, 
    0,
    (Screen.Dimensions.Width - Screen.ExpandedOffset) * 2, 
    Screen.Dimensions.Height)


    for i = 1, table.getn(Controls), 1 do
        Controls[i]:Update()
	end

    for i = 1, table.getn(Controls), 1 do
        Controls[i]:Draw()
	end


end

function AtInputPoll()
    
end

-- Register callbacks
emu.atstop(AtStop)
emu.atinput(AtInputPoll)
emu.atvi(AtVisualInterrupt)
