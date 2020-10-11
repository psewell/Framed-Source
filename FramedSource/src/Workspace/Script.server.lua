function search(model)
	for _, part in pairs(model:GetChildren()) do
		if part.Name == "WineTop" or part.Name == "WineTopBottom" then
			part.BrickColor = BrickColor.new("Bright bluish green")
		end
		if part:IsA("Model") then
			search(part)
		end
	end
end

for _, mdl in pairs(game.Workspace.LobbyArea:GetChildren()) do
	search(mdl)
end