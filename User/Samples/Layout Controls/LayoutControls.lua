function UserCodeAtInputPoll()

end

function UserCodeOnInitialize()
        
    local mainScene = Scene:new()


    mainScene:AddControls({
        AmazingStackPanel = StackPanel:new(mainScene, nil, 10, 10, 5, {
            ButtonA = Button:new(mainScene, 0, nil, nil, nil, 80, 25, "Click me", nil, nil),
            ButtonB = Button:new(mainScene, 1, nil, nil, nil, 70, 25, "Click me", nil, nil),
            ToggleButtonC = ToggleButton:new(mainScene, 2, nil, nil, nil, 120, 25, "Switch me", nil, nil),
            ButtonD = Button:new(mainScene, 3, nil, nil, nil, 100, 25, "Click me", nil, nil),
            ButtonE = Button:new(mainScene, 4, nil, nil, nil, 140, 25, "Click me", nil, nil),
        }, false),
    })

    SceneManager.Initialize({
        Main = mainScene,
    }, nil, Windows11Styler:new())

    SceneManager.ChangeScene(Scenes.Main)

end

function UserCodeAtStop()

end

function UserCodeAtVisualInterrupt()

end