local ContextActionService = game:GetService("ContextActionService")

local connections = {}
local gui = nil
local reloading = false
local sprinting = false
local aiming = false
local knifeConnects = nil
local damage = 0

local lastTool = nil

local animator = require(script.Animator)

local viewportSize = workspace.CurrentCamera.ViewportSize
local isSmallScreen = viewportSize.Y <= 480

local function makeConnections(tool)
	local queuedShot = false
	local stopNextShot = false

	local nextShot = tick()
	local player = game.Players.LocalPlayer
	tool.PistolPart.Equip:Play()
	local gunTip = game.Players.LocalPlayer.PlayerGui.ToolTips
	gunTip.Frame:ClearAllChildren()
	if not isSmallScreen then
		local gun = gunTip.GunFrame:Clone()
		gun.Parent = gunTip.Frame
		gun.Visible = true
	end
	gunTip.Frame.Visible = true
	if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Toothpaste") then
		game.Workspace.Events.WeaponOut:FireServer(true)
	end

	animator.equipped(tool)

	local function fire()
		local shootDelay
		if tool.Name == "MP5" then
			shootDelay = 0.08
		elseif tool.Name == "Dragunov" or tool.Name == "Spas-12" then
			shootDelay = 0.6
		else
			shootDelay = 0.125
		end
		nextShot = tick() + shootDelay

		local ray
		if aiming then
			ray = Ray.new(game.Workspace.CurrentCamera.CFrame.p,
				game.Workspace.CurrentCamera.CoordinateFrame.lookVector * 1000)
		else
			ray = Ray.new(game.Workspace.CurrentCamera.CFrame.p,
				(game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(
				(math.random() / 20) - (1/40), (math.random() / 20 - (1/40)), (math.random() / 20) - (1/40)
				)).lookVector * 1000)
		end

		local hit, _ = game.Workspace:FindPartOnRay(ray, game.Players.LocalPlayer.Character)
		game.Workspace.Events.Shoot:FireServer(ray, hit, tool, damage)

		tool:WaitForChild'Ammo'.Value = tool.Ammo.Value - 1
		gui:WaitForChild'Ammo'.Text = tool.Ammo.Value
		tool:WaitForChild'Handle'.Fire:Play()
		tool:WaitForChild'FlashPart'.Flare:Emit(1)
		spawn(function()
			animator.shot()
		end)

		queuedShot = true
	end

	local function reload()
		queuedShot = false
		if not reloading then
			reloading = true
			if aiming then
				animator.stopAim()
				if sprinting then
					animator.startSprint()
				end
				aiming = false
			end
			animator.reloadSequence(gui)
			queuedShot = false
			reloading = false
		end
	end

	local function fireInput()
		if not sprinting and not reloading then
			queuedShot = true
		end
	end

	local function stopFiringInput()
		queuedShot = false
	end
	
	local function fireAction(_, state, input)
		if state == Enum.UserInputState.Begin then
			fireInput()
		else
			stopFiringInput()
		end
	end
	
	local function reloadAction(_, state, input)
		if state == Enum.UserInputState.Begin then
			reload()
		end
	end
	
	local Register = player.PlayerGui:WaitForChild("MobileControls"):WaitForChild("Register")
	ContextActionService:BindAction("Fire", fireAction, true, Enum.KeyCode.Eight)
	ContextActionService:BindAction("Reload", reloadAction, true, Enum.KeyCode.Nine)
	Register:Fire("Fire")
	Register:Fire("Reload")

	connections = {
		heartbeat = game:GetService("RunService").Heartbeat:Connect(function()
			if not player.Character or not player.Character:FindFirstChild'Humanoid' then return end
			if player.Character.Humanoid.Health == 0 then return end
			if tool == nil or tool.Name == "Check Target" then return end

			local canFire = not reloading and not sprinting
				and player.Character.Humanoid.WalkSpeed < 18

			local isReady = tick() > nextShot
			if canFire and isReady and queuedShot then
				if tool.Ammo.Value > 0 then
					fire()
				else
					tool.Handle.Empty:Play()
					reload()
				end
			end

			local ammo = gui:FindFirstChild'Ammo'
			if ammo then
				ammo.Text = tool.Ammo.Value
			end
		end),

		began = game:GetService("UserInputService").InputBegan:connect(function(input, processed)
			if (input.KeyCode == Enum.KeyCode.R and not processed) or input.KeyCode == Enum.KeyCode.ButtonX then
				reload()
			end
			if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
				if game.Players.LocalPlayer.Character.Humanoid.MoveDirection.magnitude > 0.9 then
					animator.startSprint()
					sprinting = true
					stopFiringInput()
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.ButtonL2
				or input.KeyCode == Enum.KeyCode.Q then
				if reloading then return end
				if sprinting then return end
				animator.startAim()
				aiming = true
			end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
				if reloading or sprinting then return end
				fireInput()
			end
		end),
		
		touch = game:GetService("UserInputService").TouchTapInWorld:Connect(function(_, processed)
			if not processed then
				fireInput()
				wait()
				stopFiringInput()
			end
		end),

		ended = game:GetService("UserInputService").InputEnded:connect(function(input)
			if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.ButtonL3 then
				if sprinting then
					animator.stopSprint()
					sprinting = false
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton2 or input.KeyCode == Enum.KeyCode.ButtonL2
				or input.KeyCode == Enum.KeyCode.Q  then
				if reloading then return end
				if aiming then
					animator.stopAim()
					if sprinting then
						animator.startSprint()
					end
					aiming = false
				end
			end
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2 then
				stopFiringInput()
			end
		end)
	}
