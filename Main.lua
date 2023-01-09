function AbsolutePathToCurrentFile()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("^.*/(.*).lua$") or str
end

function AbsolutePathToCurrentFolder(thisFileName)
    if not thisFileName then
        thisFileName = "Main.lua"
    end
    return AbsolutePathToCurrentFile():sub(1, -(thisFileName):len() - 1)
end

FOLDER_USER_CODE = AbsolutePathToCurrentFolder() .. "User" .. "\\"
FOLDER_USER_CODE_SAMPLES = AbsolutePathToCurrentFolder() .. "User" .. "\\" .. "Samples" .. "\\"
FOLDER_LIBRARY = AbsolutePathToCurrentFolder() .. "Library" .. "\\"
FOLDER_EMULATOR = AbsolutePathToCurrentFolder() .. "Emulator" .. "\\"
FOLDER_HELPER = AbsolutePathToCurrentFolder() .. "Helper" .. "\\"
FOLDER_GUI = AbsolutePathToCurrentFolder() .. "GUI" .. "\\"
FOLDER_GUI_CONTROLS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Controls" .. "\\"
FOLDER_GUI_CONTROLS_LAYOUT = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Controls" .. "\\" .. "Layout" .. "\\"
FOLDER_GUI_RENDERERS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Renderers" .. "\\"
FOLDER_GUI_STYLERS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Stylers" .. "\\"
FOLDER_GUI_EVENTS = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Events" .. "\\"
FOLDER_GUI_EVENTS_MANAGER = AbsolutePathToCurrentFolder() .. "GUI" .. "\\" .. "Events" .. "\\" .. "Manager" .. "\\"
FOLDER_PROVIDER = AbsolutePathToCurrentFolder() .. "Provider" .. "\\"

dofile(FOLDER_USER_CODE_SAMPLES .. "Input Direction Lua" .. "\\" .. "InputDirection.lua")
-- dofile(FOLDER_USER_CODE_SAMPLES .. "Hello World" .. "\\" .. "HelloWorld.lua")
--dofile(FOLDER_USER_CODE_SAMPLES .. "Layout Controls" .. "\\" .. "LayoutControls.lua")

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
dofile(FOLDER_GUI_RENDERERS .. "StandardRenderer.lua")
dofile(FOLDER_GUI_RENDERERS .. "GDIPlusRenderer.lua")
dofile(FOLDER_GUI_STYLERS .. "StylerManager.lua")
dofile(FOLDER_GUI_STYLERS .. "Styler.lua")
dofile(FOLDER_GUI_STYLERS .. "Windows10Styler.lua")
dofile(FOLDER_GUI_STYLERS .. "Windows11Styler.lua")
dofile(FOLDER_GUI_STYLERS .. "PlasticStyler.lua")
dofile(FOLDER_GUI_STYLERS .. "Windows3Styler.lua")
dofile(FOLDER_GUI .. "Scene.lua")
dofile(FOLDER_GUI .. "SceneManager.lua")
dofile(FOLDER_GUI .. "ClipboardManager.lua")
dofile(FOLDER_GUI .. "AnimatedColor.lua")
dofile(FOLDER_GUI .. "AnimatedNumber.lua")
dofile(FOLDER_GUI_CONTROLS .. "Control.lua")
dofile(FOLDER_GUI_CONTROLS .. "Button.lua")
dofile(FOLDER_GUI_CONTROLS .. "ToggleButton.lua")
dofile(FOLDER_GUI_CONTROLS .. "TextBox.lua")
dofile(FOLDER_GUI_CONTROLS .. "Slider.lua")
dofile(FOLDER_GUI_CONTROLS .. "Label.lua")
dofile(FOLDER_GUI_CONTROLS .. "Joystick.lua")
dofile(FOLDER_GUI_CONTROLS .. "CarrouselButton.lua")
dofile(FOLDER_GUI_CONTROLS .. "ComboBox.lua")
dofile(FOLDER_GUI_CONTROLS_LAYOUT .. "LayoutControl.lua")
dofile(FOLDER_GUI_CONTROLS_LAYOUT .. "StackPanel.lua")
dofile(FOLDER_GUI_CONTROLS_LAYOUT .. "Grid.lua")
dofile(FOLDER_GUI_EVENTS .. "KeyboardEvents.lua")
dofile(FOLDER_GUI_EVENTS .. "MouseEvents.lua")
dofile(FOLDER_GUI_EVENTS .. "VisualEvents.lua")
dofile(FOLDER_GUI_EVENTS .. "InteractionEvents.lua")
dofile(FOLDER_GUI_EVENTS_MANAGER .. "EventManager.lua")
dofile(FOLDER_PROVIDER .. "Mouse.lua")
dofile(FOLDER_PROVIDER .. "Keyboard.lua")
dofile(FOLDER_PROVIDER .. "Appearance.lua")
---------------------------------------------------------------------------------------------------------------------------------------

-- Expand window for our drawing area
Screen.Expand()

RendererManager.SetCurrentRenderer(StandardRenderer:new())
StylerManager.SetCurrentStyler(Windows11Styler:new())
Appearance.Initialize()

if UserCodeOnInitialize then
    UserCodeOnInitialize()
end


---------------------------------------------------------------------------------------------------------------------------------------

function AtStop()

    if UserCodeAtStop then
        UserCodeAtStop()
    end


    -- Restore pre-resize window dimensions
    Screen.Contract()
end

function AtVisualInterrupt()

    if UserCodeAtVisualInterrupt then
        UserCodeAtVisualInterrupt()
    end

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
