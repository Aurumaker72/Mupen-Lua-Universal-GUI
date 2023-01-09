StylerManager = {}

function StylerManager.SetCurrentStyler(styler)
    CurrentStyler = styler
    print("Utilizing" .. tostring(CurrentStyler):gsub("instance of class", "") .. " styler")
end
