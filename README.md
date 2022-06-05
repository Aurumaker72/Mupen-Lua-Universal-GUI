# Mupen-Lua Universal GUI
Lua framework for Mupen64 which allows flexible, highly customizable and straightforward creation of GUIs

## Examples

![grafik](https://user-images.githubusercontent.com/48759429/172042835-9f99b721-abf0-418e-8de5-95047c57d922.png)

*A button*

![grafik](https://user-images.githubusercontent.com/48759429/172042856-bdfd57e4-596a-4d67-9dec-487c658d6e28.png)

*A textbox*

![grafik](https://user-images.githubusercontent.com/48759429/172042862-81524d8e-1630-4159-a149-8641a1e297b5.png)

*A non-staggering slider*

## Usage
**NOTE: This project is not ready to use as a library**

Too add a new control, modify the `Controls = { ... }` block in `Main.lua` 

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
