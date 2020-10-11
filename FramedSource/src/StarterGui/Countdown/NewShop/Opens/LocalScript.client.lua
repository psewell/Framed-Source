local ingameShop = script.Parent.Parent.Parent.Parent:WaitForChild("IngameShop"):WaitForChild("Open")

function open()
	if game.Players.LocalPlayer.TeamColor == BrickColor.new("Fossil") then
		if script.Parent.Parent.Main.Visible then
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 14
		else
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 0
		end
		if script.Parent.Text == "Opening" or script.Parent.Text == "Loading Data" then return end
		script.Parent.Text = "Opening"
		if not script.Parent.Parent.Main.Visible then
			game.Lighting.Blur.Enabled = true
			script.Parent.Text = "Loading Data"
			script.Parent.Parent.Main.Visible = true
			script.Parent.Parent.Main:TweenPosition(UDim2.new(0.5, 0, 0.5, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Elastic,
			0.6)
			game.Workspace.Events.LoadOld:InvokeServer()
			script.Parent.Parent.Parent.Parent.Sounds.PageTurn:Play()
			script.Parent.Parent.Main.Check:Fire()
			if game:GetService("UserInputService").GamepadEnabled then
				game.GuiService.SelectedObject = script.Parent.Parent.Main.Tabs.Frame.Equip
			end
			script.Parent.Text = "Close Shop"
			script.Parent.Parent.Main.Tabs.OpenTab:Fire(script.Parent.Parent.Main.fBucks)
		else
			game.Lighting.Blur.Enabled = false
			if script.Parent.Text == "Closing" then return end
			script.Parent.Text = "Closing"
			game.Workspace.Events.ShopClosed:FireServer()
			script.Parent.Parent.Main:TweenPosition(UDim2.new(0.5, 0, -1, 0),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Elastic,
			1.1)
			wait(0.6)
			for _, gui in pairs(script.Parent.Parent.Main:GetChildren()) do
				if gui:isA("Frame") and gui.Name ~= "Tabs" then
					gui.Visible = false
				end
			end
			script.Parent.Parent.Main.Visible = false
			script.Parent.Text = "Open Shop"
		end
	else
		ingameShop:Fire()
	end
end

local touched = false
script.Parent.MouseButton1Click:connect(open)
game.Workspace:WaitForChild'LobbyArea':WaitForChild'Lobby':WaitForChild'ShopFloor'.Touched:connect(function(hit)
	if hit:IsDescendantOf(game.Players.LocalPlayer.Character) and not script.Parent.Parent.Main.Visible then
		if touched then return end
		touched = true
		open()
	end
end)

game:GetService("UserInputService").InputBegan:connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.ButtonB and not processed then
		if script.Parent.Parent.Main.Visible then 
			open()
			game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 14
		end
	end
end)

game.Workspace.Events.OpensMap.OnClientEvent:connect(function()
	if script.Parent.Parent.Main.Visible then 
		open()
	end
end)

game.Workspace:WaitForChild'LobbyArea':WaitForChild'Lobby':WaitForChild'ShopStop'.Touched:connect(function(hit)
	if hit:IsDescendantOf(game.Players.LocalPlayer.Character) then
		touched = false
	end
end)

game.Workspace:WaitForChild'LobbyArea':WaitForChild'Lobby':WaitForChild'ShopStop2'.Touched:connect(function(hit)
	if hit:IsDescendantOf(game.Players.LocalPlayer.Character) then
		touched = false
	end
end)