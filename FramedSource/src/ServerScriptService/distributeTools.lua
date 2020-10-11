local module = {}

local this = module

module.giveGun = function(player, role)
	local tools = game.ServerStorage.Tools
	local gun = player.Loadout.Gun.Value
	local isGold = player.Loadout.IsGunGold.Value
	local guntool
	if gun == "Default" or gun == "" then
		if role == "Framed" or role == "Undercover" or role == "DFramed" or role == "DAgent"
			or role == "HFramed" or role == "HMan" or role == "CFramed" then
			guntool = tools["Luger"]:Clone()
		end
		if role == "Police" or role == "CPolice" then
			guntool = tools["M1911"]:Clone()
		end
	else
		if tools:FindFirstChild(gun) ~= nil then
			guntool = tools[gun]:Clone()
		else
			guntool = tools[string.sub(gun,  0, string.find(gun,"rbxassetid://") -2)]:Clone()
			local img = string.sub(gun,string.find(gun, "rbx"), string.len(gun))
			guntool:WaitForChild'PistolPart':WaitForChild'Mesh'.TextureId = img
			pcall(function()
				if guntool:FindFirstChild'MeshPart' then
					guntool.MeshPart.TextureID = img
				end
			end)
			isGold = false
		end		
	end
	guntool.Parent = player.Backpack
	if isGold then
		for _, item in ipairs(guntool:GetDescendants()) do
			if item:IsA("MeshPart") then
				item.TextureID = ""
			elseif item:IsA("SpecialMesh") then
				item.TextureId = ""
			end
			if item:IsA("BasePart") then
				item.Reflectance = 0.8
				item.Material = Enum.Material.Metal
				item.BrickColor = BrickColor.new("Cool yellow")
			end
		end
	end
end

module.distributeTools = function(players, roles)
	local tools = game.ServerStorage.Tools
	for _, p in pairs(players) do
		if roles[p] == "Framed" then
			tools["Check Target"]:Clone().Parent = p.Backpack
			this.giveGun(p, roles[p])
			tools["Blade"]:Clone().Parent = p.Backpack
			tools["Water"]:Clone().Parent = p.Backpack
		end
		if roles[p] == "Undercover" then
			this.giveGun(p, roles[p])
			tools["Police Badge"]:Clone().Parent = p.Backpack
			tools["Water"]:Clone().Parent = p.Backpack
		end
		if roles[p] == "Police" then
			this.giveGun(p, roles[p])
			tools["Police Badge"]:Clone().Parent = p.Backpack
		end
		if roles[p] == "DFramed" or roles[p] == "DAgent" then
			this.giveGun(p, roles[p])
			tools["Blade"]:Clone().Parent = p.Backpack
			tools["Water"]:Clone().Parent = p.Backpack
		end
		if roles[p] == "HMan" or roles[p] == "HFramed" then
			tools["Check Target"]:Clone().Parent = p.Backpack
			this.giveGun(p, roles[p])
			tools["Blade"]:Clone().Parent = p.Backpack
			tools["Water"]:Clone().Parent = p.Backpack
		end
		if roles[p] == "CFramed" or roles[p] == "CPolice" then
			this.giveGun(p, roles[p])
			tools["MP5"]:Clone().Parent = p.Backpack
			tools["Dragunov"]:Clone().Parent = p.Backpack
		end
		if roles[p] == "OPolice" then
			tools["Dragunov"]:Clone().Parent = p.Backpack
		end
	end
end

return module
