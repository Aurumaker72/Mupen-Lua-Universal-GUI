Engine = {

}

function Engine.getEffectiveAngle(angle)
	return angle - (angle % 16)
end
function Engine.getDyaw(angle)
	if Settings.Left == true and Settings.Right == false then
		return Memory.Mario.FacingYaw + angle
	elseif Settings.Left == false and Settings.Right == true then
		return Memory.Mario.FacingYaw - angle
	elseif Settings.Left == true and Settings.Right == true then
		return Memory.Mario.FacingYaw + angle*(math.pow(-1,Memory.Mario.GlobalTimer % 2))
	else
		return angle
	end
end
function Engine.getDyawsign()
	if Settings.Left == true and Settings.Right == false then
		return 1
	elseif Settings.Left == false and Settings.Right == true then
		return -1
	elseif Settings.Left == true and Settings.Right == true then
		return math.pow(-1,Memory.Mario.GlobalTimer)
	else
		return 0
	end
end
ENABLE_REVERSE_ANGLE_ON_WALLKICK = 1
actionflag = 0
speedsign = 0
targetspeed = 0.0
function Engine.getgoal(targetspd) -- getting angle for target speed
	if (targetspd >= 0) then
	return math.floor(math.acos((targetspd+0.35-Memory.Mario.FSpeed)/1.5)*32768/math.pi)
	elseif (targetspd < 0) then
	return math.floor(math.acos((targetspd-0.35-Memory.Mario.FSpeed)/1.5)*32768/math.pi)
	end
end

