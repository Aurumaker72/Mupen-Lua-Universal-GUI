Keyboard = {
    Input = {},
    LastInput = {},
}


function Keyboard.KeyPressed(key)
    if not key then
        return false
    end
    return Keyboard.Input[key] and not Keyboard.LastInput[key]
end

function Keyboard.KeyHeld(key)
    return Keyboard.Input[key]
end

function Keyboard.Update()
    Keyboard.LastInput = Keyboard.Input
    Keyboard.Input = input.get()
end