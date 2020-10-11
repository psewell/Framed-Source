game.Workspace:WaitForChild'Events':WaitForChild'Notify'.OnClientEvent:connect(function(notify)
	script.Parent.Parent.Sounds.Notify:Play()
	local notify = game.ReplicatedStorage.Notifications[notify]:Clone()
	script.Parent.Frame:ClearAllChildren()
	local endPos = UDim2.new(0.375, 0, 0, 70)
	notify.Position = UDim2.new(0.5, 0, 0, 70)
	notify.Size = UDim2.new(0, 0, 0.115, 0)
	notify.Parent = script.Parent.Frame
	notify:TweenSizeAndPosition(UDim2.new(0.25, 0, 0.115, 0), endPos, Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.5)
	if notify.Name ~= "badKill" then
		game.Debris:AddItem(notify, 3.5)
		wait(3)
		notify:TweenSizeAndPosition(UDim2.new(0, 0, 0, 0), UDim2.new(0.5, 0, 0, 70), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5)
	end
end)