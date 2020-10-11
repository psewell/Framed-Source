local thrown = false

script.Parent.Activated:connect(function()
	if thrown then return end
	thrown = true
	local throw = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(script.Parent.Throw)
	script.Parent.Handle.Throw:Play()
	wait(0.5)
	throw:Play()
	wait(0.6)
	game.Workspace.Events.Flash:FireServer(game.Workspace.CurrentCamera.CoordinateFrame)
	game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
	wait()
	script.Parent:Destroy()
end)
