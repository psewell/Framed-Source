local module = {}

module.new = function()
	local badges = require(script.Parent:WaitForChild'BadgeHandler')	
	
	local function checkValues(player, val, clientVal)
		if val ~= clientVal then
			player:Kick("Sorry, this was patched.")
			return false
		end
	end
	
	local function checkBux(player, val, clientVal)
		checkValues(player, val, clientVal)
		local oldVal = game.Workspace.Events.DataStore.ReadFrom:Invoke("bux", player.userId)
		if oldVal >= val then
			game.Workspace.Events.DataStore.WriteToWait:Invoke("bux", player.userId, -val)
			return true
		end
		return false
	end
	
	local function checkPoints(player, val, clientVal)
		checkValues(player, val, clientVal)
		if player.leaderstats.Points.Value >= val then
			player.leaderstats.Points.Value = player.leaderstats.Points.Value - val
			return true
		end
		return false
	end
	
	local function buyItem(player, item)
		if item[item.Name]:IsA("Tool") then
			item[item.Name]:Clone().Parent = player.Backpack
		else
			local s = require(item[item.Name])
			s.new(player)
		end
		badges.shopBuy(player, item.Name)
	end

	game.Workspace.Events.ShopRequest.OnServerInvoke = function(player, currency, item, _price)
		local bought = false
		print("Received shop request from " .. player.Name .. ", paying in " .. currency .. " for " .. item)
		local role = game.Workspace.Events.GetRole:Invoke(player)
		local theItem = game.ReplicatedStorage.IngameShop[role][item]
		
		if currency == "Points" then
			local price = theItem.Points.Value
			bought = checkPoints(player, price, _price)
		end
		if currency == "Bux" then
			local price = theItem.FBucks.Value
			bought = checkBux(player, price, _price)
		end
		if bought then
			buyItem(player, theItem)
		end
		return bought
	end
end

return module
