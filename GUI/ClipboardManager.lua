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

function ClipboardManager.Paste(placeholder)
    if ClipboardManager.IsValidString(ClipboardManager.ClipboardBuffer) then
        placeholder = ClipboardManager.ClipboardBuffer
    end
    return placeholder
end