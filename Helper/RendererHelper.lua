RendererHelper = {}

function RendererHelper.DarkenRGBColor(darken, rgb)
    return {
        Numeric.Clamp(rgb[1] - darken, 0, 255),
        Numeric.Clamp(rgb[2] - darken, 0, 255),
        Numeric.Clamp(rgb[3] - darken, 0, 255),
    }
end
