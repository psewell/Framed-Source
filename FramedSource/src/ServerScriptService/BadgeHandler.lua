local module = {}

local plkl = game:GetService("DataStoreService"):GetOrderedDataStore("PKills")

module.death = function(killer, kRole, vRole, victim, kills)
	local badgeservice = game:GetService("BadgeService")
	if kills == 5 then
		badgeservice:AwardBadge(killer.userId, 167994071)
	end
	if kills == 8 then
		badgeservice:AwardBadge(killer.userId, 169288684)
	end
	if kRole == "Police" and vRole == "Framed" then
		badgeservice:AwardBadge(victim.userId, 167990640)
	end
	if game.Workspace.Events.GetHunter:Invoke(killer) == victim then
		badgeservice:AwardBadge(killer.userId, 169288315)
	end
	if kRole == "Police" then
		local kills = 0
		plkl:UpdateAsync(killer.Name, function(val)
			if val == nil then val = 0 end
			kills = val + 1
			return kills
		end)
		if kills >= 50 then
			badgeservice:AwardBadge(killer.userId, 169288095)
		end
		if kills >= 100 then
			badgeservice:AwardBadge(killer.userId, 167988869)
		end
	end
	if game.Workspace.Values.Epilogue.Value then
		if vRole == "Framed" then
			badgeservice:AwardBadge(victim.userId, 190614118)
		end
	end
end

module.win = function(winner, num, kills)
	local badgeservice = game:GetService("BadgeService")
	if winner.leaderstats.Wins.Value > 100 then
		badgeservice:AwardBadge(winner.userId, 167993873)
	end
	if num == 0 then
		badgeservice:AwardBadge(winner.userId, 190614320)
	end
	if kills == 0 then
		badgeservice:AwardBadge(winner.userId, 168208875)
	end
end

module.shopBuy = function(player, item)
	local badgeservice = game:GetService("BadgeService")
	local shopBuy = game:GetService("DataStoreService"):GetDataStore("ShopBuys")
	local val = 0
	shopBuy:UpdateAsync(player.userId .. item, function(oldVal)
		if oldVal == nil then
			val = 0
		else
			val = oldVal + 1
		end
		return val
	end)
	if item == "MP5" then
		if val >= 20 then
			badgeservice:AwardBadge(player.userId, 190613406)
		end
	end
	if item == "Dragunov" then
		if val >= 20 then
			badgeservice:AwardBadge(player.userId, 190613282)
		end
	end
	if item == "Flashbang" then
		if val >= 30 then
			badgeservice:AwardBadge(player.userId, 190613681)
		end
	end
	if item == "Bowie Knife" then
		if val >= 10 then
			badgeservice:AwardBadge(player.userId, 190613934)
		end
	end
	if item == "Radar" then
		if val >= 10 then
			badgeservice:AwardBadge(player.userId, 190613090)
		end
	end
end

return module