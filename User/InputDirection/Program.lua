Program = {

}

function Program.initFrame()
	Memory.UpdatePrevPos()
	Memory.Refresh()
	Joypad.init()
end

function Program.main()
	if Settings.SelectedItem == "Disabled" == false then
		result = Engine.inputsForAngle()
		if Settings.goalMag then
			Engine.scaleInputsForMagnitude(result, Settings.goalMag)
		end
		Joypad.set('X', result.X)
		Joypad.set('Y', result.Y)
	end
end
