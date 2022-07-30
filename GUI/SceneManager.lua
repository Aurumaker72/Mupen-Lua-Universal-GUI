Scenes = {}
CurrentScene = nil
CurrentRenderer = nil
CurrentStyler = nil
SceneManager = {}
-- Controls which are not associated with a scene and permanently run their logic
-- Use cases: tab control
PersistentControls = {}

function SceneManager.Initialize(scenes, persistentControls, renderer, styler)
    Scenes = scenes
    PersistentControls = persistentControls
    RendererManager.SetCurrentRenderer(renderer)
    StylerManager.SetCurrentStyler(styler)
end

function SceneManager.ChangeScene(scene)
    CurrentScene.IsActive = false
    CurrentScene = Scenes[scene]
    CurrentScene.IsActive = true
end

function SceneManager.Update()

    for k, scene in pairs(Scenes) do
        scene:Update(scene)
    end

    for key, control in pairs(PersistentControls) do
        control:PersistentUpdate()
        control:Update()
    end

    -- update outside of scene context to avoid context switch and thus invalid state
    for k, scene in pairs(Scenes) do
        for i = 1, #scene.QueuedCallbacks, 1 do
            scene.QueuedCallbacks[i](scene.QueuedCallbackParameters[i])
            scene.QueuedCallbacks[i] = nil
            scene.QueuedCallbackParameters[i] = nil
        end
    end
    
end

function SceneManager.Draw()

    CurrentScene:Draw(CurrentScene)

    for key, control in pairs(PersistentControls) do
        control:Draw()
    end

    CurrentRenderer:FinalizeFrame()
    
end