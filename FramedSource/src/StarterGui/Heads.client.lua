repeat wait() until game.Players.LocalPlayer.Character ~= nil
local char = game.Players.LocalPlayer.Character
local cam = game.Workspace.CurrentCamera

sendInfo = function(neckangle)
	game.Workspace.Events.Characters.SetOffsets:InvokeServer(neckangle)
end

getInfo = function(player, neckangle)
	if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Fossil") then
		player.Character.Torso.Neck.C1 = neckangle
	end
end

game.Workspace.Events.Characters.SetOffsets.OnClientInvoke = function(player, neckangle)
	if player ~= game.Players.LocalPlayer then
		getInfo(player, neckangle)
	end
end

spawn(function()
	while true do
		wait(0.1)
		if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Fossil") then
			sendInfo(char:WaitForChild'Torso':WaitForChild'Neck'.C1)
		end
	end
end)

game:GetService("RunService").RenderStepped:connect(function()
	if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Fossil") then
		char.Torso.Neck.C1 = CFrame.new(0, -0.5, 0) * CFrame.Angles(-cam.CFrame.lookVector.Y, 0, 0) * CFrame.Angles(0, math.pi, 0)
			* CFrame.Angles(-math.pi/2, 0, 0)
	end
end)