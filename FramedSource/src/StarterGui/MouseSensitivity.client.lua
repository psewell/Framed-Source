_G.MouseSensitivity = 1
_G.MouseSensitivityOffset = 0

repeat Wait() until Game.Players.LocalPlayer
local Player = Game.Players.LocalPlayer
repeat Wait() until Workspace.CurrentCamera
local Camera = Workspace.CurrentCamera
repeat Wait() until Player:GetMouse()
local Mouse = Player:GetMouse()


function RotateCamera(x, y)
	Camera.CoordinateFrame = CFrame.new(Camera.Focus.p) * (Camera.CoordinateFrame - Camera.CoordinateFrame.p) * CFrame.Angles(x, y, 0) * CFrame.new(0, 0, (Camera.CoordinateFrame.p - Camera.Focus.p).magnitude)
end

function GetAngles(cf)
	local lv = cf.lookVector
	return -math.asin(lv.y), math.atan2(lv.x, -lv.z)
end

local LastCF = Camera.CoordinateFrame

function UpdateSensitivity()
	if _G.MouseSensitivity ~= 1 then -- no need to do this if it's 1
		local x, y = GetAngles(LastCF:toObjectSpace(Camera.CoordinateFrame))
		Camera.CoordinateFrame = LastCF
		RotateCamera(x * -(_G.MouseSensitivity + _G.MouseSensitivityOffset), y * -(_G.MouseSensitivity + _G.MouseSensitivityOffset))
		LastCF = Camera.CoordinateFrame
	end
end

Mouse.Move:connect(function()
	UpdateSensitivity()
end)

Mouse.Idle:connect(function()
	LastCF = Camera.CoordinateFrame
end)
