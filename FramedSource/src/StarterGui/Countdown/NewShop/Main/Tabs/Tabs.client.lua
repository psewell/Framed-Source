script.Parent:WaitForChild'Frame'

cantab = true

function removeOldGuis()
	for _, gui in pairs({
		script.Parent.Parent.Hats,
		script.Parent.Parent.fBucks,
		script.Parent.Parent.Equip,
		script.Parent.Parent.Shirts,
		script.Parent.Parent.Guns,
		script.Parent.Parent.Bonus
	}) do
		if gui.Visible then
			gui:TweenPosition(UDim2.new(1, 0, 0, 80), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad,
			0.3)
		end
		gui.Visible = false
	end
	wait(0.31)
end

function connectChild(child)
	child.MouseButton1Click:connect(function()
		script.Parent.OpenTab:Fire(script.Parent.Parent[child.Name])
	end)
end

for _, ch in pairs(script.Parent.Frame:GetChildren()) do
	connectChild(ch)
end

function refreshLoadout(tab)
	local frame = tab.ScrollingFrame
	local loadout = game.Workspace.Events.DataStore.GetLoadoutLocal:InvokeServer(game.Players.LocalPlayer.userId)
	if not loadout.color then loadout.color = "Institutional white" end
	if loadout.color ~= "Institutional white" then
		frame.Color.Description.Text = loadout.color
	end
	if not loadout.hat then loadout.hat = "Default" end
	frame.Hat.Description.Text = loadout.hat
	if loadout.hat ~= "Default" then
		frame.Hat.ImageButton.Image = game.ReplicatedStorage.Clothes.Hats[loadout.hat].Preview.Value
	end
	if not loadout.isFemale then loadout.isFemale = false end
	if loadout.isFemale then
		frame.Gender.Description.Text = "Female"
		frame.Gender.ImageButton.Image = "http://www.roblox.com/asset/?id=247421768"
	else
		frame.Gender.Description.Text = "Male"
		frame.Gender.ImageButton.Image = "http://www.roblox.com/asset/?id=28486312"
	end
	if not loadout.gun then loadout.gun = "Default" end
	frame.Gun.Description.Text = loadout.gun
	if loadout.gun ~= "Default" then
		if game.ReplicatedStorage.Guns:FindFirstChild(loadout.gun) ~= nil then
			frame.Gun.ImageButton.Image = game.ReplicatedStorage.Guns[loadout.gun].Preview.Value
		elseif string.find(loadout.gun, "rbx") ~= nil then
			local img = string.sub(loadout.gun, string.find(loadout.gun, "rbx"), string.len(loadout.gun))
			frame.Gun.ImageButton.Image = img
		end	
	end
	if not loadout.shirt then loadout.shirt = "Default" end
	frame.Shirt.Description.Text = loadout.shirt
	if loadout.shirt ~= "Default" then
		frame.Shirt.ImageButton.Image = "rbxassetid://" .. game.ReplicatedStorage.Clothes.Shirts[loadout.shirt].Preview.Value
	end
	if not loadout.face or loadout.face == '0' then loadout.face = "Default" end
	frame.Face.Description.Text = loadout.face
	if loadout.face ~= "Default" then
		frame.Face.ImageButton.Image = "rbxassetid://" .. loadout.face
	end
end

script.Parent.OpenTab.Event:connect(function(tab)
	if cantab then
		cantab = false
		script.Parent.Parent.Loading.Visible = true
		removeOldGuis()
		script.Parent.Parent.Parent.Parent.Parent.Sounds.PageTurn:Play()
		if tab.Name == "Hats" or tab.Name == "Shirts" or tab.Name == "Guns" then
			game.Workspace.Events.ShopRefresh:Fire()
		end
		if tab.Name == "Equip" then
			refreshLoadout(tab)
		end
		script.Parent.Parent.Loading.Visible = false
		tab.Visible = true
		tab.Position = UDim2.new(-1, 0, 0, 80)
		tab:TweenPosition(UDim2.new(0, 0, 0, 80), Enum.EasingDirection.InOut, Enum.EasingStyle.Quad,
		0.4)
		if game:GetService("UserInputService").GamepadEnabled then
			game.GuiService.SelectedObject = script.Parent.Frame[tab.Name]
		end
		if tab.Name == "fBucks" then
			if game:GetService("UserInputService").GamepadEnabled then
				game.GuiService.SelectedObject = tab.ScrollingFrame[50].BuyThis
			end
		end
		cantab = true
	end
end)