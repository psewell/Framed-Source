game.Workspace.Events.ContractStart.OnClientEvent:connect(function(points, desc)
	if script.Parent.Frame:FindFirstChild'Contract' then return end
	script.Parent.Frame:ClearAllChildren()
	local contract = game.ReplicatedStorage.Contract:Clone()
	contract.Parent = script.Parent.Frame
	contract.Top.Line.TextLabel.Text = "NEW CONTRACT - POINTS: " .. points
	contract.Bottom.Line.TextLabel.Text = desc
	contract:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Elastic, 1)
	script.Parent.Parent.Sounds.Notify:Play()
	print("Contract started.")
end)

game.Workspace.Events.ContractEnd.OnClientEvent:connect(function(didWin)
	print("Contract ended.")
	script.Parent.Frame:ClearAllChildren()
	if didWin then
		script.Parent.Parent.Sounds.PurchaseSuccess:Play()
	else
		script.Parent.Parent.Sounds.PageTurn:Play()
	end
end)