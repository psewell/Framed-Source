game.Workspace.Events.OpensMap.OnClientEvent:connect(function(m1, m2, m3, n1, n2, n3, gm1, gm2, gm3, delay)
	game.Lighting.Blur.Enabled = true	
	local endTime = tick() + delay	
	local mV = script.Parent.Frame:Clone()
	main = mV.Frame
	mV.Visible = true
	main.Pic1.Image = m1
	main.Pic2.Image = m2
	main.Pic3.Image = m3
	main.Pic1.Name1.Text = n1
	main.Pic2.Name2.Text = n2
	main.Pic3.Name3.Text = n3
	main.Pic1.gm1.Text = gm1
	main.Pic2.gm2.Text = gm2
	main.Pic3.gm3.Text = gm3
	mV.Parent = script.Parent
	main.Pic1.MouseButton1Click:connect(function()
		game.Workspace.Events.Vote:FireServer('map1')
	end)
	main.Pic2.MouseButton1Click:connect(function()
		game.Workspace.Events.Vote:FireServer('map2')
	end)
	main.Pic3.MouseButton1Click:connect(function()
		game.Workspace.Events.Vote:FireServer('map3')
	end)
	game.Workspace.Events.Vote.OnClientEvent:connect(function(v1, v2, v3)
		script.Parent.Parent.Sounds.PageTurn:Play()
		main.Pic1.V1.Text = v1
		main.Pic2.V2.Text = v2
		main.Pic3.V3.Text = v3
	end)
	if game:GetService("UserInputService").GamepadEnabled then
		game.GuiService.SelectedObject = main.Pic1
	end
	repeat wait() until tick() > endTime
	mV:Destroy()
	game.Lighting.Blur.Enabled = false
end)
