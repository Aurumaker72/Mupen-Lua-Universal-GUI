<div align="center">
  <a href="https://github.com/othneildrew/Best-README-Template">
    <img src="https://user-images.githubusercontent.com/48759429/188270723-d22df4f5-b714-4d10-abad-7af76091aedb.png" alt="Logo" width="140" height="140">
  </a>

  <h3 align="center">Mupen Lua Universal GUI</h3>

  <p align="center">
    A feature-rich GUI framework for production scripts and prototyping
    <br>
    It provides many built-in controls, themes and styles which help you fulfill your requirements and has patterns encouraging clean, legible code.
    <br />
    <br />
    <img src="https://img.shields.io/github/last-commit/Aurumaker72/mupenluauniversalgui?style=for-the-badge"/> 
    <img src="https://img.shields.io/badge/Status-Work%20In%20Progress-orange?style=for-the-badge"/>
  </p>
</div>

## 💨 Quickstart

#### Setting a renderer
Before doing anything GUI-related, you must tell the SceneManager to activate and use a Renderer. This Renderer is essential for all measurement and low-level interactions and thus must be initialized first
```lua
RendererManager.SetCurrentRenderer(StandardRenderer:new())
```

#### Adding a new scene
Create a new scene using the `Scene` constructor
```lua
local myScene = Scene:new()
```

#### Adding controls to your scene
Add a controls dictionary to the created scene by using its `AddControls(t)` method
```lua
myScene:AddControls({

YourButton = Button:new(
     myScene,           -- The scene containing the button
     nil,               -- (OPTIONAL, only for layouted controls) The button's index in the scene. For each control, increase it by 1 heading downwards
     nil,               -- The keyboard key associated with the button (nil disables keyboard interaction)
     20,                -- X Position 
     20,                -- Y Position
     128,               -- Width
     64,                -- Height
     "Hello World",     -- Text 
     function(o)        -- Interaction callback, o is reference to button
          print(o.Text)
     end)
})
```

#### Starting up the Scene Manager
You must now start the `SceneManager` and provide it with the necessary scenes and subsystems 
```lua
SceneManager.Initialize(
    {                      
        Main = myScene,    -- Dictionary of your regular scenes
    }, 
    persistentScene,       -- (OPTIONAL) Scene which will be active at all times
    Windows10Styler:new()) -- Styler
```

#### Displaying the scene
With all of the initialization done, you can now activate your scene!
```lua
SceneManager.ChangeScene(Scenes.Main)
```

## ℹ️ Examples

<img src="https://user-images.githubusercontent.com/48759429/182022523-58ddb46f-7c66-43f7-aa3e-870c31085aaf.png" height="300"/> <img src="https://user-images.githubusercontent.com/48759429/182036331-ca348923-dc75-4a7a-a2d1-97a82b80bf0a.png" height="300"/> <img src="https://user-images.githubusercontent.com/48759429/182036366-515ebd01-fa88-4b18-a254-fb1366eb2955.png" height="300"/> <img src="https://user-images.githubusercontent.com/48759429/182036403-9f318d6f-7707-42ab-97b5-8ac4f6d54908.png" height="300"/> 

## ✨ Features
- Scenes (Tabs)
  - Switch with one function call
  - Can define non-scene (persistent) controls for navigation OR scene-linked controls
- Theming defines... 
  - Colors
  - Margins
  - Sizes
  - Alignment
- Styling defines...
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

## 📐 Architecture
This framework is split into two major code sections:
- Framework (Internal)
- User (External)

The user writes code inside the `User` directory. This code includes implementation of their domain logic and definition of scenes.

The user mustn't modify any code outside of the User directory and must interact with the framework over predefined functions, not mutating data manually (e.g.:
✔️ ```RendererManager.SetCurrentRenderer(GDIRenderer:new())```
❌ ```CurrentRenderer = GDIRenderer:new()```)

#### Rendering process and relations
<img src="https://user-images.githubusercontent.com/48759429/182868104-523538f1-82e7-4eeb-9f0b-79fb206389d0.png" width="250"/>



