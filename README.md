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

![grafik](https://user-images.githubusercontent.com/48759429/172351451-a422fcfd-5d84-4338-bd8f-60dd6136831b.png)

*Example frontend port of InputDirection Lua*

## Usage


#### Adding a new scene
Add `YourKey = Scene:new({ ... })` in the `SceneManager.Initialize(...)` call

#### Adding a new control
Modify the `Controls = { ... }` block inside your desired scene


### Button
```lua
     Button:new(
         20, -- X Position
         VERTICAL_SAFE_ZONE*2, -- Y Position
         128, -- Width
         64, -- Height
         "button", -- Text (optional)
         function(sender) -- Click callback (sender is the control instance)
           print(sender.Text)
         end)
```

## Features
- Controls
  - Button
  - ToggleButton
  - TextBox
    - Read-only and Read-write mode
    - Relative editing mode
  - Slider
    - Minimum/Maximum bounds
    - Staggered increment
    - Read-only and Read-write mode
  - Joystick
    - Read-only and Read-write mode
  - Label
  - CarrouselButton
    - Wrap-around
  - ComboBox
  - ~~ListView~~
  - ~~Image~~
