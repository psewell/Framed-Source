function changeTarget()
	local player = game.Players.LocalPlayer
	local target = game.Workspace.Events.GetTargetLocal:InvokeServer(player)
	local gui = script.Parent.PistolPart.SurfaceGui.Phone
	target.Character:WaitForChild("Head")
	gui.FaceColor.BackgroundColor3 = target.Character.Head.BrickColor.Color
	gui.FaceColor.FaceImage.Image = target.Character.Head:WaitForChild("face").Texture
	if player:IsFriendsWith(target.userId) then
		gui.Friend.Text = target.Name
		gui.Friend.Visible = true
	else
		gui.Friend.Visible = false
	end
end

game.Workspace:WaitForChild'Events':WaitForChild'SetTargetLocal'.OnClientEvent:connect(function(target)
	changeTarget()
end)

script.Parent.Equipped:connect(changeTarget)