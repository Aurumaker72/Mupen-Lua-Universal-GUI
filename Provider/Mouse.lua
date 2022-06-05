Mouse = {
    X = 0,
    Y = 0,
    IsPrimaryButtonDown = false,
    IsSecondaryButtonDown = false,
    _mouseTable = {},
    _previousMouseTable = {},
}

function Mouse.Update()
    Mouse._previousMouseTable = Mouse._mouseTable
    Mouse._mouseTable = input.get(1)
    Mouse.X = Mouse._mouseTable["xmouse"]
    Mouse.Y = Mouse._mouseTable["ymouse"]
end

function Mouse.IsInside(x,y,w,h)
    return Mouse.X > x and Mouse.X < x + w 
        and Mouse.Y > y and Mouse.Y < y + h
end

function Mouse.IsDown()
    -- TODO: left-handed mode support
    return Mouse._mouseTable["leftclick"] and true or false
end

function Mouse.IsClicked()
    -- TODO: left-handed mode support
    return (Mouse._mouseTable["leftclick"] and not Mouse._previousMouseTable["leftclick"]) and true or false
end

function Mouse.ClickedInside(x,y,w,h)
    return Mouse.IsClicked() and Mouse.IsInside(x,y,w,h) == true
end
