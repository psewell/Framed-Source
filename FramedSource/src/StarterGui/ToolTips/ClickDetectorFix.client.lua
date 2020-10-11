local runService = game:GetService("RunService")
local icons = require(game.ReplicatedStorage:WaitForChild'ButtonIcons')
local cam = game.Workspace.CurrentCamera

local clickDetector = script.Parent:WaitForChild'ClickDetector'

local part

game:GetService("UserInputService").InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonX or input.KeyCode == Enum.KeyCode.R
		or input.UserInputType == Enum.UserInputType.Touch then
		if part then
			if part:FindFirstChild("ClickDetector") then
				part.MouseClick:FireServer()
			end
		end
	end
end)

function connector()
	if game:GetService("UserInputService").GamepadEnabled then
		script.Parent.ClickDetector.ImageLabel.Image = icons.ButtonX
	else
		script.Parent.ClickDetector.ImageLabel.Image = icons.KeyR
	end
	while true do
		runService.RenderStepped:wait()
		local ray = Ray.new(cam.CoordinateFrame.p, cam.CoordinateFrame.lookVector * 8)
		part = game.Workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character or nil)
		if part then
			if part:FindFirstChild("ClickDetector") then
				clickDetector.Adornee = part
				clickDetector.Enabled = true
			else
				clickDetector.Enabled = false
			end
		else
			clickDetector.Enabled = false
		end
	end
end

connector()