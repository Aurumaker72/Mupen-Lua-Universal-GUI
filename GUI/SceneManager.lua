Scenes = {}
CurrentScene = nil
SceneManager = {}
-- Controls which are not associated with a scene and permanently run their logic
-- Use cases: tab control
PersistentControls = {}

function SceneManager.Initialize(scenes, persistentControls)
    Scenes = scenes
    PersistentControls = persistentControls
end

function SceneManager.ChangeScene(scene)
    CurrentScene.IsActive = false
    CurrentScene = Scenes[scene]
    CurrentScene.IsActive = true
end

function SceneManager.Update()
    if CurrentScene.IsActive then
        CurrentScene:Update(CurrentScene)
    end
    for key, control in pairs(PersistentControls) do
        control:Update()
    end
end

function SceneManager.Draw()
    if CurrentScene.IsActive then
        CurrentScene:Draw(CurrentScene)
    end
    for key, control in pairs(PersistentControls) do
        control:Draw()
    end
end