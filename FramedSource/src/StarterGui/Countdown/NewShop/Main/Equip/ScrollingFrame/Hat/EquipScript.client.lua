script.Parent:WaitForChild'ImageButton'.MouseButton1Click:connect(function()
	script.Parent.ScrollingFrame.Position = UDim2.new(0, 0, -1, 0)
	script.Parent.ScrollingFrame:TweenPosition(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quad,
		0.3
	)
	script.Parent.ScrollingFrame:ClearAllChildren()
	local default = game.ReplicatedStorage.Default:Clone()
	default.Parent = script.Parent.ScrollingFrame
	local inventory = game.Workspace.Events.GetInventory:InvokeServer()
	local hats = inventory['hats']
	local x = 100
	local y = 0
	for _, hat in pairs(hats) do
		local hatButton = game.ReplicatedStorage.Default:Clone()
		local hatObj = game.ReplicatedStorage.Clothes.Hats[hat]
		hatButton.Name = hatObj.Name
		hatButton.Image = hatObj.Preview.Value
		hatButton.Parent = script.Parent.ScrollingFrame
		hatButton.Position = UDim2.new(0, x, 0, y)
		if x + 100 < 300 then
			x = x + 100
		else
			x = 0
			y = y + 100
			script.Parent.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y + 100)
		end
	end
	if game:GetService("UserInputService").GamepadEnabled then
		game.GuiService.SelectedObject = script.Parent.ScrollingFrame:GetChildren()[1]
	end
	script.Parent.ScrollingFrame.Visible = true
	for _, ch in pairs(script.Parent.ScrollingFrame:GetChildren()) do
		ch.MouseButton1Click:connect(function()
			script.Parent.ImageButton.Image = ch.Image
			script.Parent.Description.Text = ch.Name
			script.Parent.ScrollingFrame.Visible = false
			script.Parent.ScrollingFrame.Position = UDim2.new(0, 0, -1, 0)
		end)
	end
end)