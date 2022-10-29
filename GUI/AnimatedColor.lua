AnimatedColor = middleclass('AnimatedColor')

function AnimatedColor:initialize(currentColor)
    if type(currentColor) == "string" then
        print("DO NOT PASS HEX STRINGS")
    end
    self.CurrentColor = currentColor
    self.targetColor = currentColor
    self.overrideTargetColor = nil
    self.Speed = 0.1
    self.Epsilon = 5
end

function AnimatedColor:GetCompletion()
    return ((self.CurrentColor[1] + self.CurrentColor[2] + self.CurrentColor[3]) / 3) /
    ((self.targetColor[1] + self.targetColor[2] + self.targetColor[3]) / 3)
end

function AnimatedColor:IsLocked()
    return self.overrideTargetColor and true or false 
end

function AnimatedColor:GetEffectiveTargetColor()
    if not self.overrideTargetColor then
        return self.targetColor
    else
       return self.overrideTargetColor 
    end
end

function AnimatedColor:SetTargetColor(targetColor)
    if type(targetColor) == "string" then
        print("DO NOT PASS HEX STRINGS")
    end
    self.targetColor = targetColor
end

function AnimatedColor:SetColorImmediately(color)
    if type(color) == "string" then
        print("DO NOT PASS HEX STRINGS")
    end
    self.overrideTargetColor = nil
    self.CurrentColor = color
    self.targetColor = color
end

function AnimatedColor:LockOverride(lockedColor)
    if type(lockedColor) == "string" then
        print("DO NOT PASS HEX STRINGS")
    end
    self.overrideTargetColor = lockedColor
end

function AnimatedColor:UnlockOverride()
    self.overrideTargetColor = nil
end

function AnimatedColor:Update()

    local differenceR = math.abs(self:GetEffectiveTargetColor()[1] - self.CurrentColor[1])
    local differenceG = math.abs(self:GetEffectiveTargetColor()[2] - self.CurrentColor[2])
    local differenceB = math.abs(self:GetEffectiveTargetColor()[3] - self.CurrentColor[3])

    if (differenceR + differenceG + differenceB) / 3 < self.Epsilon then
        self.CurrentColor = self:GetEffectiveTargetColor()
    else
        self.CurrentColor[1] = math.floor(self.CurrentColor[1] + (self:GetEffectiveTargetColor()[1] - self.CurrentColor[1]) * self.Speed)
        self.CurrentColor[2] = math.floor(self.CurrentColor[2] + (self:GetEffectiveTargetColor()[2] - self.CurrentColor[2]) * self.Speed)
        self.CurrentColor[3] = math.floor(self.CurrentColor[3] + (self:GetEffectiveTargetColor()[3] - self.CurrentColor[3]) * self.Speed)    
    end
end

function AnimatedColor:SetTargetColorWeak(targetColor)
    if type(targetColor) == "string" then
        print("did you forget again")
    end
    if not self.overrideTargetColor then
        self.targetColor = targetColor
    end
end

function AnimatedColor:HasFinished()
    local differenceR = math.abs(self:GetEffectiveTargetColor()[1] - self.CurrentColor[1])
    local differenceG = math.abs(self:GetEffectiveTargetColor()[2] - self.CurrentColor[2])
    local differenceB = math.abs(self:GetEffectiveTargetColor()[3] - self.CurrentColor[3])

    return (differenceR + differenceG + differenceB) / 3 < self.Epsilon
end
