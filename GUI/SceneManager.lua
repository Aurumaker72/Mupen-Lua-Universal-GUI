Scenes = {}
PersistentScene = nil
CurrentScene = nil
CurrentRenderer = nil
CurrentStyler = nil
SceneManager = {}

function SceneManager.Initialize(scenes, persistentScene, styler)
    Scenes = scenes
    if not persistentScene then
        persistentScene = Scene:new()
    end
    PersistentScene = persistentScene
    PersistentScene:SetActive(true)
    PersistentScene.HasBackColor = false
    StylerManager.SetCurrentStyler(styler)
end

function SceneManager.ChangeScene(scene)
    if CurrentScene then
        CurrentScene:SetActive(false)
    end
    CurrentScene = scene
    CurrentScene:SetActive(true)
    
    -- perform layout pass
    -- TODO: optimize to only do it once per scene
    
end

function SceneManager.Update()

    -- perform relayout if necessary
    for k, scene in pairs(Scenes) do
        scene:Relayout()
    end
    PersistentScene:Relayout()
    
    -- update all scenes
    for k, scene in pairs(Scenes) do
        scene:Update()
    end
    PersistentScene:Update()

    -- propagate events
    for k, scene in pairs(Scenes) do
        EventManager.PropagateTo(k, scene)
    end
    EventManager.PropagateTo("persistentScene", PersistentScene)

    Appearance.FinalizeFrame()

    -- execute their queued logic
    for k, scene in pairs(Scenes) do
        SceneManager.ExecuteQueuedCallbacksForScene(scene)
    end
    SceneManager.ExecuteQueuedCallbacksForScene(PersistentScene)

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

    CurrentScene:Draw()
    PersistentScene:Draw()

    CurrentRenderer:FinalizeFrame()
    
end