function Engine.inputsForAngle()
	goal = Engine.getEffectiveAngle(Settings.goalAngle)
	if (Settings.SelectedItem == "MatchYaw") then
		goal = Engine.getEffectiveAngle(Memory.Mario.FacingYaw)
		if ((Memory.Mario.Action == 0x000008A7 or Memory.Mario.Action == 0x010208B6 or Memory.Mario.Action == 0x010208B0 or Memory.Mario.Action == 0x08100340 or Memory.Mario.Action == 0x00100343) and ENABLE_REVERSE_ANGLE_ON_WALLKICK == 1) then
			goal = (goal + 32768) % 65536
		end
	end
	if (Settings.SelectedItem == "ReverseAngle") then
		goal = Engine.getEffectiveAngle(Memory.Mario.FacingYaw) + 32768 % 65536
		if ((Memory.Mario.Action == 0x000008A7 or Memory.Mario.Action == 0x010208B6 or Memory.Mario.Action == 0x010208B0 or Memory.Mario.Action == 0x08100340 or Memory.Mario.Action == 0x00100343) and ENABLE_REVERSE_ANGLE_ON_WALLKICK == 1) then
		goal = Engine.getEffectiveAngle(Memory.Mario.FacingYaw)
		end
	end
	    -- Set up target speed
		if (Settings.TargetStrain == true) then
			ENABLE_TARGET_SPEED = 1
		else
			ENABLE_TARGET_SPEED = 0
		end
		if (Settings.Always == true) then
			offset = 3
		else
			offset = 0
		end
	if (ENABLE_TARGET_SPEED == 1) then
		if Memory.Mario.Action == 0x04000440 or Memory.Mario.Action == 0x0400044A or Memory.Mario.Action == 0x08000239 or Memory.Mario.Action == 0x0C000232 or Memory.Mario.Action == 0x04000442 or Memory.Mario.Action == 0x04000443 or Memory.Mario.Action == 0x010208B7 or Memory.Mario.Action == 0x04000445 or Memory.Mario.Action == 0x00840454 or Memory.Mario.Action == 0x00840452 or (Memory.Mario.Action > 0x0400046F and Memory.Mario.Action < 0x04000474) or (Memory.Mario.Action > 0x00000473 and Memory.Mario.Action < 0x00000478) then
			actionflag=1
		else
			actionflag=0
		end
		if ( Memory.Mario.FSpeed > 937/30 and Memory.Mario.FSpeed < 31.9 + offset*3000000 and (Memory.Mario.Action == 0x04808459 or Memory.Mario.Action == 0x00000479) and Settings.SelectedItem == "MatchYaw")  then
			targetspeed = 48 - Memory.Mario.FSpeed/2
			if ( Memory.Mario.FSpeed > 32 ) then targetspeed = Memory.Mario.FSpeed end
			speedsign = 1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
		elseif ( Memory.Mario.FSpeed > -337/30 - offset/1.5 and Memory.Mario.FSpeed < -9.9 and Memory.Mario.Action == 0x00000479 and Settings.SelectedItem == "ReverseAngle") then
			targetspeed = -16 - Memory.Mario.FSpeed/2
			if ( Memory.Mario.FSpeed < -11.9 ) then targetspeed = targetspeed - 2 end
			speedsign = -1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
		elseif ( Memory.Mario.FSpeed > 46.85 and Memory.Mario.FSpeed < 47.85 + offset and  Memory.Mario.Action == 0x03000888 and Settings.SelectedItem == "MatchYaw") then
			targetspeed = 48
			if ( Memory.Mario.FSpeed > 49.85 ) then targetspeed = targetspeed + 1 end
			speedsign = 1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
		elseif ( Memory.Mario.FSpeed > 30.85 and Memory.Mario.FSpeed < 31.85 + offset and actionflag == 0 and Memory.Mario.Action ~= 0x03000888 and Memory.Mario.Action ~= 0x00000479 and Memory.Mario.Action ~= 0x04808459 and Settings.SelectedItem == "MatchYaw" ) then
			targetspeed = 32
			if ( Memory.Mario.FSpeed > 33.85 ) then targetspeed = targetspeed + 1 end
			speedsign = 1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
			if (Memory.Mario.Action == 0x000008A7 or Memory.Mario.Action == 0x010208B6 or Memory.Mario.Action == 0x010208B0 or Memory.Mario.Action == 0x08100340 or Memory.Mario.Action == 0x00100343) then
				goal = (goal + 32768) % 65536
			end
		elseif ( Memory.Mario.FSpeed > -16.85 - offset and Memory.Mario.FSpeed < -14.85 and Memory.Mario.Action ~= 0x00000479 and actionflag == 0 and Settings.SelectedItem == "ReverseAngle" ) then
			targetspeed = -16
			if ( Memory.Mario.FSpeed < -17.85 ) then targetspeed = targetspeed - 2 end
			speedsign = -1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
		elseif ( Memory.Mario.FSpeed > -21.0625 - offset/0.8 and Memory.Mario.FSpeed < -18.5625 and Memory.Mario.Action ~= 0x00000479 and (actionflag == 1 or Memory.Mario.Action == 0x04808459) and Settings.SelectedItem == "ReverseAngle" ) then
			targetspeed = -16 + Memory.Mario.FSpeed/5
			if ( Memory.Mario.FSpeed < -22.3125 ) then targetspeed = targetspeed - 2 end
			speedsign = -1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
		elseif ( Memory.Mario.FSpeed > 38.5625 and Memory.Mario.FSpeed < 39.8125 + offset/0.9 and Memory.Mario.Action ~= 0x00000479 and Memory.Mario.Action ~= 0x03000888 and actionflag == 1 and Settings.SelectedItem == "MatchYaw") then
			targetspeed = 32 + Memory.Mario.FSpeed/5
			if ( Memory.Mario.FSpeed > 42.3125 ) then targetspeed = targetspeed + 1 end
			speedsign = 1
			goal = Engine.getEffectiveAngle(Engine.getDyaw(Engine.getgoal(targetspeed)))
		else
			speedsign = 0
		end
		goal = goal + 32 * speedsign * Engine.getDyawsign()
	end
	if (Settings.SelectedItem == "MatchAngle" and Settings.DYaw == true) then
		print("a")
		goal = Engine.getEffectiveAngle(Engine.getDyaw(goal))
		if (Memory.Mario.Action == 0x000008A7 or Memory.Mario.Action == 0x010208B6 or Memory.Mario.Action == 0x010208B0 or Memory.Mario.Action == 0x08100340 or Memory.Mario.Action == 0x00100343 and ENABLE_REVERSE_ANGLE_ON_WALLKICK == 1) then
			goal = (goal + 32768) % 65536
		end
	end
	goal = goal - 65536
	while (Engine.getEffectiveAngle(Memory.Camera.Angle) > goal) do
		goal = goal + 65536
	end
	-- Set up binary search
	minang = 1
	maxang = Angles.COUNT
	midang = math.floor((minang + maxang) / 2)
	-- Binary search
	while (minang <= maxang) do
		if (Engine.getEffectiveAngle(Angles.ANGLE[midang].angle + Memory.Camera.Angle) < goal) then
			minang = midang + 1
		elseif (Engine.getEffectiveAngle(Angles.ANGLE[midang].angle + Memory.Camera.Angle) == goal) then
			minang = midang
			maxang = midang - 1
		else
			maxang = midang - 1
		end
		midang = math.floor((minang + maxang) / 2)
	end
	-- If binary search fails, optimal angle is between Angles.Count and 1. Checks which one is closer.
	if minang > Angles.COUNT then
		minang = 1
		if math.abs(Engine.getEffectiveAngle(Angles.ANGLE[1].angle + Memory.Camera.Angle) - (goal - 65536)) > math.abs(Engine.getEffectiveAngle(Angles.ANGLE[Angles.COUNT].angle + Memory.Camera.Angle) - goal) then
			minang = Angles.COUNT
		end
	end
	--[[if ((math.cos((Engine.getEffectiveAngle(Angles.ANGLE[minang].angle - Memory.Mario.FacingYaw))*math.pi/32768)*1.5 + Memory.Mario.FSpeed - 0.35) > targetspeed and speedsign == 1) then
		minang = minang + 1
	elseif ((math.cos((Engine.getEffectiveAngle(Angles.ANGLE[minang].angle - Memory.Mario.FacingYaw))*math.pi/32768)*1.5 + Memory.Mario.FSpeed + 0.35) < -16 and speedsign == -1 ) then
			minang = minang - 1
	end--]]
	--[[if (Angles.ANGLE[minang].angle + Memory.Camera.Angle) % 65536 < goal and speedsign == 1 then
		minang = minang + 1
		if minang > Angles.COUNT then
			minang = 1
		end
	elseif (Angles.ANGLE[minang].angle + Memory.Camera.Angle) % 65536 > goal and  speedsign == -1 then
		minang = minang - 1
		if minang < 1 then
			minang = Angles.COUNT 
		end
	end--]]
	return {
		angle = (Angles.ANGLE[minang].angle + Memory.Camera.Angle) % 65536,
		X = Angles.ANGLE[minang].X,
		Y = Angles.ANGLE[minang].Y
	}	
