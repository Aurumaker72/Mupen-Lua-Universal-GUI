function UserCodeAtInputPoll()

end

function UserCodeOnInitialize()

    local mainScene = Scene:new()


    mainScene:AddControls({
        HelloWorldLabel = Label:new(mainScene, nil, 10, 10, "Hello World!"),
        CoolButton = Button:new(mainScene, nil, nil, 10, 40, 80, 25, "Click me", function(o)
            o.Text = "Huzzah!"
        end, nil),
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
