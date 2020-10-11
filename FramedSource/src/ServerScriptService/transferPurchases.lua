local module = {}

local this = module

module.transfer = function(player)
	print("This may take a while.")
	local hats = {}
	hats[2] = "Ghastly"
	hats[3] = "BFedora"
	hats[4] = "GTop"
	hats[5] = "Detective"
	hats[6] = "Bowler"
	hats[7] = "HBowler"
	hats[8] = "PTop"
	hats[9] = "BTop"
	hats[10] = "Punk"
	hats[11] = "Steam"
	hats[12] = "Checks"
	hats[13] = "Ghost"
	hats[14] = "ColdWar"
	hats[15] = "Flower"
	hats[16] = "Jazz"
	hats[17] = "Outlaw"
	hats[18] = "Bling"
	
	local shirts = {}
	shirts[2] = "SCoat"
	shirts[3] = "Vest"
	shirts[4] = "Spy"
	shirts[5] = "Bowtie"
	shirts[6] = "Blazer"
	shirts[7] = "Presidential"
	shirts[8] = "Casual"
	
	local realShirts = {}
	realShirts[2] = "Sport Coat"
	realShirts[3] = "Classy Vest"
	realShirts[4] = "Master Spy"
	realShirts[5] = "Bowtie"
	realShirts[6] = "Blazer"
	realShirts[7] = "Presidential"
	realShirts[8] = "Casual"
	
	local guns = {}
	guns[2] = "Mauser"
	guns[3] = "Six Shooter"
	
	local dataStore = game:GetService("DataStoreService")
	local dataStores = {
		shop = dataStore:GetDataStore("Shop"),
		stats = dataStore:GetDataStore("Stats"),
		inventory = dataStore:GetDataStore("Inventory")
	}
	if dataStores.stats:GetAsync(player.userId .. "loaded") then return end
	dataStores.stats:SetAsync(player.userId .. "loaded", true)
	local inventory = game.Workspace.Events.GetInventoryServer:Invoke(player)
	print("Loading F$.")
	local bux = dataStores.shop:GetAsync(player.Name .. "bux") or 0
	game.Workspace.Events.DataStore.WriteToWait:Invoke("bux", player.userId, bux)
	print("Loading hats.")
	for i = 2, 18 do
		if dataStores.shop:GetAsync(player.Name .. hats[i]) then
			table.insert(inventory.hats, hats[i])
		end
	end
	print("Loading shirts.")
	for i = 2, 8 do
		if dataStores.shop:GetAsync(player.Name .. shirts[i]) then
			table.insert(inventory.shirts, realShirts[i])
		end
	end
	print("Loading guns.")
	for i = 2, 3 do
		if dataStores.shop:GetAsync(player.Name .. guns[i]) then
			table.insert(inventory.guns, guns[i])
		end
	end
	game.Workspace.Events.DataStore.WriteToWait:Invoke('inventory', player.userId, inventory)
	print("All done.")
end

module.new = function()
	game.Workspace.Events.LoadOld.OnServerInvoke = function(player)
		this.transfer(player)
	end
end

return module