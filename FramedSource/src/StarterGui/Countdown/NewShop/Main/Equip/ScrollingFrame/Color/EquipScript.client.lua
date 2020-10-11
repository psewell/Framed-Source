local id = 190199210

script.Parent:WaitForChild'ImageButton'.MouseButton1Click:connect(function()
	local hasPass = game:GetService("MarketplaceService"):PlayerOwnsAsset(game.Players.LocalPlayer, id)
	if hasPass then
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
		local x = 100
		local y = 0
		for _, face in pairs({
			"Bright red",
			"Really red",
			"Neon orange",
			"Br. yellowish green",
			"Bright yellow",
			"Bright violet",
			"Pink",
			"Really blue",
			"Bright blue",
			"Pastel Blue",
			"Bright bluish green",
			"Lime green",
			"Grime",
			"Bright green",
			"Earth green",
			"Medium stone grey",
			"Black",
			"Brown",
			"Reddish brown"
		}) do
			local faceButton = game.ReplicatedStorage.Default:Clone()
			faceButton.Name = face
			faceButton.Image = 'http://www.roblox.com/asset/?id=2114473'
			faceButton.ImageColor3 = BrickColor.new(face).Color
			faceButton.Parent = script.Parent.ScrollingFrame
			faceButton.Position = UDim2.new(0, x, 0, y)
			if x + 100 < 300 then
				x = x + 100
			else
				x = 0
				y = y + 100
				script.Parent.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y + 100)
			end
		end
		game.GuiService.SelectedObject = script.Parent.ScrollingFrame:GetChildren()[1]
		script.Parent.ScrollingFrame.Visible = true
		for _, ch in pairs(script.Parent.ScrollingFrame:GetChildren()) do
			ch.MouseButton1Click:connect(function()
				script.Parent.ImageButton.Image = ch.Image
				script.Parent.Description.Text = ch.Name
				script.Parent.ImageButton.BackgroundColor3 = BrickColor.new(ch.Name).Color or BrickColor.new("Institutional white").Color
				script.Parent.ScrollingFrame.Visible = false
				script.Parent.ScrollingFrame.Position = UDim2.new(0, 0, -1, 0)
			end)
		end
	else
		game:GetService("MarketplaceService"):PromptPurchase(game.Players.LocalPlayer, id)
	end
end)