end

local function charAdded(char)
	pcall(function()
		animator.stop()
	end)
	animator.init(char:WaitForChild'Humanoid')
	game.Players.LocalPlayer.Character.ChildAdded:connect(function(child)
		if child:isA('Tool') and child:FindFirstChild("KnifeScript") then
			if game.Players.LocalPlayer.TeamColor ~= BrickColor.new("Toothpaste") then
				game.Workspace.Events.WeaponOut:FireServer(true)
			end
			knifeConnects = {
				game:GetService("UserInputService").InputBegan:connect(function(input)
					if input.KeyCode == Enum.KeyCode.ButtonR2 or input.UserInputType == "Touch" then
						child:Activate()
					end
				end)
			}
			local gunTip = game.Players.LocalPlayer.PlayerGui.ToolTips
			gunTip.Frame:ClearAllChildren()
			local gun = gunTip.KnifeFrame:Clone()
			gun.Visible = true
			gun.Parent = gunTip.Frame
			gunTip.Frame.Visible = true
		end
		if child:isA('Tool') and child.Name == "M1911"
			or child.Name == "Luger"
			or child.Name == "Dragunov"
			or child.Name == "Mauser"
			or child.Name == "Six Shooter"
			or child.Name == "Spas-12"
			or child.Name == "MAC10"
			or child.Name == "Hand Cannon"
			or child.Name == "MP5" then
			lastTool = child
			damage = lastTool:WaitForChild'Damage'.Value
			gui = game.ReplicatedStorage.GunGuis.BillboardGui:Clone()
			gui.Parent = game.Players.LocalPlayer.PlayerGui
			gui.Adornee = lastTool:WaitForChild'PistolPart'
			gui:WaitForChild'Ammo'.Text = lastTool:WaitForChild'Ammo'.Value
			makeConnections(lastTool)
		elseif child:isA('Tool') and child.Name == "Check Target" then
			animator.equipped(child)
			child.PistolPart.Equip:Play()
		end
	end)

	game.Players.LocalPlayer.Character.DescendantRemoving:connect(function(child)
		firing = false
		if child:isA('Tool') and child:FindFirstChild("KnifeScript") then
			game.Workspace.Events.WeaponOut:FireServer(false)
			if knifeConnects then
				for _, conn in pairs(knifeConnects) do
					conn:disconnect()
				end
				knifeConnects = nil
				local gunTip = game.Players.LocalPlayer.PlayerGui.ToolTips
				gunTip.Frame:ClearAllChildren()
				gunTip.Frame.Visible = false
			end
		end

		if child == lastTool then
			animator.unequipped(lastTool)
			for _, item in pairs(game.Players.LocalPlayer.PlayerGui:getChildren()) do
				if (item:FindFirstChild("Ammo") ~= nil) then
					item:Destroy()
				end
			end
			game.Workspace.Events.WeaponOut:FireServer(false)
			damage = 0
			reloading = false
			sprinting = false
			aiming = false
			firing = false
			if gui then
				gui:Destroy()
			end
			for _, c in pairs(connections) do
				c:disconnect()
			end
			ContextActionService:UnbindAction("Fire")
			ContextActionService:UnbindAction("Reload")
			connections = {}
			local gunTip = game.Players.LocalPlayer.PlayerGui.ToolTips
			gunTip.Frame:ClearAllChildren()
			gunTip.Frame.Visible = false
		elseif child.Name == "Check Target" then
			animator.unequipped(child)
		end
	end)

	game.Players.LocalPlayer.Character:WaitForChild'Humanoid'
	game.Players.LocalPlayer.Character.Humanoid.Died:connect(function()
		firing = false
		animator.stop()
		if lastTool then
			animator.unequipped(lastTool)
		end
		local dead = game.ReplicatedStorage.Dead:Clone()
		dead.Parent = game.Players.LocalPlayer.PlayerGui
		dead:WaitForChild'Sound':Play()
		game.Lighting.Blur.Enabled = true
		game.Lighting.DeadColors.Enabled = true
		game.Workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		damage = 0
		game.Players.LocalPlayer.Character.Humanoid:UnequipTools()
		reloading = false
		firing = false
		sprinting = false
		aiming = false
		gui:Destroy()
		for _, c in pairs(connections) do
			c:disconnect()
		end
		ContextActionService:UnbindAction("Fire")
		ContextActionService:UnbindAction("Reload")
		connections = {}
		local gunTip = game.Players.LocalPlayer.PlayerGui.ToolTips
		gunTip.Frame:ClearAllChildren()
		gunTip.Frame.Visible = false
	end)
end

game.Players.LocalPlayer.CharacterAdded:connect(charAdded)

if game.Players.LocalPlayer.Character then
	charAdded(game.Players.LocalPlayer.Character)
end