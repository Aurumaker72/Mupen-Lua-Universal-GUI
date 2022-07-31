Program = {

}

function Program.initFrame()
	Memory.UpdatePrevPos()
	Memory.Refresh()
	Joypad.init()
end

function Program.main()
	if Broker.SelectedItem == "Disabled" == false then
		result = Engine.inputsForAngle()
		if Broker.GoalMagnitude then
			Engine.scaleInputsForMagnitude(result, Broker.GoalMagnitude)
		end
		Joypad.set('X', result.X)
		Joypad.set('Y', result.Y)
	end
end
