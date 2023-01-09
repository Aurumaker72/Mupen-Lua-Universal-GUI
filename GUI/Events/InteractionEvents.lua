InteractionEvent = {
    KeyboardSource = 0,
    MouseSource = 1,
}

PrimaryInteractionEvent = {}
function PrimaryInteractionEvent.new(key, source)
    return {
        Key = key,
        Source = source
    }
end

InteractionBeginEvent = {}
function InteractionBeginEvent.new(source)
    return {
        Source = source
    }
end

InteractionEndEvent = {}
function InteractionEndEvent.new(source)
    return {
        Source = source
    }
end
