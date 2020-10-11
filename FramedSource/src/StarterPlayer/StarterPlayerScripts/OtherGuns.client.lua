game.Workspace:WaitForChild'Events':WaitForChild'Shoot'.OnClientEvent:connect(function(player, tool)
	if player.Name == game.Players.LocalPlayer.Name then return end
	if player == game.Players.LocalPlayer then return end
	if tool == nil then return end
	if tool:IsDescendantOf(game.Players.LocalPlayer.Character) then return end
	if tool:FindFirstChild("Handle") then
		local fp = tool:WaitForChild'FlashPart'.Flare:Clone()
		fp.Parent = tool.FlashPart
		game.Debris:AddItem(fp, 0.8)
		fp:Emit(1)
	end
end)