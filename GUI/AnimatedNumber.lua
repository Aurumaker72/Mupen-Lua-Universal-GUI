AnimatedNumber = middleclass('AnimatedNumber')

function AnimatedNumber:initialize(currentNumber)
    self.CurrentNumber = currentNumber
    self.targetNumber = currentNumber
    self.overrideTargetNumber = nil
    self.Speed = 0.2
    self.Epsilon = 2
end

function AnimatedNumber:IsLocked()
    return self.overrideTargetNumber and true or false
end

function AnimatedNumber:GetEffectiveTargetNumber()
    if not self.overrideTargetNumber then
        return self.targetNumber
    else
        return self.overrideTargetNumber
    end
end

function AnimatedNumber:SetTargetNumber(targetNumber)
    self.targetNumber = targetNumber
end

function AnimatedNumber:SetNumberImmediately(targetNumber)
    self.targetNumber = targetNumber
    self.CurrentNumber = targetNumber
end

function AnimatedNumber:LockOverride(lockedNumber)
    self.overrideTargetNumber = lockedNumber
end

function AnimatedNumber:UnlockOverride()
    self.overrideTargetNumber = nil
end

function AnimatedNumber:Update()

    local difference = math.abs(self:GetEffectiveTargetNumber() - self.CurrentNumber)

    if difference < self.Epsilon then
        self.CurrentNumber = self:GetEffectiveTargetNumber()
    else
        self.CurrentNumber = math.floor(self.CurrentNumber +
            (self:GetEffectiveTargetNumber() - self.CurrentNumber) * self.Speed)
    end
end

function AnimatedNumber:HasFinished()
    local difference = math.abs(self:GetEffectiveTargetNumber() - self.CurrentNumber)

    return difference < self.Epsilon
end
