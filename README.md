# Mupen-Lua Universal GUI <img src="https://user-images.githubusercontent.com/48759429/182023742-7e2eebad-ccd2-4be8-8c81-6b4a14bf1164.png" height="128" align="right"/>

<img src="https://img.shields.io/badge/Status-Work%20In%20Progress-yellow"/> <img src="https://img.shields.io/badge/Production-Not%20ready-red"/> <img src="https://img.shields.io/github/last-commit/Aurumaker72/mupenluaUniversalGUI"/> 

This framework helps you create a GUI for your lua script.

It provides many built-in controls, themes and styles which help you fulfill your requirements and has patterns encouraging clean, legible code.

## ℹ️ Examples

<img src="https://user-images.githubusercontent.com/48759429/182022523-58ddb46f-7c66-43f7-aa3e-870c31085aaf.png" height="300"/> <img src="https://user-images.githubusercontent.com/48759429/182036331-ca348923-dc75-4a7a-a2d1-97a82b80bf0a.png" height="300"/> <img src="https://user-images.githubusercontent.com/48759429/182036366-515ebd01-fa88-4b18-a254-fb1366eb2955.png" height="300"/> <img src="https://user-images.githubusercontent.com/48759429/182036403-9f318d6f-7707-42ab-97b5-8ac4f6d54908.png" height="300"/> 

*Example of built-in themes*

<img src="https://user-images.githubusercontent.com/48759429/181444977-cd5cedc0-06f2-4910-b32d-f7a7351ee6dd.gif" width="250"/>

*A ComboBox control which sets the theme*

## 💨 Quickstart

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
     1, -- The button's index in the scene. For each control, increase it by 1 heading downwards
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
    
    persistentScene, -- A scene which is always active and doesn't suppress other scenes (Optional)
    
    GDIRenderer:new(), -- Instance of a rendering backend
    Windows10Styler:new() -- Instance of a styler
)

SceneManager.ChangeScene(Scenes.Main) -- Switch to main scene and thereby signal start to SceneManager. You're done!

```

## ✨ Features
- Scenes (Tabs)
  - Switch with one function call
  - Can define non-scene (persistent) controls for navigation OR scene-linked controls
- Theming
  you can define... 
  - Colors
  - Margins
  - Sizes
  - Alignment
- Styling
  you can define...
  - High-level Drawing
  - Decorations
- Compatibility
  - Automatically scales controls depending on resolution

|                      | Button | ToggleButton | TextBox                                 | Slider | Joystick                       | ComboBox | CarrouselButton |
|----------------------|--------|--------------|-----------------------------------------|--------|--------------------------------|----------|-----------------|
| Animations           | ✔️      | ✔️            | ✔️                                       | ✔️      | ✔️                              | ✔️        | ✔️               |
| Transitions          | ✔️      | ✔️            | ➖                                       | ➖      | ✔️                              | ✔️        | ❌               |
| Keyboard interaction | ✔️      | ✔️            | ✔️                                       | ❌      | ❌                              | ✔️        | ✔️               |
| Read-only mode       | ❌      | ❌            | ✔️                                       | ✔️      | ✔️                              | ❌        | ❌               |
| Miscellaneous        |        |              | Supports numerical, alphanumerical mode |        | Configurable magnitude ellipse |          |                 |

## 📐 Arhitecture
This framework is split into two major code sections:
- Framework (Internal)
- User (External)

The user writes code inside the `User` directory. This code includes implementation of their domain logic and definition of scenes.

The user mustn't modify any code outside of the User directory and must interact with the framework over predefined functions, not mutating data manually (e.g.:
✔️ ```RendererManager.SetCurrentRenderer(GDIRenderer:new())```
❌ ```CurrentRenderer = GDIRenderer:new()```)

#### Rendering process and relations
<img src="https://user-images.githubusercontent.com/48759429/182868104-523538f1-82e7-4eeb-9f0b-79fb206389d0.png" width="250"/>



