<p align="center">
  <img width="128" align="center" src="https://user-images.githubusercontent.com/48759429/188273706-e8077f99-a24f-4c6b-b861-d397b9220d1e.png">
</p>
<h1 align="center">
  Mupen Lua Universal GUI
</h1>
<p align="center">
  A feature-rich GUI framework for Mupen Lua
</p>
<p align="center">
    <img src="https://img.shields.io/github/last-commit/Aurumaker72/mupenluauniversalgui?style=for-the-badge"/> 
    <img src="https://img.shields.io/badge/Status-Work%20In%20Progress-orange?style=for-the-badge"/>
</p>


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
<img src="https://user-images.githubusercontent.com/48759429/195981965-5dfe19f0-ae3f-4183-87bf-2a8bc18be42d.png" height="400"/><img src="https://user-images.githubusercontent.com/48759429/195981968-327b2469-7f4d-49db-a7c9-5d6b4e69b1e4.png" height="400"/>

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

![Untitled Diagram drawio](https://user-images.githubusercontent.com/48759429/195982354-11a00d7e-e770-4688-8836-62776cbc160e.svg)

