player = game.Players.LocalPlayer
sprinting = false

wait(0.5)

function changeSprint()
	if player.Character == nil then return end
	local char = player.Character
	if player.TeamColor ~= BrickColor.new("Fossil") then
		if char:FindFirstChild("Head") then
			if sprinting then
				char.Humanoid.WalkSpeed = 18
			else
				char.Humanoid.WalkSpeed = 14
			end
		end
	end
end

game:GetService("UserInputService").InputBegan:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
		sprinting = true
		changeSprint()
	end
end)

game:GetService("UserInputService").InputEnded:connect(function(input)
	if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
		sprinting = false
		changeSprint()
	end
end)

function sprintFunc(name, state, input)
	if state == Enum.UserInputState.Begin then
		sprinting = true
		changeSprint()
	else
		sprinting = false
		changeSprint()
	end
end

if player.Team ~= game.Teams.Lobby then
	game:GetService("ContextActionService"):BindAction("Sprint", sprintFunc, true, Enum.KeyCode.Help)
	player.PlayerGui:WaitForChild("MobileControls"):WaitForChild("Register"):Fire("Sprint")
else
	game:GetService("ContextActionService"):UnbindAction("Sprint")
end
