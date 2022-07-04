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

FOLDER_USER_CODE = AbsolutePathToCurrentFolder() .. "User" .. "\\"
FOLDER_LIBRARY = AbsolutePathToCurrentFolder() .. "Library" .. "\\"
FOLDER_EMULATOR = AbsolutePathToCurrentFolder() .. "Emulator" .. "\\"
FOLDER_HELPER = AbsolutePathToCurrentFolder() .. "Helper" .. "\\"
FOLDER_GUI = AbsolutePathToCurrentFolder() .. "GUI" .. "\\"
FOLDER_GUI_CONTROLS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Controls" .. "\\"
FOLDER_GUI_RENDERERS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Renderers" .. "\\"
FOLDER_PROVIDER = AbsolutePathToCurrentFolder() .. "Provider" .. "\\"

dofile(FOLDER_USER_CODE .. "InputDirection.lua")
dofile(FOLDER_LIBRARY .. "middleclass.lua")
dofile(FOLDER_EMULATOR .. "Screen.lua")
dofile(FOLDER_EMULATOR .. "WindowsMessageManager.lua")
dofile(FOLDER_HELPER .. "Numeric.lua")
dofile(FOLDER_HELPER .. "Color.lua")
dofile(FOLDER_HELPER .. "String.lua")
dofile(FOLDER_HELPER .. "Table.lua")
dofile(FOLDER_HELPER .. "RendererHelper.lua")
dofile(FOLDER_GUI_RENDERERS .. "RendererManager.lua")
dofile(FOLDER_GUI_RENDERERS .. "Renderer.lua")
dofile(FOLDER_GUI_RENDERERS .. "GDIRenderer.lua")
dofile(FOLDER_GUI_RENDERERS .. "GDIPlusRenderer.lua")
dofile(FOLDER_GUI_RENDERERS .. "BatchedGDIRenderer.lua")
dofile(FOLDER_GUI .. "Scene.lua")
dofile(FOLDER_GUI .. "SceneManager.lua")
dofile(FOLDER_GUI .. "ClipboardManager.lua")
dofile(FOLDER_GUI_CONTROLS .. "Control.lua")
dofile(FOLDER_GUI_CONTROLS .. "Button.lua")
dofile(FOLDER_GUI_CONTROLS .. "ToggleButton.lua")
dofile(FOLDER_GUI_CONTROLS .. "TextBox.lua")
dofile(FOLDER_GUI_CONTROLS .. "Slider.lua")
dofile(FOLDER_GUI_CONTROLS .. "Label.lua")
dofile(FOLDER_GUI_CONTROLS .. "Joystick.lua")
dofile(FOLDER_GUI_CONTROLS .. "CarrouselButton.lua")
dofile(FOLDER_GUI_CONTROLS .. "ComboBox.lua")
dofile(FOLDER_PROVIDER .. "Mouse.lua")
dofile(FOLDER_PROVIDER .. "Keyboard.lua")
dofile(FOLDER_PROVIDER .. "Appearance.lua")
---------------------------------------------------------------------------------------------------------------------------------------

-- Expand window for our drawing area
Screen.Expand()

UserCodeOnInitialize()

-- Appearance requires renderer initialization
Appearance.Initialize()

---------------------------------------------------------------------------------------------------------------------------------------

function AtStop()

    UserCodeAtStop()
    
    -- Restore pre-resize window dimensions
    Screen.Contract()
end

function AtVisualInterrupt()

    UserCodeAtVisualInterrupt()


    SceneManager.Draw()
    
end

function AtInterval()
    Mouse.Update()
    Keyboard.Update()

    SceneManager.Update()

end

function AtReset()
    Screen.Expand()
end

function AtWindowsMessage(hwnd, id, wparam, lparam)
	WindowsMessageManager.Update(hwnd, id, wparam, lparam)
end

-- Register callbacks
emu.atstop(AtStop)
emu.atinterval(AtInterval)
emu.atvi(AtVisualInterrupt)
emu.atinput(UserCodeAtInputPoll)
emu.atreset(AtReset)
emu.atwindowmessage(AtWindowsMessage)