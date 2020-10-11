local player = game.Players.LocalPlayer
player.CharacterAdded:wait()

player.Character:WaitForChild'Humanoid'.Seated:connect(function()
	game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
end)