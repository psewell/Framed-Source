local IN = UDim2.new(0.5, 0, 0.5, 0)
local OUT = UDim2.new(0.5, 0, -1, 0)

function tweenIn()
	script.Parent:TweenPosition(IN, Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.7, true)
end

function tweenOut()
	script.Parent:TweenPosition(OUT, Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.7, true)
end

function generateGun()
	print("Generating gun")
	local insertService = game:GetService("InsertService")
	local page = unpack(insertService:GetFreeDecals("", math.random(1, 50))) -- Search for "Cats" on Page 1.
	 
	local item = page.Results[math.random(1, #page.Results)]
	local id = "rbxassetid://" .. item.AssetId - 1
	local pistols = {"M1911", "Luger", "Six Shooter", "MAC10", "Hand Cannon", "Mauser"}
	local pistol = pistols[math.random(1, #pistols)]
	game.Workspace.Events.AddInventory:InvokeServer(pistol .. " " .. id, "guns")
end

script.Parent:WaitForChild'PromptPurchase'.OnInvoke = function(info, lastFrame, category)
	local debounce = false
	if game.Workspace.Events.DataStore.ReadFromLocal:InvokeServer('bux', game.Players.LocalPlayer.userId) >= info.price then
		script.Parent.Parent.Parent.Parent.Sounds.PromptPurchase:Play()
		tweenOut()
		local popup = game.ReplicatedStorage.Shop.PurchasePopup:Clone()
		popup.Parent = script.Parent.Parent
		if info.item == "Random" then
			popup.TextLabel.Text = "A unique gun with a random skin."
		end
		popup.Preview.Image = info.preview
		popup.Price.Text = "F$ " .. info.price
		popup:TweenPosition(UDim2.new(0.5, -200, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.7, true)
		popup.NoButton.MouseButton1Click:connect(function()
			tweenIn()
			popup:TweenPosition(UDim2.new(0.5, -200, -1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.7, true)
			game.Debris:AddItem(popup, 0.3)
			script.Parent.Tabs.OpenTab:Fire(lastFrame)
		end)
		if game:GetService("UserInputService").GamepadEnabled then
			game.GuiService.SelectedObject = popup.YesButton
		end
		popup.YesButton.MouseButton1Click:connect(function()
			if debounce then return end
			debounce = true
			--Successfully bought
			local player = game.Players.LocalPlayer
			script.Parent.Parent.Parent.Parent.Sounds.PageTurn:Play()
			if category == 'undercover' then
				game.Workspace.Events.Undercover:FireServer()
				game.Workspace.Events.DataStore.WriteToWaitLocal:InvokeServer('bux', player.userId, -info.price)
			else
				if info.item == "Random" then
					generateGun(category)
				else
					game.Workspace.Events.AddInventory:InvokeServer(info.item, category)
				end
				game.Workspace.Events.DataStore.WriteToWaitLocal:InvokeServer('bux', player.userId, -info.price)
				game.Workspace.Events.ShopRefresh:Fire()
			end
				script.Parent.Parent.Parent.Parent.Sounds.PurchaseSuccess:Play()
				script.Parent.Check:Fire()
				tweenIn()
				popup:TweenPosition(UDim2.new(0.5, -200, -1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.7, true)
				game.Debris:AddItem(popup, 0.3)
				script.Parent.Tabs.OpenTab:Fire(lastFrame)
		end)
	else
		script.Parent.Parent.Parent.Parent.Sounds.PromptPurchase:Play()
		tweenOut()
		local popup = game.ReplicatedStorage.Shop.FailedPopup:Clone()
		popup.Parent = script.Parent.Parent
		popup.Preview.Image = info.preview
		popup.Price.Text = "F$ " .. info.price
		if game:GetService("UserInputService").GamepadEnabled then
			game.GuiService.SelectedObject = popup.YesButton
		end
		popup:TweenPosition(UDim2.new(0.5, -200, 0, 100), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.7, true)
		popup.NoButton.MouseButton1Click:connect(function()
			tweenIn()
			popup:TweenPosition(UDim2.new(0.5, -200, -1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.7, true)
			game.Debris:AddItem(popup, 0.3)
			script.Parent.Tabs.OpenTab:Fire(lastFrame)
		end)
		popup.YesButton.MouseButton1Click:connect(function()
			tweenIn()
			popup:TweenPosition(UDim2.new(0.5, -200, -1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.7, true)
			game.Debris:AddItem(popup, 0.3)
			script.Parent.Tabs.OpenTab:Fire(script.Parent.fBucks)
		end)
	end
end