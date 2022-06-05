Screen = {
    IsExpanded = false,
    ExpandedOffset = 200,
    Dimensions = {
        InitialWidth = 0,
        InitialHeight = 0,
        Width = 0,
        Height = 0,
    }
}


function Screen.Dimensions.Update()
    d = wgui.info()
    Screen.Dimensions.Width = d.width
    Screen.Dimensions.Height = d.height
    if Screen.Dimensions.InitialWidth == 0 or Screen.Dimensions.InitialHeight == 0 then
        Screen.Dimensions.InitialWidth = d.width
        Screen.Dimensions.InitialHeight = d.height
    end
end

function Screen.Expand()
    Screen.Dimensions.Update()
    -- Don't expand if already expanded
    if Screen.IsExpanded then
        return
    end

    wgui.resize(Screen.Dimensions.Width + Screen.ExpandedOffset, Screen.Dimensions.Height)
    Screen.Dimensions.Update()
    IsExpanded = true

end

function Screen.Contract()
    wgui.resize(Screen.Dimensions.InitialWidth, Screen.Dimensions.InitialHeight)
end
