local module = {}

--For up/down movement, use asin(lookVectorOfCamera.Y) to get the x angle.
--For right/left movement, use atan2(lookVectorOfCamera.z,lookVectorOfCamera.x) to get the z angle.
player = game.Players.LocalPlayer
mouse = player:GetMouse()
cam = game.Workspace.CurrentCamera
good = true
cn = nil
aiming = false
sprinting = false
gui = nil
icon = nil
reloading = false
leaningLeft = false
leaningRight = false
wait(0.5)
RightIdle = nil
LeftIdle = nil
RightAim = nil
LeftAim = nil
Reload1 = nil
Reload2 = nil
Reload3 = nil
ArmReload1 = nil
ArmReload2 = nil
ArmReload3 = nil
ArmReload4 = nil

local aimTrack = nil
local reloadTrack = nil
local idleTrack = nil

local tgun = nil

correction = nil

local animateLoop = nil
sensitivity = 0.5

recoil = Vector3.new(0,0,0)

x = 0
z = 0
x1 = -1
x2 = -1

ofs = Vector3.new(0,0,0)

shootFactor = Vector3.new(0,0,0)
reloadSeq = Vector3.new(0,0,0)

local targetFOV = 70

idle = nil
sight = nil
none = nil

crntPos = idle
crntRot = none
equipped = false

local gun = nil

local sprintFrame = CFrame.Angles(0, -math.pi / 8, 0) * CFrame.Angles(math.pi / 4, 0, 0)

bPart = nil
pWeld = nil
gWeld = nil
aWeld = nil
aWeld2 = nil
fArm = nil
fArm2 = nil
fWeld = nil
fWeld2 = nil
pos1 = false
pos2 = false

leanRight = nil

function detSmooth(y)
	if y < 2 then
		return y + 0.1
	end
	return 2
end

function detSmooth2(y)
	if y > -2 then
		return y - 0.1
	end
	return -2
end

function detOffset()
	if leaningLeft then
		x = detSmooth2(x)
	end
	if leaningRight then
		x = detSmooth(x)
	end
	if not leaningLeft and not leaningRight then
		x = 0
	end
	if char.Humanoid.WalkSpeed == 5 then
		return Vector3.new(x, -1.23, 0)
	end
	return Vector3.new(x, 0, 0)
end

function detTwist()
	hum = player.Character.Humanoid
	return cam.CFrame:vectorToObjectSpace(hum.MoveDirection).x * 5
end

function bob()
	hum = player.Character.Torso
	if hum.Velocity.Magnitude > 2 then
		if sprinting then
			return Vector3.new(0, math.sin(tick()* 12) / 20, math.sin(tick()* 12) / 20)
		end
		if aiming then
			local bobz = math.sin(tick()* 8)
			return Vector3.new(0, math.sin(tick()* 10) / 40, math.sin(tick()* 5) / 40)
		else
			local bobz = math.sin(tick()* 8)
			return Vector3.new(0, math.sin(tick()* 14) / 18, math.sin(tick()* 7) / 18)
		end
	end
	if aiming then
		return Vector3.new()
	else
		local bobz = math.sin(tick())
		return Vector3.new(bobz / 80, bobz / 80, 0)
	end
end

function turn()
	hum = player.Character.Torso
	if hum.Velocity.Magnitude > 2 and not aiming and not sprinting then
		return math.sin(tick() * 10) / 60
	else
		return 0
	end
end

function lerp(a, b, alpha)
	return a + (b - a) * alpha
end

module.unequipped = function()

	idleTrack:Stop()
	aimTrack:Stop()
	reloadTrack:Stop()

	gui.Crosshairs.Visible = true
	gui.Crosshairs.img.ImageTransparency = 0
	
	if animateLoop then
		animateLoop:Disconnect()
		animateLoop = nil
	end
	equipped = false
	sprinting = false
	reloading = false
	aiming = false
	if gun.Handle:FindFirstChild'Reload' then
		gun.Handle.Reload:Stop()
	end
	good = true
	crntArmLeft = LeftIdle
	bPart:Destroy()
	pWeld:Destroy()
	gWeld:Destroy()
	aWeld:Destroy()
	aWeld2:Destroy()
	_G.MouseSensitivity = 1
	targetFOV = 70
	cam.FieldOfView = 70
	char["Left Arm"].LocalTransparencyModifier = 1
	char["Right Arm"].LocalTransparencyModifier = 1
