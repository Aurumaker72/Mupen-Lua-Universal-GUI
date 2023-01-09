RendererManager = {}

function RendererManager.SetCurrentRenderer(renderer)
    CurrentRenderer = renderer
    print("Utilizing " ..
        (CurrentRenderer.IsStable and "stable" or "unstable") ..
        tostring(CurrentRenderer):gsub("instance of class", "") .. " renderer")
end
