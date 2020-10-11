local start = script.Parent:WaitForChild'Start'
local derev = script.Parent:WaitForChild'DeRev'
local derevlow = script.Parent:WaitForChild'DeRevLow'
local idleloop = script.Parent:WaitForChild'IdleLoop'
local lowrev = script.Parent:WaitForChild'LowRev'
local lowrev2 = script.Parent:WaitForChild'LowRev2'
local prevthrot = 0

while true do
	wait(0)
	local seat = script.Parent.Parent.VehicleSeat
	local throttle = seat.Throttle
	local speed = seat.Velocity.magnitude
	if throttle ~= prevthrot then
		if throttle == 1 then
			if speed < 30 then
				derev:Stop()
				lowrev:Stop()
				lowrev2:Stop()
				lowrev2:Play()
			else
				derev:Stop()
				lowrev:Stop()
				lowrev2:Stop()
				lowrev:Play()
			end
		end
		if throttle == 0 then
			derev:Stop()
			lowrev:Stop()
			lowrev2:Stop()
			derev:Play()
		end
	end
	prevthrot = throttle
end