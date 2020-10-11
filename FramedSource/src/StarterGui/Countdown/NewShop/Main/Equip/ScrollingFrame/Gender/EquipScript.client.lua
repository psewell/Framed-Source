script.Parent:WaitForChild'ImageButton'.MouseButton1Click:connect(function()
	script.Parent.ScrollingFrame.Position = UDim2.new(0, 0, -1, 0)
	script.Parent.ScrollingFrame:TweenPosition(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.InOut,
		Enum.EasingStyle.Quad,
		0.3
	)
	if game:GetService("UserInputService").GamepadEnabled then
		game.GuiService.SelectedObject = 
			script.Parent.ScrollingFrame:GetChildren()[1]
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