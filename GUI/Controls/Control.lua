
Control = middleclass('Control')

function Control:initialize(x,y,w,h)
	self.X = (x * Screen.Dimensions.ScalingX  + Screen.Dimensions.Width - Screen.ExpandedOffset)
	self.Y = y * Screen.Dimensions.ScalingY
	self.Width = w * Screen.Dimensions.ScalingX
	self.Height = h * Screen.Dimensions.ScalingY
	self.IsCapturingMouse = false
	self.Ticks = 0
end

function Control:GetRight()
	return self.X + self.Width
end

function Control:GetBottom()
	return self.Y + self.Height
end

function Control:PersistentUpdate() end
function Control:Update() end
function Control:Draw() end

function Control:PointToSelf(x,y)


end