# Mupen-Lua Universal GUI

⚠️ **This framework is not ready for production, expect API changes**

## Why?
This framework helps you quickly create a GUI for your script with minimal hassle.

It provides many built-in controls which help you fulfill your requirements and has patterns encouraging clean, legible code.

## Examples

<img src="https://user-images.githubusercontent.com/48759429/172204289-d435637d-33e4-4d35-9d18-714766337f32.gif" width="250"/>

*A ComboBox control which sets the theme*

<img src="https://user-images.githubusercontent.com/48759429/177013242-e448a242-cc01-430a-922c-ccaea79e996f.png" height="400"/>

*Example user program*

## Arhitecture
This framework is split into two major code sections:
- Framework (Internal)
- User (External)

The user writes code inside the `User` directory. This code includes implementation of their domain logic and definition of scenes.

The user mustn't modify any code outside of the User directory and must interact with the framework over predefined functions, not mutating data manually (e.g.:
✔️ ```RendererManager.SetCurrentRenderer(GDIRenderer:new())```
❌ ```CurrentRenderer = GDIRenderer:new()```)

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
  - Automatically scales controls depending on resolution

|                      | Button | ToggleButton | TextBox                                 | Slider | Joystick                       | ComboBox | CarrouselButton |
|----------------------|--------|--------------|-----------------------------------------|--------|--------------------------------|----------|-----------------|
| Animations           | ✔️      | ✔️            | ✔️                                       | ✔️      | ✔️                              | ✔️        | ✔️               |
| Transitions          | ✔️      | ✔️            | ➖                                       | ➖      | ✔️                              | ✔️        | ❌               |
| Keyboard interaction | ✔️      | ✔️            | ✔️                                       | ❌      | ❌                              | ✔️        | ✔️               |
| Read-only mode       | ❌      | ❌            | ✔️                                       | ✔️      | ✔️                              | ❌        | ❌               |
| Miscellaneous        |        |              | Supports numerical, alphanumerical mode |        | Configurable magnitude ellipse |          |                 |
