local module = {}

module.new = function()
	
	local deaths = require(script.Parent:WaitForChild'deaths')
	local handleDeath = require(script.Parent:WaitForChild'handleDeath')
	
	game.Players.PlayerRemoving:connect(function(player)
		if player.TeamColor == BrickColor.new("Bright red") then
			handleDeath.death(player)
			if player.Character then
				player.Character:Destroy()
			end
		end
		local stats = {
			user = player.userId,
			name = player.Name,
			karma = player.Karma.Value,
			wins = player.leaderstats.Wins.Value
		}
		game.Workspace.Events.DataStore.WriteTo:Fire('wins', stats.name, stats.wins)
		game.Workspace.Events.DataStore.WriteTo:Fire('stats', stats.user .. "karma", stats.karma)
		game.Workspace.Events.DataStore.WriteTo:Fire('stats', stats.user .. "karma", stats.karma)
	end)
	
	--Death
	game.Workspace:WaitForChild'Events':WaitForChild'Death'.Event:connect(function(player)
		handleDeath.death(player)
	end)
	
	game.Workspace.Events.Undercover.OnServerEvent:connect(function(player)
		player.UndercoverNow.Value = true
	end)
	
	game.Workspace.Events.CountdownTextMod.Event:connect(function(text, delay)
		game.StarterGui.Countdown.RMod.Text = text
		game.Workspace.Events.LocalTextMod:FireAllClients(text, delay)
	end)
	
	local inQ = {}
	game.Workspace.Events.Flash.OnServerEvent:connect(function(player, cf)
		if player.Team == game.Teams.Lobby or player.Character == nil then
			player:Kick()
			return
		end
		if inQ[player] and tick() - inQ[player] < 0.5 then
			player:Kick()
			return
		end
		inQ[player] = tick()
		local flash = game.ServerStorage.Flashbang:Clone()
		flash.CFrame = cf + cf.lookVector
		flash.Velocity = cf.lookVector * 70
		flash.Parent = game.Workspace
		wait(1.5)
		flash.Boom:Play()
		local boom = game.ReplicatedStorage.Flash:Clone()
		boom.Parent = game.Workspace
		boom.CFrame = flash.CFrame
		game.Debris:AddItem(boom, 0.3)
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.Character and p.TeamColor ~= BrickColor.new("Fossil") then
				if (p.Character.Torso.CFrame.p - flash.CFrame.p).magnitude < 30 then
					game.Workspace.Events.Flash:FireClient(p)
				end
			end
			flash:Destroy()
		end
	end)
	
	--Reward
	game.Workspace:WaitForChild'Events':WaitForChild'Reward'.Event:connect(function(player)
		pcall(function()
		player.leaderstats.Points.Value = player.leaderstats.Points.Value + 2
		game:GetService("PointsService"):AwardPoints(player.userId, 15)
		game.Workspace.Events.DataStore.WriteTo:Fire('bux', player.userId, 5)
		end)
	end)

	local function handleShotPlayer(shot, hit, damage)
		local getRole = game.Workspace:WaitForChild'Events':WaitForChild'GetRole'
		if not hit.Character then return end
		if hit.Character.Humanoid.Health <= 0 then return end
		deaths[getRole:Invoke(shot) .. "Hit" .. getRole:Invoke(hit)](shot, hit, damage)
	end	
	
	local function checkBadges(player)
		local market = game:GetService("MarketplaceService")
		player.PolicePass.Value = market:PlayerOwnsAsset(player, 159219393)
		player.UndercoverPass.Value = market:PlayerOwnsAsset(player, 159219598)
		player.Loadout.IsGunGold.Value = market:PlayerOwnsAsset(player, 175087620)
	end	
	
	game.Workspace.Events:WaitForChild("ShopClosed").OnServerEvent:connect(checkBadges)
	
	local function charLoader(player)
		if (game.Players.NumPlayers > game.Players.MaxPlayers) then
			player:Kick()
		end
		local starterPlayer = game.ServerStorage.StarterPlayer:GetChildren()
		for _, child in pairs(starterPlayer) do
			child:Clone().Parent = player
		end
		player.CharacterAdded:connect(function(char)
			char.Humanoid.Died:connect(function()
				game.Workspace.Events.Death:Fire(player)
				if char.Head then
					if char.Head.face then
						char.Head.face.Texture = "http://www.roblox.com/asset/?id=47206380"
					end
				end
				wait(5)
				if player.TeamColor ~= BrickColor.new("Fossil") or (char:FindFirstChild'Humanoid' and char.Humanoid.Health > 0) then
					return
				end
				if game.Workspace.Values.GameMode.Value ~= "Ending" and player.Parent ~= nil then
					player:LoadCharacter()
				end
				player.CameraMaxZoomDistance = 60
				player.NameDisplayDistance = 60
			end)
		end)
		player:LoadCharacter()
		wait()
		player.CameraMaxZoomDistance = 60
		player.NameDisplayDistance = 60
		print("Starting to load data")
		player.Karma.Value = game.Workspace.Events.DataStore.ReadFrom:Invoke(
			'stats', player.userId .. "karma") or 5
		player.leaderstats.Wins.Value = game.Workspace.Events.DataStore.ReadFrom:Invoke('wins', player.Name) or 0
		print("Loaded stats.")
		local loadout = game.Workspace.Events.DataStore.GetLoadout:Invoke(player.userId) or
		{
			isFemale = false,
			color = "Institutional white",
			hat = "Default",
			shirt = "Default",
			gun = "Default",
			face = "Default"
		}
		if not loadout.face then loadout.face = "Default" end
		print("Loaded loadout.")
		player.Loadout.Color.Value = BrickColor.new(loadout.color)
		player.Loadout.Shirt.Value = loadout.shirt
		player.Loadout.Hat.Value = loadout.hat
		player.Loadout.Gun.Value = loadout.gun
		player.Loadout.IsFemale.Value = loadout.isFemale
		player.Loadout.Face.Value = loadout.face
		checkBadges(player)
		print("Loaded all data.")
	end
	
	game.Workspace:WaitForChild'Events':WaitForChild'TeleportPlayer'.Event:connect(function(player, spawn, delay)
		local endTime = tick() + delay
		local pos = spawn.TP.CFrame + Vector3.new(0, 1, 0)
		spawn.TP.CanCollide = false
		if spawn:FindFirstChild("Part") then
			spawn.Part.CanCollide = false
		end
		while player.Character == nil do wait() end
		for i = 1, 20 do
			if player.Character then
				player.Character:WaitForChild'Torso'
				player.Character:WaitForChild'HumanoidRootPart'
				player.Character.HumanoidRootPart.CFrame = CFrame.new(pos.p)
				player.Character.Torso.Velocity = Vector3.new()
				player.Character.Torso.RotVelocity = Vector3.new()
			end
			wait(0)
		end
		player.Character.Torso.Anchored = true
		for i = 1, 20 do
			if player.Character then
				player.Character:WaitForChild'Torso'
				player.Character:WaitForChild'HumanoidRootPart'
				player.Character.HumanoidRootPart.CFrame = CFrame.new(pos.p)
				player.Character.Torso.Velocity = Vector3.new()
				player.Character.Torso.RotVelocity = Vector3.new()
			end
			wait(0)
		end
		if game.Workspace.Values.GameMode.Value == "City Chase" then
			local moveto = game.Workspace["City Chase"]["City Chase Cars"][spawn.Name].Engine
			local car = game.ServerStorage.Bonuses.Car:Clone()
			car.Parent = game.Workspace
			car:SetPrimaryPartCFrame(moveto.CFrame + Vector3.new(0, 2, 0))
			moveto:Destroy()
		end
		repeat wait() until tick() > endTime
		player.Character.Torso.Anchored = false
	end)
	
	game.Workspace.Events:WaitForChild'HurtKarma'.Event:connect(function(player)
		if player.Karma.Value > 0 then
			player.Karma.Value = player.Karma.Value - 1
		else
			player:Kick("Kicked for teamkilling.")
		end
	end)
	
	game.Workspace.Events:WaitForChild'HelpKarma'.Event:connect(function(player)
		if player.Karma.Value < 5 then
			player.Karma.Value = player.Karma.Value + 1
		else
			player.Karma.Value = 5
		end
	end)
	
	game.Workspace:WaitForChild'Events':WaitForChild'WeaponOut'.OnServerEvent:connect(function(player, isOut)
		if game.Workspace.Events.GetRole:Invoke(player) ~= "Police" then
			if isOut then
				game.Workspace.Events.RedHanded:FireClient(player)
				player.RedHanded.Value = true
				player.GunOut.Value = true
			else
				game.Workspace.Events.RedHanded:FireClient(player, 3)
				player.GunOut.Value = false
				wait(3)
				if not player.GunOut.Value then
					player.RedHanded.Value = false
				end
			end
		end
	end)
	
	game.Workspace:WaitForChild'Events':WaitForChild'Shoot'.OnServerEvent:connect(function(player, ray, hit, tool, damage)
		if player.Team == game.Teams.Lobby then return end
		if hit then
			if hit.Name == "WindScreen" then
				hit.Shatter.Transparency = 0.5
				hit.Shatter2.Transparency = 0.5
				hit.Crack:Play()
				hit.Name = "BrokenWindScreen"
			end
			if hit.Name == "BrokenWindScreen" then
				hit.Break:Play()
				hit:Destroy()
			end
			if hit.Parent:FindFirstChild("Humanoid") then
				for _, p in pairs(game.Players:GetPlayers()) do
					if p.Character then
						if hit:IsDescendantOf(p.Character) then
							if hit.Name == "Head" or hit.Parent:IsA("Hat") then
								damage = damage * 2
							end
							if hit.Name == "Torso" then
								damage = damage * 1.2
							end
							handleShotPlayer(player, p, damage)
						end
					end
				end
			end
		end
		for _, p in pairs(game.Players:GetPlayers()) do
			if p ~= player then
				game.Workspace.Events.Shoot:FireClient(p, player.Name, tool)
			end
		end
	end)
	
	for _, p in pairs(game.Players:GetPlayers()) do
		charLoader(p)
	end
	
	game.Players.PlayerAdded:connect(charLoader)
end

return module
