local ContentProvider = game:GetService("ContentProvider")
local PlayerImages = {};
local Resolution = 250;
local URL = "http://www.roblox.com/Thumbs/Avatar.ashx?x="..Resolution.."&y="..Resolution.."&Format=Png&userId=";
local GetImageBindable = Instance.new("BindableFunction",game.ReplicatedStorage);
GetImageBindable.Name = "GetPlayerImage";

GetImageBindable.OnInvoke = function(Player)
	return PlayerImages[Player] or URL .. Player.userId;
end

local function LoadPlayerImage(Player)
	if Player:IsA("Player") then
		local Raw = (Player.Name:find("Guest ") and URL .. "1" or Player.userId < 1 and URL .. "1" or URL .. Player.userId);
		ContentProvider:Preload(Raw);
		local Display = Raw .. "&bust="..math.floor(tick());
		PlayerImages[Player] = Display;
	end;
end

game.Players.ChildAdded:connect(LoadPlayerImage);
game.Players.ChildRemoved:connect(function(Player) PlayerImages[Player] = nil; end);
for _,Player in pairs(game.Players:GetPlayers()) do LoadPlayerImage(Player) end;

math.randomseed(tick() * math.random())

local events = require(script.Parent:WaitForChild'EventHandler')
local decorator = require(script.Parent:WaitForChild'decorator')
local targetsModule = require(script.Parent:WaitForChild'makeTargets')
local dataStore = require(script.Parent:WaitForChild'DataStoreHandler')
local tools = require(script.Parent:WaitForChild'distributeTools')
local voter = require(script.Parent:WaitForChild'MapVoter')
local shop = require(script.Parent:WaitForChild'shopHandler')
local load = require(script.Parent:WaitForChild'transferPurchases')
local badges = require(script.Parent:WaitForChild'BadgeHandler')

dataStore.new()
events.new()
shop.new()
load.new()

local map = nil

local iterations = 1

local stats = {}

local epilogue = false

local delay = 0

local endTime = 0

local inProgress = false

local hunters = {}
local roles = {}
local inventories = {}
local targets = {}
local roundStats = {
	accidents = 0,
	policeKills = 0,
	undercoverKills = 0
}

game.Workspace:WaitForChild'Events':WaitForChild'GetRole'.OnInvoke = function(player)
	return roles[player]
end

game.Workspace:WaitForChild'Events':WaitForChild'SetRole'.OnInvoke = function(player, role)
	roles[player] = role
end

game.Workspace:WaitForChild'Events':WaitForChild'GetRoleLocal'.OnServerInvoke = function(player)
	return roles[player]
end

game.Workspace:WaitForChild'Events':WaitForChild'AddInventory'.OnServerInvoke = function(player, item, category)
	table.insert((inventories[player])[category], item)
	game.Workspace.Events.DataStore.WriteToWait:Invoke('inventory', player.userId, inventories[player])
end

game.Workspace.Events:WaitForChild'EpilogueServer'.Event:connect(function()
	epilogue = true
end)

game.Workspace.Events:WaitForChild'TouchEvent'.OnServerEvent:connect(function(player)
	if epilogue and player.TeamColor ~= BrickColor.new("Fossil") then
		game.Workspace.Events.GameEnd:Fire(player.Name)
	end
end)

game.Workspace:WaitForChild'Events':WaitForChild'GetInventory'.OnServerInvoke = function(player)
	inventories[player] = game.Workspace.Events.DataStore.ReadFrom:Invoke('inventory', player.userId)	
	if inventories[player] == nil or inventories[player]['shirts'] == nil then
		inventories[player] = {
			hats = {},
			faces = {},
			guns = {},
			shirts = {}
		}
		game.Workspace.Events.DataStore.WriteTo:Fire('inventory', player.userId, inventories[player])
	end
	return inventories[player]
end

game.Workspace:WaitForChild'Events':WaitForChild'GetInventoryServer'.OnInvoke = function(player)
	inventories[player] = game.Workspace.Events.DataStore.ReadFrom:Invoke('inventory', player.userId)	
	if inventories[player] == nil or inventories[player]['shirts'] == nil then
		inventories[player] = {
			hats = {},
			faces = {},
			guns = {},
			shirts = {}
		}
		game.Workspace.Events.DataStore.WriteTo:Fire('inventory', player.userId, inventories[player])
	end
	return inventories[player]
end

game.Workspace:WaitForChild'Events':WaitForChild'SetTarget'.Event:connect(function(hunter, target)
	hunters[target] = hunter
	targets[hunter] = target
	print(hunter.Name .. " now hunting " .. target.Name)
	game.Workspace.Events.SetTargetLocal:FireClient(hunter)
end)

