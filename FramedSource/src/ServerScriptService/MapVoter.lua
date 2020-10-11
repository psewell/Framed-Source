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

module.getGameMode = function()
	math.randomseed(tick() * math.random())
	local rand = math.random()
	if rand > 0.8 then
		return "Hunted Man"
	else
		return "Framed"
	end
end

module.makers = {
	Aquarium = "pa00",
	Ballroom = "BigfootBeto",
	["Bowling Center"] = "Dramatizing",
	["Christmas Town"] = "pa00",
	["Classy Cottage"] = "Druxy",
	Garden = "pa00",
	Heist = "glitch19",
	Highrise = "pa00",
	Peak = "SimpleBeings",
	["Sailor Vacation"] = "Gamer4evaR",
	["The Diner"] = "Rezkon",
	Theater = "SimpleBeings",
	["Top Secret"] = "AllanCornwallis",
	["Train Trouble"] = "pa00",
	Yacht = "FrozenTheFlux's Flux Co.",
	["City Chase"] = "pa00",
	["On The Run"] = "pa00",
	["Italy"] = "SimpleBeings",
	["Airship"] = "pa00",
	["Island"] = "pa00",
	["Espionage v2"] = "pa00 & SimpleBeings",
	["Diner v2"] = "Rezkon",
	["Airship v2"] = "erie555",
	["Pool Party v2"] = "vlluu",
	["Office"] = "ChuckXZ",
	["Aquarium v2"] = "erie555",
	["Cliffside Mansion"] = "vlluu",
	["Train Trouble v2"] = "erie555",
	["Fiesta"] = "AbstractThoughtsx & erie555",
	["Museum"] = "AbstractThoughtsx"
}

module.images = {
	Aquarium = "http://www.roblox.com/asset/?id=168207968",
	Ballroom = "http://www.roblox.com/asset/?id=160702062",
	["Bowling Center"] = "http://www.roblox.com/asset/?id=235365401",
	["Christmas Town"] = "http://www.roblox.com/asset/?id=190233670",
	["Classy Cottage"] = "http://www.roblox.com/asset/?id=198955800",
	Garden = "http://www.roblox.com/asset/?id=160285096",
	Heist = "http://www.roblox.com/asset/?id=168029469",
	Highrise = "http://www.roblox.com/asset/?id=160285115",
	Peak = "http://www.roblox.com/asset/?id=227875725",
	["Sailor Vacation"] = "http://www.roblox.com/asset/?id=160458658",
	["The Diner"] = "http://www.roblox.com/asset/?id=235176652",
	Theater = "http://www.roblox.com/asset/?id=168029485",
	["Top Secret"] = "http://www.roblox.com/asset/?id=168029495",
	["Train Trouble"] = "http://www.roblox.com/asset/?id=160285142",
	Yacht = "http://www.roblox.com/asset/?id=160596060",
	["On The Run"] = "http://www.roblox.com/asset/?id=224254181",
	["City Chase"] = "http://www.roblox.com/asset/?id=176314713",
	["Italy"] = "http://www.roblox.com/asset/?id=365598840",
	["Airship"] = "http://www.roblox.com/asset/?id=419420286",
	["Island"] = "rbxassetid://811310514",
	["Espionage v2"] = "rbxassetid://811694345",
	["Diner v2"] = "rbxassetid://4815090058",
	["Airship v2"] = "rbxassetid://4815631431",
	["Pool Party v2"] = "rbxassetid://4816581311",
	["Office"] = "rbxassetid://4816612535",
	["Aquarium v2"] = "rbxassetid://4816678904",
	["Cliffside Mansion"] = "rbxassetid://4818881326",
	["Train Trouble v2"] = "rbxassetid://4887387519",
	["Fiesta"] = "http://www.roblox.com/asset/?id=5224615939",
	["Museum"] = "rbxassetid://5302969535",
}

module.scrambled = module.scramble(game.ServerStorage.Maps:GetChildren())
module.index = 1

module.getMap = function()
	local maps = module.scrambled
	if module.index > #game.ServerStorage.Maps:GetChildren() - 3 then
		module.scrambled = module.scramble(game.ServerStorage.Maps:GetChildren())
		module.index = 1
		maps = module.scrambled
	end

	local mapNames = {
		map1 = maps[module.index].Name,
		map2 = maps[module.index + 1].Name,
		map3 = maps[module.index + 2].Name
	}
	local modes = {
		this.getGameMode(),
		this.getGameMode(),
		this.getGameMode(),
	}
	local map1 = maps[module.index]
	local map2 = maps[module.index + 1]
	local map3 = maps[module.index + 2]
	
	module.index = module.index + 3

	local delay = 10
	game.Workspace.Events.CountdownTextMod:Fire("Choosing Map", delay)
	local endTime = tick() + delay
	game.Workspace.Events.OpensMap:FireAllClients(
		this.images[map1.Name],
		this.images[map2.Name],
		this.images[map3.Name],
		map1.Name,
		map2.Name,
		map3.Name,
		modes[1],
		modes[2],
		modes[3],
		delay
	)
	local votes = {
		map1 = 0,
		map2 = 0,
		map3 = 0
	}
	game.Workspace.Events.Vote:FireAllClients(0, 0, 0)
	local playersVoted = {}
	local voteConnect = game.Workspace.Events.Vote.OnServerEvent:connect(function(player, voted)
		if playersVoted[player.Name] ~= nil then
			votes[playersVoted[player.Name]] = votes[playersVoted[player.Name]] - 1
		end
		votes[voted] = votes[voted] + 1
		playersVoted[player.Name] = voted
		game.Workspace.Events.Vote:FireAllClients(votes.map1, votes.map2, votes.map3)
	end)
	repeat wait() until tick() > endTime
	voteConnect:disconnect()
	voteConnect = nil
	local maximum = math.max(math.max(votes.map1, votes.map2), votes.map3)
	if votes.map1 == maximum then
		game.Workspace.Events.MapImage:Fire(this.images[mapNames.map1], this.makers[mapNames.map1])
		return mapNames.map1, this.images[mapNames.map1], modes[1]
	end
	if votes.map2 == maximum then
		game.Workspace.Events.MapImage:Fire(this.images[mapNames.map2], this.makers[mapNames.map2])
		return mapNames.map2, this.images[mapNames.map2], modes[2]
	end
	if votes.map3 == maximum then
		game.Workspace.Events.MapImage:Fire(this.images[mapNames.map3], this.makers[mapNames.map3])
		return mapNames.map3, this.images[mapNames.map3], modes[3]
	end
end

return module
