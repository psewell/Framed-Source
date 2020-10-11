local module = {}

module.getImage = function()
	local ids = {}
	local tab
	while tab == nil do
		pcall(function()
			tab = game:GetService("InsertService"):GetFreeDecals("", math.random(1, 100))
		end)
		wait(0)
	end
	local function getIds()
		local ids = {}
		local page = tab[math.random(1, #tab)]
		for _, obj in pairs(page) do
			if not tonumber(obj) then
				for _, pic in pairs(obj) do
					for i = -3, 3 do
						local asset = game:GetService("MarketplaceService"):GetProductInfo(pic.AssetId + i)
						if asset.AssetTypeId == 1 then
							table.insert(ids, pic.AssetId + i)
						end
						if #ids > 5 then
							return ids
						end
					end
				end
			end
		end
	end
	ids = getIds()
	return "rbxassetid://" .. ids[math.random(1, #ids)]
end

return module
