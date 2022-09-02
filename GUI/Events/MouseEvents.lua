MouseEvent = {}
function MouseEvent.IsInside(e, x, y, width, height)
    return e.X > x and e.X < x + width and e.Y > y and e.Y < y + height
end

MouseMoveEvent = {}
function MouseMoveEvent.new(x, y)
    return {
        X = x,
        Y = y
    }
end

MouseDownEvent = {}
function MouseDownEvent.new(x, y, button)
    return {
        X = x,
        Y = y,
        Button = button
    }
end

MouseUpEvent = {}
function MouseUpEvent.new(x, y, button)
    return {
        X = x,
        Y = y,
        Button = button
    }
end

MouseEnterEvent = {}
function MouseEnterEvent.new()
    return {}
end

MouseLeaveEvent = {}
function MouseLeaveEvent.new()
    return {}
end
