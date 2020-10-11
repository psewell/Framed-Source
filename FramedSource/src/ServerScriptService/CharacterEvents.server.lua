game.Workspace.Events.Characters.SetOffsets.OnServerInvoke = function(player, neckangle)
	for _, p in pairs(game.Players:GetPlayers()) do
		if p ~= player then
			game.Workspace.Events.Characters.SetOffsets:InvokeClient(p, player, neckangle)
		end
	end
end