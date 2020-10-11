local module = {}

local this = module

module.checkDeath = function(killer, victim, krole, vrole, ktarget, vtarget)
	if krole ~= "Framed" then return end
	if vrole == "Undercover" then
		game.Workspace.Events.Contracts.TaskFulfilled:Fire(killer, "Undercover")
		return
	end
	if vtarget == killer then
		game.Workspace.Events.Contracts.TaskFulfilled:Fire(killer, "Hunter")
		return
	end
	if (killer.Character:FindFirstChild'Blade' or killer.Character:FindFirstChild'Bowie Knife')
	and ktarget == victim then
		game.Workspace.Events.Contracts.TaskFulfilled:Fire(killer, "Knife")
		return
	end
	if (killer.Character:FindFirstChild'M1911' or killer.Character:FindFirstChild'Luger'
	or killer.Character:FindFirstChild'Mauser' or killer.Character:FindFirstChild'Six Shooter')
	and ktarget == victim then
		game.Workspace.Events.Contracts.TaskFulfilled:Fire(killer, "Pistol")
		return
	end
	if ktarget == victim then
		game.Workspace.Events.Contracts.TaskFulfilled:Fire(killer, "Kill")
	end
end

module.randomContract = function()
	local contracts = {
		'Kill your next target with a knife.',
		'Kill your next target with a pistol.',
		'Find the hidden intel briefcase.',
		'Kill your next target without using the Check Target tool.',
		'Kill your hunter.',
		'Kill an undercover cop.'
	}
	local pointvals = {
		1,
		1,
		3,
		3,
		2,
		3
	}
	local num = math.random(1, #contracts)
	return contracts[num], pointvals[num]
end

module.new = function(player, role)
	print("Attempting to start contract for " .. player.Name)
	if player.TeamColor == BrickColor.new("Fossil") then return end
	if role ~= "Framed" then return end
	if math.random() > 0.2 then return end
	if game.Workspace.Values.Epilogue.Value then return end
	print("Ready to start.")
	local desc, points = this.randomContract()
	game.Workspace.Events.ContractStart:FireClient(player, points, desc)
	local contracts = require(script.Parent.Contracts)
	if contracts[desc](player) == true then
		player.leaderstats.Points.Value = player.leaderstats.Points.Value + points
		game.Workspace.Events.ContractEnd:FireClient(player, true)
	else
		game.Workspace.Events.ContractEnd:FireClient(player, false)
	end
end

return module
