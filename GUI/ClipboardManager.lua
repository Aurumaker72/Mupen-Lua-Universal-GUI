ClipboardManager = {
    ClipboardBuffer = ""
}

function ClipboardManager.IsValidString(str)
    return str and str:len() > 0
end

function ClipboardManager.Copy(str)
    if ClipboardManager.IsValidString(str) then
        ClipboardManager.ClipboardBuffer = str
    end
end

function ClipboardManager.Paste(fallbackValue)
    if ClipboardManager.IsValidString(ClipboardManager.ClipboardBuffer) then
        fallbackValue = ClipboardManager.ClipboardBuffer
    end
    return fallbackValue
end