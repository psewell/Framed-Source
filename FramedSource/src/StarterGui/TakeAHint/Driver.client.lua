local screens = {}

for _, box in pairs(game.Workspace.LobbyArea.Lobby.HowToPlay:GetChildren()) do
	if box.Name == "Part" then
		if box:FindFirstChild'SurfaceGui' then
			table.insert(screens, box)
		end
	end
end

player = game.Players.LocalPlayer
repeat wait() until player.Character
torso = player.Character:WaitForChild'Torso'
while true do
	wait(0)
	local found = false
	for _, box in pairs(screens) do
		if (box.CFrame.p - torso.CFrame.p).magnitude < 10 then
			found = true
			script.Parent.Frame.Visible = true
			script.Parent.Frame.TextLabel.Text = box.SurfaceGui.TextLabel.Text
			break
		end
	end
	if not found then
		script.Parent.Frame.Visible = false
	end
end