end

function Engine.GetQFs(Mariospeed)
	-- print(math.sqrt(math.abs(math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.PreviousPos.X))) - math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.Mario.X)))) ^ 2 + math.abs(math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.PreviousPos.Z))) - math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.Mario.Z)))) ^ 2))
	-- return math.floor(4 * (math.sqrt(math.abs(math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.PreviousPos.X))) - math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.Mario.X)))) ^ 2 + math.abs(math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.PreviousPos.Z))) - math.abs(MoreMaths.hexToFloat(string.format("%x", Memory.Mario.Z)))) ^ 2)) / math.abs(Mariospeed))
end

function Engine.GetSpeedEfficiency()
	if Memory.Mario.XSlideSpeed + Memory.Mario.ZSlideSpeed > 0 then
		return MoreMaths.Round(Engine.GetDistMoved() / math.abs(math.sqrt(MoreMaths.DecodeDecToFloat(Memory.Mario.XSlideSpeed) ^ 2 + MoreMaths.DecodeDecToFloat(Memory.Mario.ZSlideSpeed) ^ 2)) * 100, 5)
	else
		return 0
	end
end

function Engine.GetDistMoved()
	return math.sqrt((MoreMaths.DecodeDecToFloat(Memory.PreviousPos.X) - MoreMaths.DecodeDecToFloat(Memory.Mario.X)) ^ 2 + (MoreMaths.DecodeDecToFloat(Memory.PreviousPos.Z) - MoreMaths.DecodeDecToFloat(Memory.Mario.Z)) ^ 2)
end

function Engine.GetCurrentAction()
	for i = 1, Actions.COUNT, 1
	do
		if Actions.ACTION[i].value == Memory.Mario.Action then
			return Actions.ACTION[i].name
		end
	end
	return "INVALID ACTION"
end

function Engine.GetTotalDistMoved()
	eckswhy = (Settings.DistAxisX - MoreMaths.DecodeDecToFloat(Memory.Mario.X)) ^ 2 + (Settings.DistAxisZ - MoreMaths.DecodeDecToFloat(Memory.Mario.Z)) ^ 2
	if (Settings.IgnoreY == false) then
		eckswhy = eckswhy + (Settings.DistAxisY - MoreMaths.DecodeDecToFloat(Memory.Mario.Y)) ^ 2
	end
	return math.sqrt(eckswhy)