game.Workspace:WaitForChild'Events':WaitForChild'GetTarget'.OnInvoke = function(player)
	return targets[player]
end

game.Workspace:WaitForChild'Events':WaitForChild'GetTargetLocal'.OnServerInvoke = function(player)
	return targets[player]
end

game.Workspace:WaitForChild'Events':WaitForChild'GetHunter'.OnInvoke = function(player)
	return hunters[player]
end

game.Workspace.Events:WaitForChild'GetCountdown'.OnServerInvoke = function(player)
	return endTime - tick()
end

game.Workspace.Events:WaitForChild'DiedEvent'.Event:connect(function(killer, victim)
	local chat = victim.Name .. " was killed by " .. killer.Name .. "!"
	game.ReplicatedStorage.ChatEvent:FireAllClients(chat)
	spawn(function()
		--pcall(function()
			local contracts = require(script.Parent.ContractHandler)
			contracts.checkDeath(killer, victim, roles[killer], roles[victim], targets[killer], targets[victim])
		--end)
	end)
	stats[killer] = stats[killer] + 1
	badges.death(killer, roles[killer], roles[victim], victim, stats[killer])
	if roles[killer] == "Police" then
		roundStats.policeKills = roundStats.policeKills + 1
	end
	if roles[killer] == "Undercover" then
		roundStats.undercoverKills = roundStats.undercoverKills + 1
	end
	if roles[killer] == "Framed" then
		if targets[killer] ~= victim and targets[victim] ~= killer then
			roundStats.accidents = roundStats.accidents + 1
		end
	end
end)

function updateBoard(winner)
	local image
	local wkills
	if winner == "Police" or winner == "CPolice" or winner == "OPolice" then
		wkills = roundStats.policeKills or 0
		image = 'http://www.roblox.com/asset/?id=270137916'
	elseif winner == "DFramed" or winner == "CFramed" or winner == "DAgents" then
		wkills = roundStats.undercoverKills or 0
		image = 'http://www.roblox.com/asset/?id=273379019'
	else
		wkills = stats[game.Players[winner]] or 0
		image = GetImageBindable:Invoke(game.Players[winner])
	end
	local pkills = roundStats.policeKills
	local ukills = roundStats.undercoverKills
	local accidents = roundStats.accidents
	game.Workspace.Events.UpdateBoard:Fire(
		pkills, ukills, wkills, accidents, image
	)
end

