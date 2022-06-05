Label = middleclass('Label', Control)

function Label:initialize(x, y, w, h, text)
    Control.initialize(self, x, y, w, h)
    self.Text = text
end

function Label:Draw()
    if (self.Text) then
        WGUI.DrawText(Appearance.Themes[Appearance.CurrentTheme].BUTTON_FORE_COLOR, self.Text, self.X, self.Y)
    end
end
