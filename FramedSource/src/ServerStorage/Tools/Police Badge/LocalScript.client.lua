player = game.Players.LocalPlayer
cam = game.Workspace.CurrentCamera
fArm = nil

script.Parent.Equipped:connect(function()
	game.Workspace.Events.RedHanded:FireServer(false)
end)