function gameEnd(winner)
	pcall(function()
		updateBoard(winner)
	end)
	local gameMode = game.Workspace.Values.GameMode.Value
	if game.Workspace.Values.GameMode.Value == "Ending" then return end
	game.Workspace.Values.GameMode.Value = "Ending"
	local counter = 0
	for _, p in pairs(game.Players:GetPlayers()) do
		p:LoadCharacter()
		if p.TeamColor == BrickColor.new("Toothpaste") then
			counter = counter + 1
		end
		p.TeamColor = BrickColor.new("Fossil")
	end
	game.StarterGui.Countdown.GameMode.Visible = false
	inProgress = false
	local delay = 10
	local endTime = tick() + delay
	game.Workspace.Events.CountdownTextMod:Fire("Game Ended", delay)
	--Set up awaiting screen
	local screen = game.Workspace.EndArea.Screen.SurfaceGui.Frame
	if winner == "Police" or winner == "CPolice" or winner == "OPolice" then
		spawn(function()
			print("Distributing wins.")
			--pcall(function()
				for _, p in pairs(game.Players:GetPlayers()) do
					if roles[p] and (roles[p] == "Police" or roles[p] == "Undercover" or roles[p] == "CPolice" or roles[p] == "OPolice") then
						pcall(function()
							p.leaderstats.Wins.Value = p.leaderstats.Wins.Value + 1
							game.Workspace.Events.DataStore.WriteTo:Fire("bux", p.userId, 15)
							badges.win(p)
							game:GetService("PointsService"):AwardPoints(p.userId, 25)
						end)
					end
				end
			--end)
		end)
		screen.Background.ImageColor3 = BrickColor.new("Bright blue").Color
		screen.Winner.Text = "The Police win!"
		screen.WinnerImage.Image = "http://www.roblox.com/asset/?id=270137916"
		local winnerText = {
			"The situation is under control. All spies were captured!",
			"After the Police were sent in to a local party to stop a spy, \n it was discovered that EVERY partygoer was a spy.",
			"The Police successfully stopped the violence at a party this evening.",
			"The local Police force was able to control the situation.",
			"The Police caught several spies Red-Handed this evening.",
			"Thanks to the help of undercover cops, the Police cracked down \n on several spies today."
		}
		screen.Description.Text = winnerText[math.random(1, #winnerText)]
	elseif winner == "DAgents" then
		spawn(function()
			print("Distributing wins.")
			--pcall(function()
				for _, p in pairs(game.Players:GetPlayers()) do
					if roles[p] and (roles[p] == "DAgent") then
						pcall(function()
							if #game.Players:GetPlayers() < 4 then return end
							p.leaderstats.Wins.Value = p.leaderstats.Wins.Value + 1
							game.Workspace.Events.DataStore.WriteTo:Fire("bux", p.userId, 15)
							badges.win(p)
							game:GetService("PointsService"):AwardPoints(p.userId, 25)
						end)
					end
				end
			--end)
		end)
		screen.Background.ImageColor3 = BrickColor.new("Bright red").Color
		screen.Winner.Text = "The Double Agents win!"
		screen.WinnerImage.Image = "http://www.roblox.com/asset/?id=273379019"
		local winnerText = {
			"Undercover spy operation put to an end today thanks to Double Agents.",
			"Double Agents were able to infiltrate a spy operation at a party today.",
			"'We discovered that the partygoers may not actually be just framed.'"
		}
		screen.Description.Text = winnerText[math.random(1, #winnerText)]
	elseif winner == "DFramed" or winner == "CFramed" then
		spawn(function()
			print("Distributing wins.")
			--pcall(function()
				for _, p in pairs(game.Players:GetPlayers()) do
					if roles[p] and (roles[p] == "DFramed" or roles[p] == "CFramed") then
						pcall(function()
							if #game.Players:GetPlayers() < 4 then return end
							p.leaderstats.Wins.Value = p.leaderstats.Wins.Value + 1
							game.Workspace.Events.DataStore.WriteTo:Fire("bux", p.userId, 15)
							badges.win(p)
							game:GetService("PointsService"):AwardPoints(p.userId, 25)
						end)
					end
				end
			--end)
		end)
		screen.Background.ImageColor3 = BrickColor.new("Bright red").Color
		screen.Winner.Text = "The Framed win!"
		screen.WinnerImage.Image = "http://www.roblox.com/asset/?id=273379019"
		local winnerText
		if winner == "DFramed" then
			winnerText = {
				"Undercover spy operation successfully stopped enemy Double Agents.",
				"Double Agents were not able to infiltrate a spy operation at a party today.",
				"'We were able to stop all of the double agents from infiltrating the party.'"
			}
		else
			winnerText = {
				"Local residents escaped from the Police today. \n Their innocence is in question.",
			}
		end
		screen.Description.Text = winnerText[math.random(1, #winnerText)]
	else
		spawn(function()
			print("Distributing wins.")
			pcall(function()
				print(stats[game.Players[winner]])
				game.Players[winner].leaderstats.Wins.Value = game.Players[winner].leaderstats.Wins.Value + 1
				game.Workspace.Events.DataStore.WriteTo:Fire("bux", game.Players[winner].userId, 15)
				badges.win(game.Players[winner], counter, stats[game.Players[winner]])
				game:GetService("PointsService"):AwardPoints(game.Players[winner].userId, 25)
			end)
		end)
		screen.Background.ImageColor3 = BrickColor.new("Bright red").Color
		screen.Winner.Text = winner .. " wins!"
		screen.WinnerImage.Image = GetImageBindable:Invoke(game.Players[winner])
		local winnerText = {
			"Many are considering that a local resident was only framed for his crimes.",
			"A local resident escaped from the Police today. His innocence is in question.",
			"After receiving a tip from an agent, the Police think a local 'spy' may only be Framed.",
			"'I never do nothing wrong, but I always get Framed', claims local resident.",
			"Upper-class resident escaped Police this evening at a dangerous party."
		}
		screen.Description.Text = winnerText[math.random(1, #winnerText)]
	end
	--Teleport players cameras there
	game.Workspace.Events.GameEndLocal:FireAllClients(delay)
	if game.Workspace.Values.Map.Value then
		game.Workspace.Values.Map.Value:Destroy()
		game.Workspace.Values.Map.Value = nil
	end
	repeat wait() until tick() > endTime
	game.Workspace.Values.GameMode.Value = "Framed"
	for _, p in pairs(game.Players:GetPlayers()) do
		game.Workspace.Events.GameEndLocal:FireAllClients(0, true)
	end
	print("Ready.")
	gameStart()
end

function gameStart()
	game.Workspace.Values.Epilogue.Value = false
	repeat wait() until game.Players.NumPlayers > 2
	wait()
	local delay = 20
	local endTime = tick() + delay
	game.Workspace.Events.CountdownTextMod:Fire("Intermission", delay)
	repeat wait() until tick() > endTime
	roundStats = {
		accidents = 0,
		policeKills = 0,
		undercoverKills = 0
	}
	local mapName, image, gameMode
	mapName, image, gameMode = voter.getMap()

	game.Workspace.Values.GameMode.Value = gameMode
	local startTime = tick()
	local childNum
	if gameMode == "On The Run" or gameMode == "City Chase" then
		childNum = #(game.ServerStorage.Bonuses[mapName]:GetChildren())
	else
		childNum = #(game.ServerStorage.Maps[mapName]:GetChildren())
	end
	game.Workspace.Events.MapLoading:FireAllClients(mapName, childNum, gameMode, image)
	if gameMode == "On The Run" or gameMode == "City Chase" then
		map = game.ServerStorage.Bonuses[mapName]:Clone()
	else
		map = game.ServerStorage.Maps[mapName]:Clone()
	end
	map.Parent = game.Workspace
	repeat wait() until #(map:GetChildren()) >= childNum
	print("Loaded map.")
	for i = 1, 15 do
		map:WaitForChild("Spawn" .. i)
	end
	game.ReplicatedStorage.Clothes.TempFaces:ClearAllChildren()
	for _, face in pairs(game.ReplicatedStorage.Clothes.Faces:GetChildren()) do
		face:Clone().Parent = game.ReplicatedStorage.Clothes.TempFaces
	end
	print("Map loaded in " .. tick() - startTime)
	game.Workspace.Values.Map.Value = map
	startTime = tick()
	local players = game.Players:GetPlayers()
	stats = {}
	for _, p in pairs(players) do
		stats[p] = 0
	end
	roles = targetsModule.makeRoles(players, gameMode)
	if gameMode == "Framed" or gameMode == "Classic Framed" then
		targets, hunters = targetsModule.makeTargets(players, roles)
	elseif gameMode == "Hunted Man" then
		targets, hunters = targetsModule.makeTargetsHuntedMan(players, roles)
	end
	game.StarterPlayer.LoadCharacterAppearance = false
	for _, p in pairs(players) do
		p:LoadCharacter(false)
		if roles[p] == "Framed" then
			print (targets[p].Name .. " is the target of " .. p.Name)
			print (hunters[p].Name .. " is the hunter of " .. p.Name)
		end
	end
	decorator.decoratePlayers(players)
	decorator.decor(map)
	players = targetsModule.scramble(players)
	if gameMode == "On The Run" then
		local upper = 3
		local lower = 1
		for i, p in pairs(players) do
			p.leaderstats.Points.Value = 0
			if roles[p] == "OPolice" then
				game.Workspace.Events.TeleportPlayer:Fire(p, map["Spawn" .. lower], 7)
				lower = lower + 1
			else
				game.Workspace.Events.TeleportPlayer:Fire(p, map["Spawn" .. upper], 7)
				upper = upper + 1
			end
			game.Workspace.Events.GameStart:FireClient(p, roles[p], 5)
		end
	else
		for i, p in pairs(players) do
			p.leaderstats.Points.Value = 0
			p.PoliceTarget.Value = false
			p.RedHanded.Value = false
			game.Workspace.Events.TeleportPlayer:Fire(p, map["Spawn" .. i], 7)
			game.Workspace.Events.GameStart:FireClient(p, roles[p], 5)
		end
	end
	tools.distributeTools(players, roles)
	print("Everything else in " .. tick() - startTime)
	game.StarterPlayer.LoadCharacterAppearance = true
	local delay = 5
	endTime = tick() + delay
	game.Workspace.Events.CountdownTextMod:Fire("Prologue", delay)
	repeat wait() until tick() > endTime
	local delay = 230
	endTime = tick() + delay
	game.Workspace.Events.CountdownTextMod:Fire(gameMode, delay)
	inProgress = true
	epilogue = false
	local ticks = 0
	repeat
		wait()
		if ticks > 100 then
			ticks = 0
			game.Workspace.Events.CountdownTextMod:Fire(gameMode, endTime - tick())
		else
			ticks = ticks + 1
		end		
	until tick() > endTime or epilogue or not inProgress
	if epilogue then
		local delay = 45
		endTime = tick() + delay
		game.Workspace.Events.CountdownTextMod:Fire("Epilogue", delay)
		repeat wait() until tick() > endTime or not inProgress
		if inProgress then
			game.Workspace.Events.GameEnd:Fire("Police")
		end
	elseif inProgress then
		game.Workspace.Events.GameEnd:Fire("Police")
	end
end

game.Workspace.Events.GameEnd.Event:connect(gameEnd)

gameStart()