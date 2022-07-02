# Mupen-Lua Universal GUI

⚠️ **This framework is not ready for production, expect API changes**

Lua framework for Mupen64 which allows flexible, highly customizable and straightforward creation of GUIs

## Examples

![grafik](https://user-images.githubusercontent.com/48759429/172042835-9f99b721-abf0-418e-8de5-95047c57d922.png)

*A button control*

![grafik](https://user-images.githubusercontent.com/48759429/172042856-bdfd57e4-596a-4d67-9dec-487c658d6e28.png)

*A textbox control in read-write mode*

![grafik](https://user-images.githubusercontent.com/48759429/172042862-81524d8e-1630-4159-a149-8641a1e297b5.png)

*A non-staggering trackbar control*

![grafik](https://user-images.githubusercontent.com/48759429/172049713-9d056b9a-e19a-4965-a33c-02a410ac5568.png)

*A joystick control in read-write mode*

<img src="https://user-images.githubusercontent.com/48759429/172204289-d435637d-33e4-4d35-9d18-714766337f32.gif" width="250"/>

*A ComboBox control which sets the theme*

<img src="https://user-images.githubusercontent.com/48759429/172062375-c19b362f-d0d3-48cc-9a1f-fb7ecaac12c8.gif" width="250"/>

*Button highlights*

<img src="https://user-images.githubusercontent.com/48759429/177013242-e448a242-cc01-430a-922c-ccaea79e996f.png" height="400"/>

*Example user program*

## Usage


#### Adding a new scene
Create a new scene using the `Scene` constructor and pass in `nil`
```lua
local mainScene = Scene:new(nil)
```

#### Adding controls to your scene
Add a controls dictionary to the created scene by using its `AddControls(t)` method
```lua
mainScene:AddControls({

YourButton = Button:new(
     mainScene, -- The scene containing the button
     nil, -- The keyboard key associated with the button (nil disables keyboard interaction)
     20, -- X 
     20, -- Y
     128, -- Width
     64, -- Height
     "Hello World", -- Text 
     function(o) -- Interaction callback, o is reference to button
          print(o.Text)
     end)
})
```

#### Starting up the Scene Manager
After defining your scenes and their respective controls, you need to signal the startup to `SceneManager` 
```lua
SceneManager.Initialize(

    { -- Dictionary of your scenes
        Main = mainScene,
    },
    
    { -- Dictionary of controls which are persistent (scene independent)
    
    },
    
    GDIRenderer:new() -- Instance of a rendering backend
)

-- Set the `CurrentScene` to the key of your main scene
CurrentScene = Scenes.Main
-- now activate it. it should begin operating normally after this
CurrentScene.IsActive = true
```

## Features
- Scenes (Tabs)
  - Switch with one function call
  - Can define non-scene (persistent) controls for navigation OR scene-linked controls
- Theming
- Compatibility
  - (WIP) Automatically scales controls depending on resolution 
- Controls
  - Button
    - Keyboard interaction
  - ToggleButton
    - Keyboard interaction
  - TextBox
    - Read-only and Read-write mode
    - Character deletion
    - Numeric/Alphanumeric mode
  - Slider
    - Minimum/Maximum bounds
    - Staggered increment
    - Read-only and Read-write mode
  - Joystick
    - Read-only and Read-write mode
  - Label
  - CarrouselButton
    - Wrap-around
    - Keyboard interaction
  - ComboBox
    - Keyboard interaction 
  - ~~ListView~~
  - ~~Expander~~
  - ~~Image~~
  - 
