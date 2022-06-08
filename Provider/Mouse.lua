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
    Mouse._mouseTable = input.get()
    Mouse.X = Mouse._mouseTable["xmouse"]
    Mouse.Y = Mouse._mouseTable["ymouse"]
end

function Mouse.IsInside(x,y,w,h)
    return Mouse.X > x and Mouse.X < x + w 
        and Mouse.Y > y and Mouse.Y < y + h
end

function Mouse.IsPrimaryDown()
    -- TODO: left-handed mode support
    return Mouse._mouseTable["leftclick"] and true or false
end

function Mouse.IsSecondaryDown()
    -- TODO: left-handed mode support
    return Mouse._mouseTable["rightclick"] and true or false
end

function Mouse.IsPrimaryClicked()
    -- TODO: left-handed mode support
    return (Mouse._mouseTable["leftclick"] and not Mouse._previousMouseTable["leftclick"]) and true or false
end

function Mouse.IsSecondaryClicked()
    -- TODO: left-handed mode support
    return (Mouse._mouseTable["rightclick"] and not Mouse._previousMouseTable["rightclick"]) and true or false
end

function Mouse.IsPrimaryClickedInside(x,y,w,h)
    return Mouse.IsPrimaryClicked() and Mouse.IsInside(x,y,w,h)
end

function Mouse.IsSecondaryClickedInside(x,y,w,h)
    return Mouse.IsSecondaryClicked() and Mouse.IsInside(x,y,w,h)
end
