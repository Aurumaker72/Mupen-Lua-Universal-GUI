Scenes = {}
CurrentScene = nil
CurrentRenderer = nil
SceneManager = {}
-- Controls which are not associated with a scene and permanently run their logic
-- Use cases: tab control
PersistentControls = {}

function SceneManager.Initialize(scenes, persistentControls, renderer)
    Scenes = scenes
    PersistentControls = persistentControls
    CurrentRenderer = renderer
    print("Utilizing " .. (CurrentRenderer.IsStable and "stable" or "unstable") .. tostring(CurrentRenderer):gsub("instance of class", "") .. " backend")
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
end