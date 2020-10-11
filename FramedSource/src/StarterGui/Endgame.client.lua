local running = false

game.Workspace:WaitForChild'Events':WaitForChild'GameEndLocal'.OnClientEvent:connect(function(endTime, isOver)	
	game.Lighting.Blur.Enabled = false	
	if isOver then
		running = false
		wait()
		local cam = game.Workspace.CurrentCamera
		cam.FieldOfView = 70
		cam.CameraType = Enum.CameraType.Custom
		for _, sound in pairs(game.Players.LocalPlayer.PlayerGui.Sounds.MusicTracks:GetChildren()) do
			sound:Stop()
		end
		local music = game.Players.LocalPlayer.PlayerGui.Sounds.MusicTracks:GetChildren()
		music[math.random(1, #music)]:Play()
		game:GetService("AdService"):ShowVideoAd()
	end
	if game.Players.LocalPlayer.Character then
		running = true
		game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
		game.Players.LocalPlayer.Backpack:ClearAllChildren()
		game.Players.LocalPlayer.PlayerGui.RedHanded.Frame.Visible = false
		game.Players.LocalPlayer.PlayerGui.Epilogue:Destroy()
		game.Players.LocalPlayer.PlayerGui.Contracts.Frame:ClearAllChildren()
		pcall(function()
			game.Players.LocalPlayer.PlayerGui.Yourself:Destroy()
			game.Players.LocalPlayer.Character.Torso.Anchored = true
		end)
	end
	script.Parent.Sounds.EndingSong:Play()
	local cam = game.Workspace.CurrentCamera
	cam.FieldOfView = 70
	cam.CameraType = Enum.CameraType.Scriptable
	local dark = game.ReplicatedStorage.Dark:Clone()
	dark.Parent = script.Parent
	while running do
		dark.Frame.BackgroundTransparency = dark.Frame.BackgroundTransparency * 1.09
		game:GetService("RunService").RenderStepped:wait()
		cam.CoordinateFrame = CFrame.new(game.Workspace.EndArea.camOrigin.CFrame.p + Vector3.new(0, math.sin(tick()), 0),
			 game.Workspace.EndArea.focusPoint.CFrame.p)
	end
	game.Lighting.Blur.Enabled = false
end)