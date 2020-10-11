game:GetService("RunService").RenderStepped:connect(function()
	local num = #game.Teams.Framed:GetPlayers() + #game.Teams.Police:GetPlayers()
	script.Parent.Text = num .. " | ALIVE "
end)