end

module.equipped = function(_gun)
	gun = _gun
	equipped = true
	gui = player.PlayerGui.Crosshairs
	gui.Crosshairs.Visible = true
	if good then
		good = false
		idle = gun.GunAngles.Idle.Value
		
		if (_gun.Name ~= "Check Target") then
			sight = gun.GunAngles.Sight.Value
			idleTrack:Play()
		else
			gui.Crosshairs.Visible = false
		end
		
		correction = gun.GunAngles.Correction.Value
		none = Vector3.new(0,-math.pi/2,0)
		
		reloading = false
		gun.Ready.Value = true
		
		RightIdle = gun.ArmAngles.Idle.Value
		LeftIdle = gun.ArmAngles.IdleLeft.Value
		RightAim = gun.ArmAngles.Aim.Value
		LeftAim = gun.ArmAngles.AimLeft.Value
		Reload1 = gun.GunAngles.Reload1.Value
		Reload2 = gun.GunAngles.Reload2.Value
		Reload3 = gun.GunAngles.Reload3.Value
		ArmReload1 = gun.ArmAngles.Reload1.Value
		ArmReload2 = gun.ArmAngles.Reload2.Value
		ArmReload3 = gun.ArmAngles.Reload3.Value
		ArmReload4 = gun.ArmAngles.Reload4.Value
		
		crntArmLeft = LeftIdle
		crntArmRight = RightIdle
		crntPos = idle
		bPart = Instance.new("Part")
		bPart.FormFactor = "Custom"
		bPart.Size = Vector3.new(0.1, 0.1, 0.1)
		bPart.CanCollide = false
		char = player.Character
		local head = player.Character.Torso
		bPart.Parent = char
		pWeld = Instance.new("Weld")
		pWeld.Part0 = head
		pWeld.Part1 = bPart
		pWeld.C0 = CFrame.new(0,0,0)
		pWeld.C1 = CFrame.new(0,0,0)
		pWeld.Parent = head
		gWeld = Instance.new("Weld")
		gWeld.Part0 = gun.PistolPart
		gWeld.Part1 = bPart
		gWeld.Parent = bPart
		gWeld.C0 = gun.GunAngles.Start.Value
		aWeld = Instance.new("Weld")
		aWeld.Part0 = char["Right Arm"]
		aWeld.Part1 = gun.PistolPart
		aWeld.Parent = gun.PistolPart
		aWeld2 = Instance.new("Weld")
		aWeld2.Part0 = char["Left Arm"]
		aWeld2.Part1 = gun.PistolPart
		aWeld2.Parent = gun.PistolPart
		aWeld.C0 = crntArmRight
		aWeld2.C0 = crntArmLeft
		animateLoop = game:GetService("RunService").RenderStepped:connect(function(delta)
			if not equipped then return end
			if _gun ~= gun then return end
			if gui == nil or gui:FindFirstChild'Crosshairs' == nil then return end
			char["Left Arm"].LocalTransparencyModifier = 0
			char["Right Arm"].LocalTransparencyModifier = 0
			char.Humanoid.CameraOffset = detOffset()
			aWeld.C0 = aWeld.C0:Lerp(crntArmRight, delta * 10)
			aWeld2.C0 = aWeld2.C0:Lerp(crntArmLeft, delta * 10)
			
			gWeld.C0 = gWeld.C0:Lerp((CFrame.Angles(0, 0, turn()) * crntPos
				+ correction:vectorToWorldSpace(bob())
				+ correction:vectorToWorldSpace(shootFactor))
				* CFrame.Angles(0, 0, math.rad(detTwist()))
				* (sprinting and sprintFrame or CFrame.new()), delta * 10) --Important step
			
			pWeld.C0 = CFrame.new(0,1.5,0) * CFrame.Angles(math.asin(cam.CoordinateFrame.lookVector.Y), 0, 0)
			
			if aiming or sprinting then
				gui.Crosshairs.img.ImageTransparency = lerp(gui.Crosshairs.img.ImageTransparency, 1, delta * 10)
			else
				gui.Crosshairs.img.ImageTransparency = lerp(gui.Crosshairs.img.ImageTransparency, 0, delta * 10)
			end
		end)
		player.Character["Right Arm"].LocalTransparencyModifier = 1
		player.Character["Left Arm"].LocalTransparencyModifier = 1
	end
end

module.startSprint = function()
	if aiming then return end
	sprinting = true
