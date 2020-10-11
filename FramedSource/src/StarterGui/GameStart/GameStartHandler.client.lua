game.Workspace:WaitForChild'Events':WaitForChild'GameStart'.OnClientEvent:connect(function(role, delay)
	game.Lighting.Blur.Enabled = true
	local char = game.Players.LocalPlayer.Character
	local cam = game.Workspace.CurrentCamera
	cam.CameraType = Enum.CameraType.Scriptable
	cam.CoordinateFrame = CFrame.new(char.Head.CFrame.p + char.Head.CFrame.lookVector * 5, char.Head.CFrame.p)
	local endTime = tick() + delay
	game:GetService("UserInputService").MouseIconEnabled = false
	game.Players.LocalPlayer.PlayerGui.Crosshairs.Crosshairs.Visible = true
	script.Parent[role].Visible = true
	script.Parent["Music" .. role]:Play()
	script.Parent[role]:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
	pcall(function()
		game.Players.LocalPlayer.PlayerGui.Countdown.Ingame.ImageColor3 = game.Players.LocalPlayer.TeamColor.Color
		game.Players.LocalPlayer.PlayerGui.ToolSelect.Outgame.ImageColor3 = game.Players.LocalPlayer.TeamColor.Color
	end)
	wait(6)
	cam.CameraType = Enum.CameraType.Custom
	local you = game.ReplicatedStorage.Yourself:Clone()
	you.Parent = game.Players.LocalPlayer.PlayerGui
	you.YourColor.BackgroundColor3 = char.Head.BrickColor.Color
	you.YourColor.YourFace.Image = char.Head.face.Texture
	script.Parent[role]:TweenPosition(UDim2.new(0, 0, -1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
	cam.CameraType = Enum.CameraType.Custom
	game.Lighting.Blur.Enabled = false
end)