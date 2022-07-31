Scenes = {}
PersistentScene = nil
CurrentScene = nil
CurrentRenderer = nil
CurrentStyler = nil
SceneManager = {}

function SceneManager.Initialize(scenes, persistentScene, renderer, styler)
    Scenes = scenes
    PersistentScene = persistentScene
    PersistentScene:SetActive(true)
    PersistentScene.HasBackColor = false
    RendererManager.SetCurrentRenderer(renderer)
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

    for k, scene in pairs(Scenes) do
        scene:Update()
    end

    PersistentScene:Update()
    SceneManager.ExecuteQueuedCallbacksForScene(PersistentScene)

    -- update outside of scene context to avoid context switch and thus invalid state
    for k, scene in pairs(Scenes) do
        SceneManager.ExecuteQueuedCallbacksForScene(scene)
    end
    
end

function SceneManager.ExecuteQueuedCallbacksForScene(scene)
    if #scene.QueuedCallbackParameters == #scene.QueuedCallbacks == false then
        scene.QueuedCallbacks = {}
        scene.QueuedCallbackParameters = {}
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