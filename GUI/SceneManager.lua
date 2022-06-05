Scenes = {}
CurrentScene = nil
SceneManager = {}

function SceneManager.Initialize(scenes)
    Scenes = scenes
end

function SceneManager.ChangeScene(scene)
    CurrentScene.IsActive = false
    CurrentScene = Scenes[scene]
    CurrentScene.IsActive = true
end