Screen = {
    IsExpanded = false,
    ExpandedOffset = nil,
    DesignerWidth = 800,
    DesignerHeight = 600,
    Dimensions = {
        InitialWidth = 0,
        InitialHeight = 0,
        Width = 0,
        Height = 0,
        ScalingX = 1,
        ScalingY = 1
    }
}

function Screen.Dimensions.Update()
    d = wgui.info()
    Screen.Dimensions.Width = d.width
    Screen.Dimensions.Height = d.height
    
    if Screen.Dimensions.InitialWidth == 0 or Screen.Dimensions.InitialHeight == 0 then
        Screen.Dimensions.InitialWidth = d.width
        Screen.Dimensions.InitialHeight = d.height

        if Screen.Dimensions.Width < Screen.DesignerWidth then
            Screen.Dimensions.ScalingX = Screen.Dimensions.Width / Screen.DesignerWidth
        end
        if Screen.Dimensions.Height < Screen.DesignerHeight then
            Screen.Dimensions.ScalingY = Screen.Dimensions.Height / Screen.DesignerHeight
        end
        Screen.ExpandedOffset = 227 * Screen.Dimensions.ScalingX

    end
end

function Screen.Expand()
    Screen.Dimensions.Update()
    -- Don't expand if already expanded
    if Screen.IsExpanded then
        return
    end

    wgui.resize(math.tointeger(math.floor(Screen.Dimensions.Width + (Screen.ExpandedOffset))), Screen.Dimensions.Height)
    Screen.Dimensions.Update()
    IsExpanded = true

end

function Screen.Contract()
    wgui.resize(Screen.Dimensions.InitialWidth, Screen.Dimensions.InitialHeight)
end
