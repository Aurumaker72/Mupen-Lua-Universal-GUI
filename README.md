<p align="center">
  <img width="128" align="center" src="https://user-images.githubusercontent.com/48759429/196777604-aa4becd2-d6aa-45f6-824d-f05a493a088e.png">
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

#### ➕ Adding a scene
Create a new scene using the `Scene` constructor
```lua
local mainScene = Scene:new()
```

#### ➕ Adding controls
Add a controls dictionary to the created scene by using its `AddControls(t)` method
```lua
mainScene:AddControls({
  YourButton = Button:new(
       mainScene,           -- The scene containing the button
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
  }
)
```

#### 📈 Starting up
You must now start the `SceneManager` and provide it with the necessary scenes and subsystems 
```lua
SceneManager.Initialize(
  {                      
      Main = mainScene,    -- Dictionary of your regular scenes
  }, 
  nil,       -- (OPTIONAL) Scene which will be active at all times
  Windows11Styler:new() -- The global styler
)
```

#### 🖥️ Displaying
With all of the initialization done, you can now activate your scene!
```lua
SceneManager.ChangeScene(Scenes.Main)
```

## ℹ️ Examples
<img src="https://user-images.githubusercontent.com/48759429/195981965-5dfe19f0-ae3f-4183-87bf-2a8bc18be42d.png" height="400"/><img src="https://user-images.githubusercontent.com/48759429/195981968-327b2469-7f4d-49db-a7c9-5d6b4e69b1e4.png" height="400"/>

## ✨ Features

- **Scenes** allow easy navigation with tabs
- **Themes** change the color scheme
- **Stylers** change the look and feel of controls
- **Autosize** scales your GUI to any emulator resolution, guaranteeing no overflows

## 📐 Architecture
This framework is split into two major code sections:
- Framework (Internal)
- User (External)

The user writes code inside the `User` directory. This code includes implementation of their domain logic and definition of scenes.

The user mustn't modify any code outside of the User directory and must interact with the framework over predefined functions, not mutating data manually (e.g.:
✔️ ```RendererManager.SetCurrentRenderer(GDIRenderer:new())```
❌ ```CurrentRenderer = GDIRenderer:new()```)

![Untitled Diagram drawio](https://user-images.githubusercontent.com/48759429/195982354-11a00d7e-e770-4688-8836-62776cbc160e.svg)

## ⚕️ Troubleshooting

### I'm seeing a red cross instead of my scene
<img src="https://user-images.githubusercontent.com/48759429/196798099-0c59a377-7675-467f-9efc-11baff313e8a.png" height="200"/>

This is caused by an improper, incomplete or just plain forgotten initialization of scenes. Take a look at the [samples](https://github.com/Aurumaker72/Mupen-Lua-Universal-GUI/tree/main/User/Samples) to check up and compare.


