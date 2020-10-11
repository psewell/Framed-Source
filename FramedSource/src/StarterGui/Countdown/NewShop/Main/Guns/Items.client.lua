function refresh()
	local x = 30
	local y = 10
	script.Parent.ScrollingFrame:ClearAllChildren()
	local items = {}
	local inventory = game.Workspace.Events.GetInventory:InvokeServer()
	for _, shirt in pairs(game.ReplicatedStorage.Guns:GetChildren()) do
		local bought = false
		for _, test in pairs(inventory['guns']) do
			if shirt.Name == test then
				bought = true
			end
		end
		if not bought then
			local item = game.ReplicatedStorage.Shop.Item:Clone()
			item.Category.Value = "guns"
			item.ItemName.Text = shirt.Name
			item.Preview.Image = shirt.Preview.Value
			item.Price.Value = shirt.Price.Value
			item.ItemToBuy.Value = shirt.Name
			item.ItemPrice.Text = "F$ " .. item.Price.Value
			table.insert(items, item)
		end
	end
	
	table.sort(items, function(item1, item2)
		return item1.Price.Value < item2.Price.Value
	end)
	
	for _, item in pairs(items) do
		item.Parent = script.Parent.ScrollingFrame
		item.Position = UDim2.new(0, x, 0, y)
		if x + 130 < 600 then
			x = x + 130
		else
			x = 30
			y = y + 160
			script.Parent.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y + 160)
		end
	end
end

game.Workspace:WaitForChild'Events':WaitForChild'ShopRefresh'.Event:connect(refresh)