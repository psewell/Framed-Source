	hroot = script.Parent

	--Good from here! Time to add in the new stuff!
	--NEW STUFF--
	-------------
	--Determine what the NPC's color will be
	if not hroot:FindFirstChild("Body Colors") then
		bc = Instance.new("BodyColors")
		bc.Parent = hroot
		bc.Name = "Body Colors"
	end
	C = hroot["Body Colors"]
	--Got player color root
	colors = {}
	colors[1] = "Brown"
	colors[2] = "Pastel brown"
	colors[3] = "Bright yellow"
	colors[4] = "Light orange"
	colors[5] = "Br. yellowish orange"
	colors[6] = "Nougat"
	PCOLOR = math.random(1,6)
	C.HeadColor = BrickColor.new(colors[PCOLOR])
	--Determine what face to wear
	F = hroot.Head.face
	faces = {}
	faces[1] = "http://www.roblox.com/asset/?id=7058424"
	faces[2] = "http://www.roblox.com/asset/?id=129157225"
	faces[3] = "http://www.roblox.com/asset/?id=8056256"
	faces[4] = "http://www.roblox.com/asset/?id=84765513"
	faces[5] = "http://www.roblox.com/asset/?id=46191660"
	faces[6] = "http://www.roblox.com/asset/?id=63493270"
	faces[7] = "http://www.roblox.com/asset/?id=31142001"
	faces[8] = "http://www.roblox.com/asset/?id=63493189"
	faces[9] = "http://www.roblox.com/asset/?id=63495329"
	faces[10] = "http://www.roblox.com/asset/?id=19575865"
	faces[11] = "http://www.roblox.com/asset/?id=33082306"
	faces[12] = "http://www.roblox.com/asset/?id=21337447"
	faces[13] = "http://www.roblox.com/asset/?id=48292410"
	F.Texture = faces[math.random(1,13)]
	--Determine shirt colors
	scolors = {}
	scolors[1] = "Bright orange"
	scolors[2] = "Grime"
	scolors[3] = "Bright bluish green"
	scolors[4] = "Dark stone grey"
	scolors[5] = "Bright yellow"
	scolors[6] = "Lavender"
	scolors[7] = "Light stone grey"
	SCOLOR = math.random(1,7)
	C.TorsoColor = BrickColor.new(scolors[SCOLOR])
	C.LeftArmColor = BrickColor.new(scolors[SCOLOR])
	C.RightArmColor = BrickColor.new(scolors[SCOLOR])
	--Determine pants colors
	acolors = {}
	acolors[1] = "Brown"
	acolors[2] = "Dark stone grey"
	ACOLOR = math.random(1,2)
	C.LeftLegColor = BrickColor.new(acolors[ACOLOR])
	C.RightLegColor = BrickColor.new(acolors[ACOLOR])
	--Add hair
	hats = {}
	hats[1] = game.Lighting.Hair.h1.Handle.Mesh.MeshId
	hats[2] = game.Lighting.Hair.h2.Handle.Mesh.MeshId
	hats[3] = game.Lighting.Hair.h3.Handle.Mesh.MeshId
	hats[4] = game.Lighting.Hair.h4.Handle.Mesh.MeshId
	hats[5] = game.Lighting.Hair.h5.Handle.Mesh.MeshId
	hats[6] = game.Lighting.Hair.h6.Handle.Mesh.MeshId
	hats[7] = game.Lighting.Hair.h7.Handle.Mesh.MeshId
	hroot.Hat.Mesh.MeshId = hats[math.random(1,7)]