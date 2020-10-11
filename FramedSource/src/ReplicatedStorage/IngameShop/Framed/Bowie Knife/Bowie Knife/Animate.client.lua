--For up/down movement, use asin(lookVectorOfCamera.Y) to get the x angle.
--For right/left movement, use atan2(lookVectorOfCamera.z,lookVectorOfCamera.x) to get the z angle.
player = game.Players.LocalPlayer
mouse = player:GetMouse()
cam = game.Workspace.CurrentCamera


script.Parent.Unequipped:connect(function()
	equipped = false
	player.Character["Right Arm"].LocalTransparencyModifier = 1
	player.Character["Left Arm"].LocalTransparencyModifier = 1
end)

script.Parent.Equipped:connect(function()
	equipped = true
		while equipped do
			game:GetService("RunService").RenderStepped:wait()
			player.Character["Right Arm"].LocalTransparencyModifier = 0
			player.Character["Left Arm"].LocalTransparencyModifier = 0
		end
		player.Character["Right Arm"].LocalTransparencyModifier = 1
	player.Character["Left Arm"].LocalTransparencyModifier = 1
end)