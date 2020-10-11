player = game.Players.LocalPlayer

local CollectionService = game:GetService("CollectionService")

local viewportSize = workspace.CurrentCamera.ViewportSize
local smallScreen = viewportSize.Y <= 480

function loaded()
	_G.useSpeedLimits = false
	print("Character loaded.")
	game.Lighting.Blur.Enabled = false
	game.Lighting.DeadColors.Enabled = false
	local guis = game:GetService'GuiService'
	guis.AutoSelectGuiEnabled = true
	guis.GuiNavigationEnabled = true
	player.Character:WaitForChild'Humanoid'.JumpPower = 30
	if player.TeamColor == BrickColor.new("Fossil") then
		player.PlayerGui:WaitForChild'Points'.Enabled = false
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, true)
		script.Parent:WaitForChild'Sensitivity'.Value = 1
		player.CameraMaxZoomDistance = 60
		player.NameDisplayDistance = 60
		player.CameraMode = Enum.CameraMode.Classic
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		game:GetService("UserInputService").MouseIconEnabled = true
		if game.Workspace.Values.GameMode.Value ~= "Ending" then
			for _, sound in pairs(game.Players.LocalPlayer.PlayerGui.Sounds.MusicTracks:GetChildren()) do
				sound:Stop()
			end
			local music = player.PlayerGui.Sounds.MusicTracks:GetChildren()
			music[math.random(1, #music)]:Play()
		end
		if game:GetService("UserInputService").GamepadEnabled then
			player.PlayerGui.ToolTips.ControlFrame.Visible = true
		end
		player.Character:WaitForChild'Humanoid'.Changed:connect(function()
			if player.TeamColor == BrickColor.new("Fossil") then
				player.Character.Humanoid.Health = 100
			end
		end)
	else
		game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.PlayerList, false)
		player.Character:WaitForChild'Humanoid'.WalkSpeed = 14
		player.CameraMaxZoomDistance = 0
		player.NameDisplayDistance = 0
		player.CameraMode = Enum.CameraMode.LockFirstPerson
		player.Character:WaitForChild'Humanoid'.NameDisplayDistance = 0
		if not smallScreen then
			player.PlayerGui.ToolTips.ShopFrame.Visible = true
		end
		player.PlayerGui:WaitForChild'Points'.Enabled = true
		player.PlayerGui.Points.Points.Text = "Points: 0 "
		local c = player.PlayerGui:WaitForChild'Countdown'
		c:WaitForChild'RedBar'.Visible = false
		c:WaitForChild'Outgame'.Visible = false
		c:WaitForChild'Ingame'.Visible = true
		c:WaitForChild'MusicController'.Visible = false
		player.PlayerGui.ToolSelect.Outgame.Visible = true
	end
	game.Workspace.CurrentCamera.FieldOfView = 70
	player.PlayerGui.Sounds.DescendantRemoving:connect(function(ch)
		if ch:IsA("Sound") then
			ch:Stop()
		end
	end)
end

player.CharacterAdded:connect(loaded)

if player.Character then
	loaded()
end

player:WaitForChild'leaderstats':WaitForChild'Points'.Changed:connect(function(val)
	player.PlayerGui:WaitForChild'Points'.Points.Text = "Points: " .. val .. " "
end)