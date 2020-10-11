local canSend = true
local player = game.Players.LocalPlayer

function sendEvent(escape)
	canSend = false
	if game.Workspace.Values.GameMode.Value == "Ending" then return end
	game.Workspace.Events.TouchEvent:FireServer()
	wait(10)
	canSend = true
end

game.Workspace:WaitForChild'Events':WaitForChild'Contracts':WaitForChild'RemoteTaskFulfilled'.OnClientEvent:connect(function(task)
	local case = game.ReplicatedStorage.Case:Clone()
	local map = game.Workspace.Values.Map.Value
	case.Parent = game.Workspace.CurrentCamera
	case.CFrame = (map["Spawn" .. math.random(1, 15)].TP.CFrame)
	case.Touched:connect(function(hit)
		if hit:IsDescendantOf(player.Character) then
			game.Workspace.Events.Contracts.RemoteTaskFulfilled:FireServer()
			case:Destroy()
		end
	end)
end)

game.Workspace:WaitForChild'Events':WaitForChild'Epilogue'.OnClientEvent:connect(function(isOnTheRun)
	if game.Workspace.CurrentCamera:FindFirstChild("Escape") then
		return
	end
	local escape = game.ReplicatedStorage.Escape:Clone()
	local map = game.Workspace.Values.Map.Value
	if isOnTheRun == nil then
		escape:SetPrimaryPartCFrame(map["Spawn" .. math.random(1, 15)].TP.CFrame - Vector3.new(0, 2, 0))
		game.Debris:AddItem(escape, 46)
	else
		escape:SetPrimaryPartCFrame(map["EscapeLocation"].CFrame)
		game.Debris:AddItem(escape, 250)
	end
	escape.Parent = game.Workspace.CurrentCamera
	escape.Union.Touched:connect(function(hit)
		for i = 1, 10 do
			if escape then
				escape:Destroy()
				escape = nil
			end
		end
		if hit:IsDescendantOf(game.Players.LocalPlayer.Character) 
			and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			and canSend then
			sendEvent(escape)
		end
	end)
	escape.Union1.Touched:connect(function(hit)
		for i = 1, 10 do
			if escape then
				escape:Destroy()
				escape = nil
			end
		end
		if hit:IsDescendantOf(game.Players.LocalPlayer.Character) 
			and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			and canSend then
			sendEvent(escape)
		end
	end)
	if isOnTheRun == nil then
		local gui = game.Players.LocalPlayer.PlayerGui.Epilogue.ifFramed
		gui.Visible = true
		gui:TweenPosition(UDim2.new(0, 0, 0, -50), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5)
	end
	while true do
		escape.Union.CFrame = escape.Union.CFrame * CFrame.Angles(0, -0.1, 0)
		escape.Union1.CFrame = escape.Union1.CFrame * CFrame.Angles(0, 0.1, 0)
		wait(0)
	end
end)