end

module.stopSprint = function()
	sprinting = false
end

module.startAim = function()
	if sprinting then
		module.stopSprint()
	end
	aimTrack:Play()
	idleTrack:Stop()
	if gun.Equipped and gun.Parent == game.Players.LocalPlayer.Character then
		targetFOV = gun.Zoom.Value
		
		crntArmLeft = LeftAim
		crntArmRight = RightAim
		
		aiming = true
		crntPos = sight
	end
end

module.stopAim = function()
	if not aiming then return end
	aimTrack:Stop()
	idleTrack:Play()
	if gun.Equipped and gun.Parent == game.Players.LocalPlayer.Character and not reloading then
		crntArmLeft = LeftIdle
		crntArmRight = RightIdle
		
		aiming = false
		
		crntPos = idle
		
		targetFOV = 70
	end
end

module.shot = function()
	spawn(function()
		if not sprinting then
			shootFactor = Vector3.new(-0.4, -0.02, 0)
				+ Vector3.new(-0.06 + math.random() * 0.12, -0.06 + math.random() * 0.12, -0.06 + math.random() * 0.12)
			local x = 0
			game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0.6)
			repeat game:GetService("RunService").RenderStepped:wait()
			x = x + 0.1
			cam.CoordinateFrame = cam.CoordinateFrame * CFrame.Angles(shootFactor.x * -0.01, shootFactor.y * 0.1, shootFactor.z * 0.1)
			until x >= 0.3
			shootFactor = Vector3.new(0, 0, 0)
			wait(0.1)
			game:GetService("HapticService"):SetMotor(Enum.UserInputType.Gamepad1, Enum.VibrationMotor.Large, 0)
		end
	end)
end

function safeWait(t)
	local endt = tick() + t
	while tick() < endt do
		if not (gun.Equipped and gun.Parent == game.Players.LocalPlayer.Character) then
			reloadTrack:Stop()
			return false
		end
		if (gun ~= tgun) then
			reloadTrack:Stop()
			return false
		end
		wait(0)
	end
	return true
end

module.reloadSequence = function(g)
	if not g:FindFirstChild'Ammo' then return end
	idleTrack:Stop()
	reloadTrack:Play()
	reloadTrack:AdjustSpeed(1.3)
	tgun = gun
	g.Ammo.Text = "..."
	gun.Ready.Value = false
	gun.Handle.Reload:Play()
	reloading = true
	crntPos = idle
	crntArmLeft = LeftIdle
	crntArmRight = RightIdle
	reloadSeq = Vector3.new(0,0,0)
	crntPos = Reload1
	crntArmLeft = ArmReload1
	
	if not safeWait(0.1) then return end
	crntPos = Reload2
	
	if not safeWait(0.15) then return end
	crntArmLeft = ArmReload2
	
	if not safeWait(0.15) then return end
	crntPos = Reload3
	
	if not safeWait(0.4) then return end
	crntArmLeft = ArmReload3
	
	if not safeWait(0.2) then return end
	crntArmLeft = ArmReload4
	
	if not safeWait(0.15) then return end
	crntArmLeft = ArmReload3
	
	if not safeWait(0.15) then return end
	crntArmLeft = LeftIdle
	crntPos = idle
	reloading = false
	gun.Ammo.Value = gun.MaxAmmo.Value
	g.Ammo.Text = gun.Ammo.Value
	gun.Ready.Value = true
	reloadTrack:Stop()
	idleTrack:Play()
end

module.init = function(hum)
	idleTrack = hum:LoadAnimation(game.ReplicatedStorage.GunAnims.Idle)
	reloadTrack = hum:LoadAnimation(game.ReplicatedStorage.GunAnims.Reload)
	aimTrack = hum:LoadAnimation(game.ReplicatedStorage.GunAnims.Aim)
	game:GetService("RunService").RenderStepped:connect(function(delta)
		if hum.WalkSpeed > 16 and not aiming then
			targetFOV = 80
		elseif not sprinting and not aiming then
			targetFOV = 70
		end
		cam.FieldOfView = lerp(cam.FieldOfView, targetFOV, delta * 10)
		game.Players.LocalPlayer.PlayerScripts.Sensitivity.Value = math.min(1, (1 - (70 - cam.FieldOfView) / 60))
	end)
end

module.stop = function()
	idleTrack:Stop()
	reloadTrack:Stop()
	aimTrack:Stop()
end

return module
