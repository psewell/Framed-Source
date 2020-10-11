local module = {}

module.new = function(player)
	player.Character.Humanoid.MaxHealth = 200
	player.Character.Humanoid.Health = 200
end

return module