end

function Engine.GetHSlidingSpeed()
	return math.sqrt(MoreMaths.DecodeDecToFloat(Memory.Mario.XSlideSpeed) ^ 2 + MoreMaths.DecodeDecToFloat(Memory.Mario.ZSlideSpeed) ^ 2)
end

local function magnitude(x, y)
	return math.sqrt(math.max(0, math.abs(x)-6)^2 + math.max(0, math.abs(y)-6)^2)
end
local function clamp(min, n, max)
	if n < min then return min end
	if n > max then return max end
	return n
end
local function effectiveAngle(x,y)
	if math.abs(x) < 8 then
		x = 0
	elseif x > 0 then
		x = x - 6
	else
		x = x + 6
	end
	if math.abs(y) < 8 then
		y = 0
	elseif y > 0 then
		y = y - 6
	else
		y = y + 6
	end
	return math.atan2(-y, x)
end

function Engine.scaleInputsForMagnitude(result, goal_mag)
	if goal_mag >= 127 then return end

	local start_x, start_y = result.X, result.Y
	local current_mag = magnitude(start_x, start_y)
	local ideal_x, ideal_y = start_x * goal_mag/current_mag, start_y * goal_mag/current_mag
	--print(magnitude(ideal_x, ideal_y))
	--print(goal_mag)
	
	--local x0, y0 = math.floor(ideal_x), math.floor(ideal_y)
	--local x0, y0 = 0, 0
	
	local x0, y0 = 0, 0
	if start_x == 0 then
		y0 = goal_mag + 6
	elseif start_y == 0 then
		x0 = goal_mag + 6
	else
		-- https://www.wolframalpha.com/input/?i=solve+%7Bsqrt%28%28x0-6%29%C2%B2+%2B+%28y0-6%29%5E2%29+%3D+k%3B+atan2%28y%2Cx%29+%3D+atan2%28y0%2Cx0%29+%7D+for+x0+and+y0
		local k = goal_mag
		local x,y = math.abs(start_x), math.abs(start_y)
		local x2,y2 = x*x, y*y
		local crazy = math.sqrt((4*(k^2 - 72)*y2)/(x2 + y2) + (y2*(-12*x - 12*y)^2)/(x2 + y2)^2)
		--print(crazy)
		x0 = math.floor(math.abs(x*crazy/(2*y) + (6*x2)/(x2 + y2) + (6*x*y)/(x2 + y2)))
		y0 = math.floor(math.abs(0.5*crazy + (6*y2)/(x2 + y2) + (6*x*y)/(x2 + y2)))
	end
	if start_x < 0 then
		x0 = -x0
	end
	if start_y < 0 then
		y0 = -y0
	end
	if x0 ~= x0 then x0 = 0 end -- NaN?
	if y0 ~= y0 then y0 = 0 end

	-- search neighbourhood for input with greatest component in goal direction
	local closest_x, closest_y = x0, y0
	local err = -1
	local goal_angle = effectiveAngle(start_x,start_y)
	for i = -32,32 do
		for j = -32,32 do
			local x, y = clamp(-127, x0+i, 127), clamp(-127, y0+j, 127)
			--print(string.format("%d,%d", x, y))
			local mag = magnitude(x, y)
			if (mag <= goal_mag) and (mag >= err) then
				local angle = effectiveAngle(x,y)
				--print(string.format("%d:%d: %f (%f)", x,y,angle,goal_angle))
				local this_err = math.cos(angle - goal_angle)*mag
				--print(string.format("%d,%d: %f, %d; %f, %f; %f, %s", x, y, mag, goal_mag, angle, goal_angle, this_err, tostring(err)))
				if this_err > err then
					err = this_err
					closest_x, closest_y = x, y
				end
			end
		end
	end

	closest_x = clamp(-127, closest_x, 127)
	closest_y = clamp(-127, closest_y, 127)
	if math.abs(closest_x) < 8 then closest_x = 0 end
	if math.abs(closest_y) < 8 then closest_y = 0 end

	result.X, result.Y = closest_x, closest_y 
end
