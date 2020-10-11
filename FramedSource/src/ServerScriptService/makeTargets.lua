local module = {}

local this = module

module.scramble = function(tab)
	math.randomseed(tick() * math.random())
	local temp={}
	for _,v in pairs(tab) do
		table.insert(temp,math.random(#temp+1),v)
	end
	return temp
end

module.makePolice = function(players)
	local police = {}
	for _, p in pairs(players) do
		if p.PolicePass.Value then
			table.insert(police, p)
		end
		table.insert(police, p)
	end
	this.scramble(police)
	local police1 = police[1]
	for _, p in pairs(police) do
		if p ~= police1 then
			return police1, p
		end
	end
end

module.makeUndercovers = function(players)
	local numUc = 1
	local undercovers = {}
	for _, p in pairs(players) do
		if #undercovers == numUc then return undercovers end
		if p.UndercoverNow.Value then
			p.UndercoverNow.Value = false
			table.insert(undercovers, p)
		end
	end
	if #undercovers == numUc then return undercovers end
	local leftovers = this.copy(players)
	local uc = {}
	for _, p in pairs(players) do
		if p.UndercoverPass.Value then
			table.insert(uc, p)
		end
		table.insert(uc, p)
	end
	this.scramble(uc)
	table.insert(undercovers, uc[1])
	if #undercovers == numUc then return undercovers end
	for _, p in pairs(uc) do
		local isIn = false
		for _, u in pairs(undercovers) do
			if p == u then
				isIn = true
			end
		end
		if not isIn then
			table.insert(undercovers, p)
		end
		if #undercovers == numUc then return undercovers end
	end
end

module.thinLeftovers = function(leftovers, roles)
	local newL = {}
	for _, p in ipairs(leftovers) do
		if roles[p] == nil then
			table.insert(newL, p)
		end
	end
	return newL
end

module.copy = function(tab)
	local c = {}
	for _, item in pairs(tab) do
		table.insert(c, item)
	end
	return c
end

module.makeRoles = function(players, gameMode)
	local roles = {}
	if gameMode == "Framed" or gameMode == "Classic Framed" then
		if #players < 6 then
			for _, player in pairs(players) do
				roles[player] = "Framed"
				player.TeamColor = BrickColor.new("Bright red")
			end
		elseif #players < 10 then
			local leftovers = this.scramble(this.copy(players))
			local police1, police2 = this.makePolice(leftovers)
			roles[police1] = "Police"
			police1.TeamColor = BrickColor.new("Toothpaste")
			roles[police2] = "Police"
			police2.TeamColor = BrickColor.new("Toothpaste")
			leftovers = this.scramble(this.thinLeftovers(leftovers, roles))
			for _, player in pairs(leftovers) do
				roles[player] = "Framed"
				player.TeamColor = BrickColor.new("Bright red")
			end
			print(police1.Name .. " is a Police.")
			print(police2.Name .. " is a Police.")
		else
			local leftovers = this.scramble(this.copy(players))
			local undercovers = this.makeUndercovers(leftovers)
			for _, uc in pairs(undercovers) do
				print(uc.Name .. " is an undercover.")
				roles[uc] = "Undercover"
				uc.TeamColor = BrickColor.new("Bright red")
			end
			leftovers = this.scramble(this.thinLeftovers(leftovers, roles))
			local police1, police2 = this.makePolice(leftovers)
			roles[police1] = "Police"
			police1.TeamColor = BrickColor.new("Toothpaste")
			roles[police2] = "Police"
			police2.TeamColor = BrickColor.new("Toothpaste")
			leftovers = this.scramble(this.thinLeftovers(leftovers, roles))
			for _, player in pairs(leftovers) do
				roles[player] = "Framed"
				player.TeamColor = BrickColor.new("Bright red")
			end
			print(police1.Name .. " is a Police.")
			print(police2.Name .. " is a Police.")
		end
	end
	if gameMode == "Double Agents" then
		local numAgents
		if #players < 6 then
			numAgents = 1
		elseif #players < 10 then
			numAgents = 2
		else
			numAgents = 3
		end
		local leftovers = this.scramble(this.copy(players))
		local i = 1
		repeat
			roles[leftovers[i]] = "DAgent"
			leftovers[i].TeamColor = BrickColor.new("Bright red")
			i = i + 1
		until i > numAgents
		while i <= #leftovers do
			roles[leftovers[i]] = "DFramed"
			leftovers[i].TeamColor = BrickColor.new("Bright red")
			i = i + 1
		end
	end
	if gameMode == "Hunted Man" then
		local leftovers = this.scramble(this.copy(players))
		roles[leftovers[1]] = "HMan"
		leftovers[1].TeamColor = BrickColor.new("Bright red")
		local i = 2
		while i <= #leftovers do
			roles[leftovers[i]] = "HFramed"
			leftovers[i].TeamColor = BrickColor.new("Bright red")
			i = i + 1
		end
	end
	if gameMode == "City Chase" then
		local leftovers = this.scramble(this.copy(players))
		local i = 1
		while i < #leftovers / 2 do
			leftovers[i].TeamColor = BrickColor.new("Bright red")
			roles[leftovers[i]] = "CFramed"
			i = i + 1
		end
		while i <= #leftovers do
			leftovers[i].TeamColor = BrickColor.new("Toothpaste")
			roles[leftovers[i]] = "CPolice"
			i = i + 1
		end
	end
	if gameMode == "On The Run" then
		local leftovers = this.scramble(this.copy(players))
		roles[leftovers[1]] = "OPolice"
		leftovers[1].TeamColor = BrickColor.new("Toothpaste")
		roles[leftovers[2]] = "OPolice"
		leftovers[2].TeamColor = BrickColor.new("Toothpaste")
		for i = 3, #leftovers do
			roles[leftovers[i]] = "OFramed"
			leftovers[i].TeamColor = BrickColor.new("Bright red")
			game.Workspace.Events.Epilogue:FireClient(leftovers[i], true)
		end
	end
	return roles
end

module.makeTargets = function(players, roles)
	math.randomseed(tick() * math.random())
	local targets = {}
	local hunters = {}
	local j = 1
	local k = 1
	local leftoversz = this.scramble(this.copy(players))
	local leftovers = {}
	for i, p in ipairs(leftoversz) do
		if roles[p] == "Framed" then
			table.insert(leftovers, p)
		end
	end
	for i, player in ipairs(leftovers) do
		if i + 1 > #leftovers then
			j = 1
		else
			j = i + 1
		end
		if i - 1 == 0 then
			k = #leftovers
		else
			k = i - 1
		end
		targets[player] = leftovers[j]
		hunters[player] = leftovers[k]
	end
	return targets, hunters
end

module.makeTargetsHuntedMan = function(players, roles)
	local targets = {}
	local hunters = {}
	local hman = players[1]
	for _, p in pairs(players) do
		if roles[p] == "HMan" then
			hman = p
		end
	end
	for _, p in pairs(players) do
		targets[p] = hman
		hunters[hman] = p
	end
	return targets, hunters
end

return module
