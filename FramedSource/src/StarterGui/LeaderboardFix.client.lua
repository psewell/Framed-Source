while true do
	if game:GetService("UserInputService").GamepadEnabled then
		game.Workspace.LobbyArea.LeaderboardFrame:Destroy()
		game.Workspace.LobbyArea.Next5ScoreBoard:Destroy()
		game.Workspace.LobbyArea.Top5ScoreBoard:Destroy()
	end
	wait(5)
end
