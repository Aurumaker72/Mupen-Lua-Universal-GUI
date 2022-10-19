Scenes = {}
CurrentScene = nil
CurrentRenderer = nil
CurrentStyler = nil
SceneManager = {}

function SceneManager.Initialize(scenes, persistentScene, styler)
    Scenes = scenes
    if not persistentScene then
        persistentScene = Scene:new()
    end

    StylerManager.SetCurrentStyler(styler)

    persistentScene:SetActive(true)
    persistentScene.HasBackColor = false
    Scenes["PersistentScene"] = persistentScene
end

function SceneManager.ChangeScene(scene)
    if CurrentScene then
        CurrentScene:SetActive(false)
    end
    if scene then
        CurrentScene = scene
        CurrentScene:SetActive(true)
    else
        print("passed nil scene")
    end
end

function SceneManager.Update()

    -- relayout and push controls if needed
    for k, scene in pairs(Scenes) do
        if scene.NeedsRelayout then
            scene:Relayout()
        end
    end

    -- propagate events
    for k, scene in pairs(Scenes) do
        EventManager.PropagateTo(k, scene)
    end

    -- update all scenes
    for k, scene in pairs(Scenes) do
        scene:Update()
    end

    Appearance.FinalizeFrame()

    -- execute their queued logic
    for k, scene in pairs(Scenes) do
        SceneManager.ExecuteQueuedCallbacksForScene(scene)
    end



end

function SceneManager.ExecuteQueuedCallbacksForScene(scene)
    if #scene.QueuedCallbackParameters == #scene.QueuedCallbacks == false then
        scene.QueuedCallbacks = {}
        scene.QueuedCallbackParameters = {}
        print("Mismatch in quantity of parameters and callbacks, this pass will be skipped")
    end
    for i = 1, #scene.QueuedCallbacks, 1 do
        scene.QueuedCallbacks[i](scene.QueuedCallbackParameters[i])
        scene.QueuedCallbacks[i] = nil
        scene.QueuedCallbackParameters[i] = nil
    end
end

function SceneManager.Draw()

    if CurrentScene then
        CurrentScene:Draw()
    else
        CurrentRenderer:DrawPlaceholder(Screen.Dimensions.Width - Screen.ExpandedOffset, 0, Screen.ExpandedOffset, Screen.Dimensions.Height)
    end

    if Scenes["PersistentScene"] then
        Scenes["PersistentScene"]:Draw()
    end

    CurrentRenderer:FinalizeFrame()

end
