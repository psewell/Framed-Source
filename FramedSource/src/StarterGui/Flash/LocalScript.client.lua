game.Workspace:WaitForChild'Events':WaitForChild'Flash'.OnClientEvent:connect(function()
	game:GetService("SoundService").RolloffScale = 1000
	script.Parent.Deaf.Volume = 0.1
	script.Parent.Deaf:Play()
	script.Parent.Frame.Visible = true
	script.Parent.Frame.BackgroundTransparency = 0	
	wait(2)
	for i = 1, 0, -0.01 do
		wait(0)
		script.Parent.Frame.BackgroundTransparency =  1 - i
		script.Parent.Deaf.Volume = 0.1 * i
	end
	script.Parent.Frame.Visible = false
	game:GetService("SoundService").RolloffScale = 1
	script.Parent.Deaf:Stop()
end)