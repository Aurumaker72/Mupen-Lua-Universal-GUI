Keyboard = {
    Input = {},
    LastInput = {},
    PushedKeys = {},
    ReleasedKeys = {}
}

function Keyboard.KeyPressed(key)
    if not key then
        return false
    end
    return Keyboard.Input[key] and not Keyboard.LastInput[key]
end

function Keyboard.KeyReleased(key)
    if not key then
        return false
    end
    return Keyboard.LastInput[key] and not Keyboard.Input[key]
end

function Keyboard.KeyHeld(key)
    return Keyboard.Input[key]
end

function Keyboard.IsNumeric(key)
    for i = 0, 9, 1 do
        if key == tostring(i) or key == "numpad" .. i then
            return true
        end
    end
    return false
end

function Keyboard.IsAlphanumericKey(key)
    return key:len() == 1
end

function Keyboard.Update()

    Keyboard.LastInput = Keyboard.Input

    Keyboard.Input = input.get()
    for key, value in pairs(Keyboard.Input) do
        if key:find("click") or key:find("mouse") then
            Keyboard.Input[key] = nil
        end
    end

    Keyboard.PushedKeys = {}
    Keyboard.ReleasedKeys = {}

    for key, value in pairs(Keyboard.Input) do
        if Keyboard.Input[key] and not Keyboard.LastInput[key] then
            Keyboard.PushedKeys[key] = value
        end
    end

    for key, value in pairs(Keyboard.LastInput) do
        if not Keyboard.Input[key] and Keyboard.LastInput[key] then
            Keyboard.ReleasedKeys[key] = value
            
        end

    end
    
end

