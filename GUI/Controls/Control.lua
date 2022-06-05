
Control = middleclass('Control')

function Control:initialize(x,y,w,h)
	self.X = x + Screen.Dimensions.Width - Screen.ExpandedOffset
	self.Y = y
	self.Width = w
	self.Height = h
	self.IsCapturingMouse = false
end

function Control:GetRight()
	return self.X + self.Width
end

function Control:GetBottom()
	return self.Y + self.Height
end

function Control:Update() end
function Control:Draw() end

function Control:PointToSelf(x,y)


end