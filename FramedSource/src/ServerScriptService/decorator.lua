local module = {}

local this = module

module.randomChild = function(tab)
	return tab[math.random(1, #tab)]
end

module.decor = function(mdl)
	for _, model in pairs(mdl:GetChildren()) do
		if model.Name == "Model" and model:FindFirstChild("") and model[""]:FindFirstChild("Head")
			and model[""].Head:FindFirstChild("face") then
			this.decorateFigure(model[""])
		end
		if model:isA("Model") then
			this.decor(model)
		end
	end
end

module.shirtColors = function()
	local scolors = {}
	scolors[1] = BrickColor.new("Bright orange")
	scolors[2] = BrickColor.new("Grime")
	scolors[3] = BrickColor.new("Bright bluish green")
	scolors[4] = BrickColor.new("Dark stone grey")
	scolors[5] = BrickColor.new("Bright yellow")
	scolors[6] = BrickColor.new("Lavender")
	scolors[7] = BrickColor.new("Light stone grey")
	return scolors
end

module.decoratePlayers = function(players)
	math.randomseed(tick() * math.random())
	for _, player in pairs(players) do
		local role = game.Workspace.Events.GetRole:Invoke(player)
		if role == "Police" or role == "CPolice" or role == "OPolice" then
			this.decoratePolice(player)
		else
			local face
			if player.Loadout.Face.Value ~= 0 and player.Loadout.Face.Value ~= nil then
				for _, facez in pairs(game.ReplicatedStorage.Clothes.TempFaces:GetChildren()) do
					if facez.Name == tostring(player.Loadout.Face.Value) then
						face = facez
						break
					end
				end
				if face == nil then
					face = this.randomChild(game.ReplicatedStorage.Clothes.TempFaces:GetChildren())
				end
			else
				face = this.randomChild(game.ReplicatedStorage.Clothes.TempFaces:GetChildren())
			end
			this.decorateFramed(player, face.Value)
			face:Destroy()
			if role == "DAgent" then
				for _, p in pairs(game.Players:GetPlayers()) do
					if game.Workspace.Events.GetRole:Invoke(p) == "DAgent" then
						game.Workspace.Events.AgentMark:FireClient(p, player)
					end
				end
			end
		end
		if game.Workspace.Values.GameMode.Value == "City Chase" then
			if role == "CPolice" then
				for _, p in pairs(game.Players:GetPlayers()) do
					if p.TeamColor ~= BrickColor.new("Fossil") then
						game.Workspace.Events.PoliceMark:FireClient(p, player)
					end
				end
			else
				for _, p in pairs(game.Players:GetPlayers()) do
					if p.TeamColor ~= BrickColor.new("Fossil") then
						game.Workspace.Events.FramedMark:FireClient(p, player)
					end
				end
			end
		end
	end
end

module.decoratePolice = function(player)
	if not player.Character then return end
	local char = player.Character
	if char.Torso:FindFirstChild("roblox") then
		char.Torso:FindFirstChild("roblox"):Destroy()
	end
	player:ClearCharacterAppearance()
	char.Head.Mesh:Destroy()
	local mesh = game.ReplicatedStorage.Clothes.Mesh:Clone()
	mesh.Parent = char.Head
	char.Head.face.Texture = "rbxassetid://12117740"
	if player.Loadout.IsFemale.Value then
		local torso = game.ReplicatedStorage.Clothes.girlTorso:Clone()
		torso.Parent = char
	end
	local hat = game.ReplicatedStorage.Clothes.Police:Clone()
	hat.Parent = char
	local shirt = Instance.new("Shirt")
	shirt.Parent = char
	shirt.ShirtTemplate = "rbxassetid://1972067"
	local pants = Instance.new("Pants")
	pants.Parent = char
	pants.PantsTemplate = "http://www.roblox.com/asset/?id=1960214"
	local bodyColors = Instance.new("BodyColors")
	local bodyColor = this.randomChild({
		BrickColor.new("Brown"),
		BrickColor.new("Pastel brown"),
		BrickColor.new("Bright yellow"),
		BrickColor.new("Nougat"),
		BrickColor.new("Light orange"),
		BrickColor.new("Br. yellowish orange")
	})
	bodyColors.Parent = char
	for _, part in pairs({
		"LeftArmColor",
		"RightArmColor",
		"TorsoColor",
		"HeadColor"
	}) do
		bodyColors[part] = bodyColor
	end
	local pantsColor = BrickColor.new("Black")
	bodyColors.LeftLegColor = pantsColor
	bodyColors.RightLegColor = pantsColor
	for _, p in pairs(game.Players:GetPlayers()) do
		if p.TeamColor ~= BrickColor.new("Fossil") then
			game.Workspace.Events.PoliceMark:FireClient(p, player)
		end
	end
end

module.decorateFramed = function(player, face)
	if not player.Character then return end
	local char = player.Character
	if char.Torso:FindFirstChild("roblox") then
		char.Torso:FindFirstChild("roblox"):Destroy()
	end
	player:ClearCharacterAppearance()
	char.Head.Mesh:Destroy()
	local mesh = game.ReplicatedStorage.Clothes.Mesh:Clone()
	mesh.Parent = char.Head
	char.Head.face.Texture = "rbxassetid://" .. face
	if player.Loadout.IsFemale.Value then
		local torso = game.ReplicatedStorage.Clothes.girlTorso:Clone()
		torso.Parent = char
	end
	if player.Loadout.Hat.Value ~= "" and player.Loadout.Hat.Value ~= "Default" then
		local hat = game.ReplicatedStorage.Clothes.Hats[player.Loadout.Hat.Value]:Clone()
		hat.Parent = char
	else
		if player.Loadout.IsFemale.Value then
			local hat = this.randomChild(game.ReplicatedStorage.Clothes.WomanHair:GetChildren()):Clone()
			hat.Parent = char
		else
			local hat = this.randomChild(game.ReplicatedStorage.Clothes.ManHair:GetChildren()):Clone()
			hat.Parent = char
		end
	end
	if player.Loadout.Shirt.Value ~= "" and player.Loadout.Shirt.Value ~= "Default" then
		local shirt = Instance.new("Shirt")
		shirt.Parent = char
		shirt.ShirtTemplate = "rbxassetid://" .. game.ReplicatedStorage.Clothes.Shirts[player.Loadout.Shirt.Value].Value
	else
		local shirt = Instance.new("Shirt")
		shirt.Parent = char
		shirt.ShirtTemplate = "rbxassetid://36519565"
	end
	local pants = Instance.new("Pants")
	pants.Parent = char
	pants.PantsTemplate = "rbxassetid://36519584"
	local bodyColors = Instance.new("BodyColors")
	bodyColors.Parent = char
	if player.Loadout.Color.Value ~= BrickColor.new("Institutional white") then
		bodyColors.LeftArmColor = player.Loadout.Color.Value
		bodyColors.RightArmColor = player.Loadout.Color.Value
		bodyColors.TorsoColor = player.Loadout.Color.Value
	else
		local shirtColor = this.randomChild(this.shirtColors())
		bodyColors.LeftArmColor = shirtColor
		bodyColors.RightArmColor = shirtColor
		bodyColors.TorsoColor = shirtColor
	end
	local pantsColor = this.randomChild({
		BrickColor.new("Brown"),
		BrickColor.new("Dark stone grey"),
		BrickColor.new("Navy blue"),
		BrickColor.new("Black")		
	})
	bodyColors.LeftLegColor = pantsColor
	bodyColors.RightLegColor = pantsColor
	local bodyColor = this.randomChild({
		BrickColor.new("Brown"),
		BrickColor.new("Pastel brown"),
		BrickColor.new("Bright yellow"),
		BrickColor.new("Nougat"),
		BrickColor.new("Light orange"),
		BrickColor.new("Br. yellowish orange")
	})
	bodyColors.HeadColor = bodyColor
	if game.Workspace.Values.GameMode.Value == "City Chase" then
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.TeamColor ~= BrickColor.new("Fossil") then
				game.Workspace.Events.FramedMark:FireClient(p, player)
			end
		end
	end
end

module.decorateFigure = function(char)
	local pos = char.Torso.CFrame
	local oldp = char.Parent.Parent
	char.Parent:Destroy()
	char = game.ServerStorage.Dummy:Clone()
	char.Parent = oldp
	char:SetPrimaryPartCFrame(pos)
	local mesh
	local isFemale = false
	if math.random(1, 2) == 1 then
		local torso = game.ReplicatedStorage.Clothes.girlTorso:Clone()
		torso.Parent = char
		isFemale = true
	end
	if math.random(1, 5) == 1 then
		mesh = game.ReplicatedStorage.Clothes.Hats:GetChildren()
	else
		if isFemale then 
			mesh = game.ReplicatedStorage.Clothes.WomanHair:GetChildren()
		else
			mesh = game.ReplicatedStorage.Clothes.ManHair:GetChildren()
		end
	end
	local mesh = mesh[math.random(1, #mesh)]:Clone()
	mesh.Parent = char
	mesh.Handle.CFrame = char.Head.CFrame * CFrame.new(0, char.Head.Size.Y / 2, 0) * mesh.AttachmentPoint:inverse()
	local hroot = char

	--Good from here! Time to add in the new stuff!
	--NEW STUFF--
	-------------
	--Determine what the NPC's color will be
	--Got player color root
	local colors = {}
	colors[1] = "Brown"
	colors[2] = "Pastel brown"
	colors[3] = "Bright yellow"
	colors[4] = "Light orange"
	colors[5] = "Br. yellowish orange"
	colors[6] = "Nougat"
	local PCOLOR = math.random(1,6)
	char["Head"].BrickColor = BrickColor.new(colors[PCOLOR])
	--Determine what face to wear
	local F = hroot.Head.Face
	local faces = game.ReplicatedStorage.Clothes.TempFaces:GetChildren()
	if #faces > 0 then
		F.Texture = "rbxassetid://" .. this.randomChild(faces).Value
	end
	--Determine shirt colors
	local scolors = {}
	scolors[1] = "Bright orange"
	scolors[2] = "Grime"
	scolors[3] = "Bright bluish green"
	scolors[4] = "Dark stone grey"
	scolors[5] = "Bright yellow"
	scolors[6] = "Lavender"
	scolors[7] = "Light stone grey"
	local SCOLOR = math.random(1,7)
	char.Torso.BrickColor = BrickColor.new(scolors[SCOLOR])
	char["Left Arm"].BrickColor = BrickColor.new(scolors[SCOLOR])
	char["Right Arm"].BrickColor = BrickColor.new(scolors[SCOLOR])
	--Determine pants colors
	local pantsColor = this.randomChild({
		BrickColor.new("Brown"),
		BrickColor.new("Dark stone grey"),
		BrickColor.new("Navy blue"),
		BrickColor.new("Black")		
	})
	char["Left Leg"].BrickColor = pantsColor
	char["Right Leg"].BrickColor = pantsColor
	local shirtsz = {}
	shirtsz[2] = "http://www.roblox.com/asset/?ID=151999386"
	shirtsz[3] = "http://www.roblox.com/asset/?ID=77133849"
	shirtsz[4] = "http://www.roblox.com/asset/?ID=153449015"
	shirtsz[5] = "http://www.roblox.com/asset/?ID=171593061"
	shirtsz[6] = "http://www.roblox.com/asset/?ID=171593787"
	shirtsz[7] = "http://www.roblox.com/asset/?ID=171593793"
	shirtsz[8] = "http://www.roblox.com/asset/?ID=171593798"
	local shirtnum = math.random(1, 8)
	if shirtnum ~= 1 then
		for _, ch in pairs(char:GetChildren()) do
			if ch:IsA("Shirt") then
				ch.ShirtTemplate = shirtsz[shirtnum]
				break
			end
		end
	end
	spawn(function()
		wait(math.random())
		char.meh:LoadAnimation(game.ServerStorage.Idle):Play()
		if math.random() > 0.5 then
			char.meh:LoadAnimation(game.ServerStorage.Tool):Play()
			local glass = game.ServerStorage.Glass:Clone()
			glass.Parent = char
			local weld = Instance.new("Weld")
			weld.Part0 = glass.Handle
			weld.Part1 = char["Right Arm"]
			weld.C0 = CFrame.new(0, 0, 1)
			weld.C1 = CFrame.Angles(-math.pi / 2, 0, 0)
			weld.Parent = glass
		end
	end)
	char:SetPrimaryPartCFrame(pos)
end

return module
