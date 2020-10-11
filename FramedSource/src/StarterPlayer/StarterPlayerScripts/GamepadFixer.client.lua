game:GetService("RunService").Heartbeat:connect(function()
	if game:GetService("UserInputService").GamepadEnabled then
		game:GetService("UserInputService").MouseIconEnabled = false
	end
end)