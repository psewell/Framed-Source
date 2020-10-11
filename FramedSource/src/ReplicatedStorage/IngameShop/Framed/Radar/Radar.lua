local module = {}

module.new = function(player)
	local target = game.Workspace.Events.GetTarget:Invoke(player)
	game.Workspace.Events.MarkPlayer:FireClient(player, target)
end

return module
