local player = game.Players.LocalPlayer

local music = player:WaitForChild'Music'

function update()
	if music.Value then
		script.Parent.Text = "Music ON"
		for _, m in pairs(script.Parent.Parent.Parent.Sounds.MusicTracks:GetChildren()) do
			m.Volume = 0.6
		end
	else
		script.Parent.Text = "Music OFF"
		for _, m in pairs(script.Parent.Parent.Parent.Sounds.MusicTracks:GetChildren()) do
			m.Volume = 0
		end
	end
end

script.Parent.MouseButton1Click:connect(function()
	if music.Value then
		music.Value = false
		update()
	else
		music.Value = true
		update()
	end
end)

update()