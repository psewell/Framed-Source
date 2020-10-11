local module = {}

module.new = function()
	
	local function key(player)
		return player.userId
	end
	
	local dataStore = game:GetService("DataStoreService")
	local dataStores = {
		wins = dataStore:GetOrderedDataStore("Wins"),
		shop = dataStore:GetDataStore("Shop"),
		loadout = dataStore:GetDataStore("Loadout"),
		stats = dataStore:GetDataStore("Stats"),
		inventory = dataStore:GetDataStore("Inventory")
	}
	
	game.Workspace:WaitForChild'Events':WaitForChild'DataStore':WaitForChild'WriteTo'.Event:connect(function(
	storeName, key, val)
		if key == nil or key == "" then return end
		if storeName == "wins" then
			dataStores.wins:UpdateAsync(key, function(oldVal)
				if oldVal == nil then return val end
				if oldVal < val then
					return val
				else
					return oldVal
				end
			end)
		elseif storeName == "bux" then
			dataStores.shop:UpdateAsync(key .. "bux", function(oldVal)
				if oldVal == nil then return val end
				if oldVal + val > 600000 then return 1000 end
				return math.max(0, oldVal + val)
			end)
		else
			dataStores[storeName]:SetAsync(key, val)
		end
	end)
	
	game.Workspace:WaitForChild'Events':WaitForChild'DataStore':WaitForChild'WriteToWait'.OnInvoke = function(
	storeName, key, val)
		if key == nil or key == "" then return end
		if storeName == "wins" then
			dataStores.wins:UpdateAsync(key, function(oldVal)
				if oldVal == nil then return val end
				if oldVal < val then
					return val
				else
					return oldVal
				end
			end)
		elseif storeName == "bux" then
			dataStores.shop:UpdateAsync(key .. "bux", function(oldVal)
				if oldVal == nil then return val end
				if oldVal + val > 600000 then return 1000 end
				return math.max(0, oldVal + val)
			end)
		else
			dataStores[storeName]:SetAsync(key, val)
		end
	end
	
	game.Workspace:WaitForChild'Events':WaitForChild'DataStore':WaitForChild'WriteToWaitLocal'.OnServerInvoke = function(
	player, storeName, key, val)
		if key == nil or key == "" then return end
		key = player.UserId
		if storeName == "bux" then
			dataStores.shop:UpdateAsync(key .. "bux", function(oldVal)
				if oldVal == nil then return val end
				if oldVal + val > oldVal then
					return oldVal
				else
					if oldVal + val > 600000 then return 1000 end
					return math.max(0, oldVal + val)
				end
			end)
		elseif storeName == "loadout" then
			dataStores[storeName]:SetAsync(key, val)
			local loadout = val
			player.Loadout.Color.Value = BrickColor.new(loadout.color)
			player.Loadout.Shirt.Value = loadout.shirt
			player.Loadout.Hat.Value = loadout.hat
			player.Loadout.Gun.Value = loadout.gun
			player.Loadout.IsFemale.Value = loadout.isFemale
			player.Loadout.Face.Value = loadout.face
		end
	end
	
	game.Workspace.Events.DataStore:WaitForChild'GetLoadout'.OnInvoke = function(key)
		local Loadout = nil
		dataStores.loadout:UpdateAsync(key, function(oldVal)
			if oldVal == nil then
				Loadout = {
					isFemale = false,
					color = "Institutional white",
					hat = "Default",
					shirt = "Default",
					gun = "Default",
					face = "Default"
				}
				return Loadout
			else
				Loadout = oldVal
				return oldVal
			end
		end)
		return Loadout
	end
	
	game.Workspace.Events.DataStore:WaitForChild'GetLoadoutLocal'.OnServerInvoke = function(_, key)
		local Loadout = nil
		dataStores.loadout:UpdateAsync(key, function(oldVal)
			if oldVal == nil then
				Loadout = {
					isFemale = false,
					color = "Institutional white",
					hat = "Default",
					shirt = "Default",
					gun = "Default",
					face = "Default"
				}
				return Loadout
			else
				Loadout = oldVal
				return oldVal
			end
		end)
		return Loadout
	end
	
	game.Workspace:WaitForChild'Events':WaitForChild'DataStore':WaitForChild'ReadFrom'.OnInvoke = function(
	storeName, key)
		if storeName == 'bux' then
			local buxAmount = math.max(0, dataStores.shop:GetAsync(key .. "bux")) or 0
			if buxAmount > 600000 then
				return 1000
			else
				return buxAmount
			end
		else
			return dataStores[storeName]:GetAsync(key)
		end
	end
	
	game.Workspace:WaitForChild'Events':WaitForChild'DataStore':WaitForChild'ReadFromLocal'.OnServerInvoke = function(
	_, storeName, key)
		if storeName == 'bux' then
			local buxAmount = math.max(0, dataStores.shop:GetAsync(key .. "bux")) or 0
			if buxAmount > 600000 then
				return 1000
			else
				return buxAmount
			end
		else
			return dataStores[storeName]:GetAsync(key)
		end
	end
end

return module
