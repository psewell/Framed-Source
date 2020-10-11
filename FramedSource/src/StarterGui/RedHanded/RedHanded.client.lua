game.Workspace:WaitForChild'Events':WaitForChild'RedHanded'.OnClientEvent:connect(function(delay)	
	script.Parent.Frame:ClearAllChildren()
	if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Bright red") then return end
	local rh = game.ReplicatedStorage.Notifications.redHanded:Clone()
	rh.Parent = script.Parent.Frame
	if delay ~= nil then
		rh.ProgressBar:TweenSizeAndPosition(
			UDim2.new(0, 0, 0, 8),
			UDim2.new(0.5, 0, 1, -120),
			Enum.EasingDirection.InOut,
			Enum.EasingStyle.Linear,
			delay
		)
		game.Debris:AddItem(rh, delay)
	end
end)