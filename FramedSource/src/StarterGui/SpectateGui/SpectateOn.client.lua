local player = game.Players.LocalPlayer
local conn = nil
local i
local players

function init()
	script.Parent.Main.Visible = true
	script.Parent.Main.Toggle.Toggles.MouseButton1Click:connect(toggle)
	toggle()
end

function switchPlayer(plr)
	game.Workspace.CurrentCamera.CameraSubject = plr.Character.Humanoid
	player.CameraMaxZoomDistance = 8
	script.Parent.Main.Player.PlayerImage.Image = "http://www.roblox.com/Thumbs/Avatar.ashx?x=200&y=200&Format=Png&username=" .. plr.Name
	script.Parent.Main.Player.PlayerName.Text = "Spectating " .. plr.Name
	if conn ~= nil then
		conn:Disconnect()
		conn = nil
	end
	conn = plr.Character.Humanoid.Died:connect(function()
		repeat	
			i = i - 1
			if i <= 0 then
				i = #players
			end
			wait()
		until players[i].TeamColor ~= BrickColor.new("Fossil")
		switchPlayer(players[i])
	end)
end

function toggle()
	if script.Parent.Main.Player.Visible then
		script.Parent.Main.Player.Visible = false
		script.Parent.Main.Toggle.IsSpectating.Text = "You are currently not spectating."
		game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
		player.CameraMaxZoomDistance = 60
		if conn ~= nil then
			conn:Disconnect()
			conn = nil
		end
	else
		player.CameraMaxZoomDistance = 8
		player.CameraMinZoomDistance = 8
		script.Parent.Main.Player.Visible = true
		script.Parent.Main.Toggle.IsSpectating.Text = "You are currently spectating."
		players = {}
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.TeamColor ~= BrickColor.new("Fossil") then
				table.insert(players, p)
			end
		end
		i = 1
		switchPlayer(players[i])
		script.Parent.Main.Player.Left.MouseButton1Click:connect(function()
			repeat			
				i = i - 1
				if i <= 0 then
					i = #players
				end
				wait()
			until players[i].TeamColor ~= BrickColor.new("Fossil")
			switchPlayer(players[i])
		end)
		script.Parent.Main.Player.Right.MouseButton1Click:connect(function()
			repeat				
				i = i + 1	
				if i > #players then
					i = 1
				end
				wait()
			until players[i].TeamColor ~= BrickColor.new("Fossil")
			switchPlayer(players[i])
		end)
		wait()
		player.CameraMaxZoomDistance = 8
		player.CameraMinZoomDistance = 8
	end
end

if game.Workspace.Values.GameMode.Value ~= "Ending" then
	if player.TeamColor == BrickColor.new("Fossil") then
		local ready = false
		for _, p in pairs(game.Players:GetPlayers()) do
			if p.TeamColor ~= BrickColor.new("Fossil") then
				ready = true
				break
			end
		end
		if ready then
			init()
		end
	end
end