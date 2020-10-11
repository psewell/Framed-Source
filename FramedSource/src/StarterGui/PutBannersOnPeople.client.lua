game.Workspace:WaitForChild'Events':WaitForChild'HasteMode'.OnClientEvent:connect(function()
	local player = game.Players.LocalPlayer
	if player.TeamColor ~= BrickColor.new("Bright red") then return end
	local others = {}
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.TeamColor == BrickColor.new("Bright red") then
			table.insert(others, p)
		end
	end
	for _, o in pairs(others) do
		if o.Character then
			local banner = game.ReplicatedStorage.Banner:Clone()
			banner.Adornee = o.Character.Head
			banner.Parent = player.PlayerGui
			o.Character.Humanoid.Died:connect(function()
				banner:Destroy()
			end)
		end
	end
end)

game.Workspace:WaitForChild'Events':WaitForChild'MarkPlayer'.OnClientEvent:connect(function(plr)
	if plr.Character then
		local banner = game.ReplicatedStorage.Banner:Clone()
		banner.Adornee = plr.Character.Head
		banner.Parent = game.Players.LocalPlayer.PlayerGui
		plr.Character.Humanoid.Died:connect(function()
			banner:Destroy()
		end)
	end
end)

game.Workspace:WaitForChild'Events':WaitForChild'PoliceTarget'.OnClientEvent:connect(function(plr)
	local player = game.Players.LocalPlayer
	if player.TeamColor == BrickColor.new("Toothpaste") then
		if plr.Character then
			local banner = game.ReplicatedStorage.PoliceTarget:Clone()
			banner.Adornee = plr.Character.Head
			banner.Parent = player.PlayerGui
			plr.Character.Humanoid.Died:connect(function()
				banner:Destroy()
			end)
		end
	end
end)

game.Workspace:WaitForChild'Events':WaitForChild'PoliceMark'.OnClientEvent:connect(function(plr)
	local player = game.Players.LocalPlayer
	if player.TeamColor ~= BrickColor.new("Fossil") then
		if plr.Character then
			local banner = game.ReplicatedStorage.PoliceBanner:Clone()
			banner.Adornee = plr.Character.Head
			banner.Parent = player.PlayerGui
			plr.Character.Humanoid.Died:connect(function()
				banner:Destroy()
			end)
		end
	end
end)

game.Workspace:WaitForChild'Events':WaitForChild'AgentMark'.OnClientEvent:connect(function(plr)
	local player = game.Players.LocalPlayer
	if player.TeamColor ~= BrickColor.new("Fossil") then
		if plr.Character then
			local banner = game.ReplicatedStorage.Friendly:Clone()
			banner.Adornee = plr.Character.Head
			banner.Parent = player.PlayerGui
			plr.Character.Humanoid.Died:connect(function()
				banner:Destroy()
			end)
		end
	end
end)

game.Workspace:WaitForChild'Events':WaitForChild'FramedMark'.OnClientEvent:connect(function(plr)
	local player = game.Players.LocalPlayer
	if player.TeamColor ~= BrickColor.new("Fossil") then
		if plr.Character then
			local banner = game.ReplicatedStorage.FramedBanner:Clone()
			banner.Adornee = plr.Character.Head
			banner.Parent = player.PlayerGui
			plr.Character.Humanoid.Died:connect(function()
				banner:Destroy()
			end)
		end
	end
end)

game:GetService("UserInputService").InputBegan:connect(function(input)
	local player = game.Players.LocalPlayer
	if player.TeamColor ~= BrickColor.new("Fossil") then
		if input.KeyCode == Enum.KeyCode.ButtonR3 or input.KeyCode == Enum.KeyCode.C then
			local cam = game.Workspace.CurrentCamera
			local ray = Ray.new(cam.CoordinateFrame.p, cam.CoordinateFrame.lookVector * 1000)
			local part = game.Workspace:FindPartOnRay(ray, player.Character)
			if not part then return end
			for _, p in pairs(game.Players:GetPlayers()) do
				if p.Character then
					if part:IsDescendantOf(p.Character) then
						if player.PlayerGui:FindFirstChild'Marked' then
							player.PlayerGui.Marked:Destroy()
						end
						local banner = game.ReplicatedStorage.Marked:Clone()
						banner.Adornee = p.Character.Head
						banner.Parent = player.PlayerGui
						p.Character.Humanoid.Died:connect(function()
							banner:Destroy()
						end)
						return
					end
				end
			end
		end
	end
end)