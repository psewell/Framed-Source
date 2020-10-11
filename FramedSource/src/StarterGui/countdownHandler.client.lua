local g_endTime = tick()
local g_text = ""

game.Workspace:WaitForChild("Events"):WaitForChild'LocalTextMod'.OnClientEvent:connect(function(text, delay)
	g_endTime = tick() + delay
	script.Parent:WaitForChild'Countdown':WaitForChild'RMod'.Text = text
	g_text = text
end)

game.Players.LocalPlayer.CharacterAdded:connect(function()
	if game.Players.LocalPlayer.TeamColor == BrickColor.new("Fossil") then
		g_text = script.Parent.Countdown.RMod.Text
		local delay = game.Workspace.Events.GetCountdown:InvokeServer()
		g_endTime = tick() + delay
	end
end)

game:GetService("RunService").Heartbeat:connect(function()
	if script.Parent:FindFirstChild("Countdown") == nil then
		return
	end
	if script.Parent.Countdown.RMod.Text == "Game Ended" then
		script.Parent.Countdown.TLeft.Text = ""
		return
	end
	if tick() < g_endTime and script.Parent.Countdown.RMod.Text == g_text then
		local val = math.max(0, math.floor(g_endTime - tick()))
		if val == 0 then
			script.Parent.Countdown.TLeft.Text = ""
		else
			script.Parent.Countdown.TLeft.Text = val
		end
	end
end)