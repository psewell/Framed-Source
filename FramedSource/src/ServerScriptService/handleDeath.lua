local module = {}

local this = module

module.checkPlayers = function()
	local alive = {}
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.TeamColor == BrickColor.new("Bright red") and game.Workspace.Events.GetRole:Invoke(p) == "Framed" then
			table.insert(alive, p)
		end
	end
	return alive
end

module.checkPlayersForRole = function(role)
	local alive = {}
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.TeamColor ~= BrickColor.new("Fossil") and game.Workspace.Events.GetRole:Invoke(p) == role then
			table.insert(alive, p)
		end
	end
	return alive
end

module.death = function(player)
	player:WaitForChild'MyBackpack':ClearAllChildren()
	if player.TeamColor == BrickColor.new("Fossil") then return end
	player.TeamColor = BrickColor.new("Fossil")
	local role = game.Workspace.Events.GetRole:Invoke(player)
	if role == "Framed" then
		local hunter = game.Workspace.Events.GetHunter:Invoke(player)
		local target = game.Workspace.Events.GetTarget:Invoke(player)
		game.Workspace.Events.SetTarget:Fire(hunter, target)
		game.Workspace.Events.Notify:FireClient(hunter, 'newTarget')
		game.Workspace.Events.Notify:FireClient(target, 'newHunter')
		spawn(function()
			pcall(function()
				local contracts = require(script.Parent.ContractHandler)
				contracts.new(hunter, game.Workspace.Events.GetRole:Invoke(hunter))
			end)
		end)
		local alive = this.checkPlayers()
		print(#alive)
		if #alive == 0 then
			game.Workspace.Events.GameEnd:Fire("Police")
		end
		if #alive == 1 then
			if game.Workspace.Values.GameMode.Value == "Classic Framed" then
				local winner = alive[1]
				game.Workspace.Events.GameEnd:Fire(winner.Name)
			elseif game.Workspace.Values.GameMode.Value == "Framed" then
				game.Workspace.Events.EpilogueServer:Fire()
				game.Workspace.Events.Epilogue:FireClient(alive[1])
				game.Workspace.Values.Epilogue.Value = true
			end
		end
		if #alive == 3 then
			print("Haste mode.")
			game.Workspace.Events.HasteMode:FireAllClients()
		end
	end
	if role == "DFramed" then
		local alive = this.checkPlayersForRole("DFramed")
		print(#alive)
		if #alive == 0 then
			game.Workspace.Events.GameEnd:Fire("DAgents")
		end
	end
	if role == "DAgent" then
		local alive = this.checkPlayersForRole("DAgent")
		print(#alive)
		if #alive == 0 then
			game.Workspace.Events.GameEnd:Fire("DFramed")
		end
	end
	if role == "HMan" then
		local candidates = {}
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.TeamColor ~= BrickColor.new("Fossil") then
				table.insert(candidates, p)
			end
		end
		if #candidates == 1 then
			game.Workspace.Events.GameEnd:Fire(candidates[1].Name)
		else
			local target = candidates[math.random(1, #candidates)]
			game.Workspace.Events.SetRole:Invoke(target, "HMan")
			game.Workspace.Events.Notify:FireClient(target, 'huntedMan')
			game.Workspace.Events.SetTarget:Fire(target, target)
			for _, candidate in pairs(candidates) do
				if candidate ~= target then
					game.Workspace.Events.SetTarget:Fire(candidate, target)
					game.Workspace.Events.Notify:FireClient(candidate, 'newTarget')
					game.Workspace.Events.SetRole:Invoke(candidate, "HFramed")
				end
			end
		end
	end
	if role == "HFramed" then
		local candidates = {}
		local hman = nil
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.TeamColor ~= BrickColor.new("Fossil") then
				if game.Workspace.Events.GetRole:Invoke(p) ~= "HMan" then
					table.insert(candidates, p)
				else
					hman = p
				end
			end
		end
		print(hman.Name)
		if #candidates == 0 then
			if hman then
				game.Workspace.Events.GameEnd:Fire(hman.Name)
			else
				game.Workspace.Events.GameEnd:Fire("Police")
			end
		else
			local target = candidates[math.random(1, #candidates)]
			game.Workspace.Events.Notify:FireClient(target, 'huntedMan')
			game.Workspace.Events.SetRole:Invoke(target, "HMan")
			game.Workspace.Events.SetTarget:Fire(hman, target)
			game.Workspace.Events.Notify:FireClient(hman, 'newTarget')
			game.Workspace.Events.SetRole:Invoke(hman, "HFramed")
			game.Workspace.Events.SetTarget:Fire(target, target)
			for _, candidate in pairs(candidates) do
				if candidate ~= target then
					game.Workspace.Events.SetTarget:Fire(candidate, target)
					game.Workspace.Events.Notify:FireClient(candidate, 'newTarget')
					game.Workspace.Events.SetRole:Invoke(candidate, "HFramed")
				end
			end
		end
	end
	if role == "CFramed" then
		local alive = this.checkPlayersForRole("CFramed")
		print(#alive)
		if #alive == 0 then
			game.Workspace.Events.GameEnd:Fire("CPolice")
		end
	end
	if role == "CPolice" then
		local alive = this.checkPlayersForRole("CPolice")
		print(#alive)
		if #alive == 0 then
			game.Workspace.Events.GameEnd:Fire("CFramed")
		end
	end
	if role == "OFramed" then
		local alive = this.checkPlayersForRole("OFramed")
		print(#alive)
		if #alive == 0 then
			game.Workspace.Events.GameEnd:Fire("OPolice")
		end
	end
end

return module