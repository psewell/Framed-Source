game.Workspace:WaitForChild'Events':WaitForChild'MapLoading'.OnClientEvent:connect(function(name, childnum, gameMode, image)
	local intro = script.Parent.Countdown.GameIntro
	intro.Visible = true
	intro:TweenPosition(
		UDim2.new(0, 0, 0, 0),
		Enum.EasingDirection.Out,
		Enum.EasingStyle.Quad,
		0.7
	)
	intro.LoadingBar.Bar.mapImage.Image = image
	intro.LoadingBar.mapImage.Image = image
	repeat wait() until game.Workspace:FindFirstChild(name)
	repeat
		game:GetService("RunService").RenderStepped:wait()
		local num = #game.Workspace[name]:GetChildren()
		intro.LoadingBar.Bar.Size = UDim2.new(num / childnum, 0, 1, 0)
	until num >= childnum
end)