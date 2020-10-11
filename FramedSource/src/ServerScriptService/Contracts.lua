local module = {}

module['Kill your next target with a knife.'] = function(player)
	local didIt = false
	local failedIt = false
	game.Workspace.Events.Contracts.TaskFulfilled.Event:connect(function(plr, type)
		if type == "Knife" and plr == player then
			didIt =  true
		end
		if type == "Pistol" and plr == player then
			failedIt = true
		end
		if type == "Kill" and plr == player then
			failedIt = true
		end
	end)
	repeat wait() until game.Workspace.Values.GameMode.Value == "Ending" or failedIt or didIt
	if failedIt then
		return false
	end
	if didIt then
		return true
	end
	return false
end

module['Kill your next target with a pistol.'] = function(player)
	local didIt = false
	local failedIt = false
	game.Workspace.Events.Contracts.TaskFulfilled.Event:connect(function(plr, type)
		if type == "Pistol" and plr == player then
			didIt =  true
		end
		if type == "Knife" and plr == player then
			failedIt = true
		end
		if type == "Kill" and plr == player then
			failedIt = true
		end
	end)
	repeat wait() until game.Workspace.Values.GameMode.Value == "Ending" or failedIt or didIt
	if failedIt then
		return false
	end
	if didIt then
		return true
	end
	return false
end

module['Find the hidden intel briefcase.'] = function(player)
	local didIt = false
	local failedIt = false
	game.Workspace.Events.Contracts.RemoteTaskFulfilled:FireClient(player, 'case')
	game.Workspace.Events.Contracts.RemoteTaskFulfilled.OnServerEvent:connect(function(plr)
		if plr == player then
			didIt =  true
		end
	end)
	repeat wait() until game.Workspace.Values.GameMode.Value == "Ending" or failedIt or didIt
	if failedIt then
		return false
	end
	if didIt then
		return true
	end
	return false
end

module['Kill your next target without using the Check Target tool twice.'] = function(player)
	local didIt = false
	local failedIt = false
	local counter = 0
	player.Character.ChildAdded:connect(function(child)
		if child.Name == "Check Target" then
			counter = counter + 1
			if counter == 2 then
				failedIt = true
			end
		end
	end)
	game.Workspace.Events.Contracts.TaskFulfilled.Event:connect(function(plr, type)
		if type == "Kill" and plr == player then
			didIt =  true
		end
		if type == "Pistol" and plr == player then
			didIt =  true
		end
		if type == "Knife" and plr == player then
			didIt =  true
		end
	end)
	repeat wait() until game.Workspace.Values.GameMode.Value == "Ending" or failedIt or didIt
	if failedIt then
		return false
	end
	if didIt then
		return true
	end
	return false
end

module['Kill your hunter.'] = function(player)
	local didIt = false
	local failedIt = false
	game.Workspace.Events.Contracts.TaskFulfilled.Event:connect(function(plr, type)
		if type == "Hunter" and plr == player then
			didIt =  true
		end
	end)
	repeat wait() until game.Workspace.Values.GameMode.Value == "Ending" or failedIt or didIt
	if failedIt then
		return false
	end
	if didIt then
		return true
	end
	return false
end

module['Kill an undercover cop.'] = function(player)
	local didIt = false
	local failedIt = false
	game.Workspace.Events.Contracts.TaskFulfilled.Event:connect(function(plr, type)
		if type == "Undercover" and plr == player then
			didIt =  true
		end
	end)
	repeat wait() until game.Workspace.Values.GameMode.Value == "Ending" or failedIt or didIt
	if failedIt then
		return false
	end
	if didIt then
		return true
	end
	return false
end

return module
