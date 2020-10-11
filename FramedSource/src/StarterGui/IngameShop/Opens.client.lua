local isOpen = false

function open()
	if not (game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Fossil") and not script.Parent.Frame.Visible
	and (game.Workspace.Values.GameMode.Value == "Framed" or game.Workspace.Values.GameMode.Value == "Classic Framed")) then
		return
	end

	isOpen = true
	game.Lighting.Blur.Enabled = true
	game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
	game:GetService("UserInputService").MouseIconEnabled = true
	script.Parent.Frame.Visible = true
	script.Parent.Frame:TweenPosition(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.7)
	script.Parent.Frame.Main.ScrollingFrame:ClearAllChildren()
	local role = game.Workspace.Events.GetRoleLocal:InvokeServer()
	local item = game.ReplicatedStorage.IngameShop.IngameItem
	local items = game.ReplicatedStorage.IngameShop[role]:GetChildren()
	local x = 0
	local y = 0
	table.sort(items, function(item1, item2)
		return item1.Points.Value < item2.Points.Value
	end)
	for _, obj in pairs(items) do
		local disp = item:Clone()
		disp.buyWithFbucks.Text = obj.FBucks.Value .. " F$"
		disp.buyWithPoints.Text = obj.Points.Value .. " Points"
		disp.PointsPrice.Value = obj.Points.Value
		disp.BuxPrice.Value = obj.FBucks.Value
		disp.Picture.Image = obj.Preview.Value
		disp.Description.Text = obj.Description.Value
		disp.ItemName.Text = obj.Name
		disp.Parent = script.Parent.Frame.Main.ScrollingFrame
		disp.Position = UDim2.new(0, 0, 0, y)
		y = y + 100
		script.Parent.Frame.Main.ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, y)
	end
	script.Parent.Frame.Main.numPoints.Text = "Your Points: " .. game.Players.LocalPlayer.leaderstats.Points.Value
	script.Parent.Frame.Main.numBux.Text = "Your F$: " .. game.Workspace.Events.DataStore.ReadFromLocal:InvokeServer("bux", game.Players.LocalPlayer.userId)
end

function close()
	isOpen = false
	game:GetService("UserInputService").MouseIconEnabled = false
	script.Parent.Frame:TweenPosition(UDim2.new(0, 0, -1, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.7)
	script.Parent.Frame.Main.ScrollingFrame:ClearAllChildren()
	game.Lighting.Blur.Enabled = false
	wait(0.5)
	script.Parent.Frame.Visible = false
end

game:GetService("UserInputService").InputBegan:connect(function(input, processed)
	if (input.KeyCode == Enum.KeyCode.F and not processed) or input.KeyCode == Enum.KeyCode.DPadUp then
		if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Fossil") and not script.Parent.Frame.Visible
			and (game.Workspace.Values.GameMode.Value == "Framed" or game.Workspace.Values.GameMode.Value == "Classic Framed") then
			open()
		elseif game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Fossil") then
			 close()
		end
	end
end)

game:GetService("UserInputService").InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.ButtonB then
		 close()
	end
end)

script.Parent.Open.Event:Connect(function()
	if isOpen then
		close()
	else
		open()
	end
end)