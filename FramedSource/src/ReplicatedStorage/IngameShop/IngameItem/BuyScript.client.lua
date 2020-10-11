local pointsconnect = script.Parent:WaitForChild'buyWithPoints'.MouseButton1Click:connect(function()
	if pointsconnect then pointsconnect:disconnect() end
	print("Request for " .. script.Parent.ItemName.Text)
	local bought = game.Workspace.Events.ShopRequest:InvokeServer("Points", script.Parent.ItemName.Text, script.Parent.PointsPrice.Value)
	if bought then
		game.Players.LocalPlayer.PlayerGui.Sounds.PurchaseSuccess:Play()
	else
		game.Players.LocalPlayer.PlayerGui.Sounds.PageTurn:Play()
	end
	local shop = game.Players.LocalPlayer.PlayerGui.IngameShop
	shop.Frame.Visible = false
	game.Lighting.Blur.Enabled = false
	shop.Frame.Position = UDim2.new(0, 0, -1, 0)
	shop.Frame.Main.ScrollingFrame:ClearAllChildren()
	game:GetService("UserInputService").MouseIconEnabled = false
end)

local buxconnect = script.Parent:WaitForChild'buyWithFbucks'.MouseButton1Click:connect(function()
	if buxconnect then buxconnect:disconnect() end
	print("Request for " .. script.Parent.ItemName.Text)
	local bought = game.Workspace.Events.ShopRequest:InvokeServer("Bux", script.Parent.ItemName.Text, script.Parent.BuxPrice.Value)
	if bought then
		game.Players.LocalPlayer.PlayerGui.Sounds.PurchaseSuccess:Play()
	else
		game.Players.LocalPlayer.PlayerGui.Sounds.PageTurn:Play()
	end
	local shop = game.Players.LocalPlayer.PlayerGui.IngameShop
	shop.Frame.Visible = false
	game.Lighting.Blur.Enabled = false
	shop.Frame.Position = UDim2.new(0, 0, -1, 0)
	shop.Frame.Main.ScrollingFrame:ClearAllChildren()
	game:GetService("UserInputService").MouseIconEnabled = false
end)