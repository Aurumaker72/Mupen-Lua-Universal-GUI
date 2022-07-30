StylerManager = {}

function StylerManager.SetCurrentStyler(styler)
    CurrentStyler = styler
    print("Utilizing " .. tostring(CurrentRenderer):gsub("instance of class", "") .. " styler")
end