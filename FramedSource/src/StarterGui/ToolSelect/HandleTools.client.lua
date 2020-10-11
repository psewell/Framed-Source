game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

script.Parent.Selected.Visible = false
local player = game.Players.LocalPlayer

local myPack = game.Workspace:WaitForChild'Events':WaitForChild'GetPack':InvokeServer()

local items = player.Backpack:GetChildren()

local equipped = 1
local isEquipped = false

function unequipTools()
	isEquipped = false
	player.Character.Humanoid:UnequipTools()
end

function selTool(num)
	for _, t in pairs(script.Parent.Tools:getChildren()) do
		t.Style = 'DropShadow'
	end
	pcall(function()
		script.Parent.Tools[num].Style = 'RobloxRound'
	end)
end

function selNone()
	for _, t in pairs(script.Parent.Tools:getChildren()) do
		t.Style = 'DropShadow'
	end
end

function updateItems()
	script.Parent.Tools:ClearAllChildren()
	local x
	local lx
	local rx
	for i, item in pairs(items) do
		if #items % 2 == 0 then
			local cutoff = (#items) / 2
			x = -100 + ((i - cutoff) * 105)
		else
			local cutoff = (#items + 1) / 2
			x = -50 + ((i - cutoff) * 105)
		end
		local t = script.Parent.Tool:Clone()
		t.Parent = script.Parent.Tools
		t.Position = UDim2.new(0.5, x, 1, -100)
		t.Visible = true
		t.TextLabel.Text = item.Name
		t.Name = i
		t.ImageButton.TouchTap:connect(function()
			if isEquipped == item then
				unequipTools()
			else
				equipTool(item)
			end
		end)
	end
end

function equipTool(tool)
	isEquipped = tool
	player.Character.Humanoid:EquipTool(tool)
	game.Workspace.Events.ToolEquipped:Fire(tool)
end

player.Backpack.ChildAdded:connect(function(ch)
	for _, item in pairs(items) do
		if item == ch then
			return
		end
	end
	table.insert(items, ch)
	updateItems()
end)

player.Backpack.ChildRemoved:connect(function(ch)
	if ch.Parent ~= player.Character then
		for i, item in pairs(items) do
			if item == ch then
				table.remove(items, i)
				updateItems()
				unequipTools()
				equipped = 1
				return
			end
		end
	end
end)

function handleWhoops()
	unequipTools()
end

game:GetService("UserInputService").InputBegan:connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.ButtonR1 or input.KeyCode == Enum.KeyCode.ButtonL1 then
		handleWhoops()
	end	
	if input.KeyCode == Enum.KeyCode.ButtonB then
		unequipTools()
		selNone()
	end
	if input.KeyCode == Enum.KeyCode.ButtonY then
		unequipTools()
		wait()
		equipTool(items[equipped])
		selTool(equipped)
	end
	if input.KeyCode == Enum.KeyCode.E and not processed then
		unequipTools()
		wait()
		equipTool(items[1])
		selTool(1)
	end
	if input.KeyCode == Enum.KeyCode.ButtonR1 then
		if equipped + 1 <= #items then
			equipped = equipped + 1
		else
			equipped = 1
		end
	end
	if input.KeyCode == Enum.KeyCode.ButtonL1 then
		if equipped - 1 >= 1 then
			equipped = equipped - 1
		else
			equipped = #items
		end
	end
	if (tonumber(input.KeyCode.Value) - 49 < #items
		and tonumber(input.KeyCode.Value - 48) > 0) then
		if equipped == input.KeyCode.Value - 48 then
			unequipTools()
			selNone()
			equipped = 0
		else
			equipped = input.KeyCode.Value - 48
			unequipTools()
			wait()
			equipTool(items[equipped])
			selTool(equipped)
		end
	end
end)

game:GetService("UserInputService").InputEnded:connect(function(input, processed)
	if input.KeyCode == Enum.KeyCode.E and not processed then
		unequipTools()
		selNone()
	end
end)

updateItems()

while true do
	game:GetService("RunService").RenderStepped:wait()
	if not game:GetService("UserInputService").GamepadEnabled then
		script.Parent.Selected.Visible = false
		script.Parent.Left.Visible = false
		script.Parent.Right.Visible = false
	else
		if #items > 0 then
			script.Parent.Selected.Visible = true
			script.Parent.Left.Visible = true
			script.Parent.Right.Visible = true
		else
			script.Parent.Selected.Visible = false
			script.Parent.Left.Visible = false
			script.Parent.Right.Visible = false
		end
	end
	if #items % 2 == 0 then
		local cutoff = (#items) / 2
		x = -100 + ((equipped - cutoff) * 105)
		lx = -25 + ((cutoff + 0.5) * 105)
		rx = -25 - ((cutoff + 0.5) * 105)
	else
		local cutoff = (#items + 1) / 2
		x = -50 + ((equipped - cutoff) * 105)
		lx = -25 + (cutoff * 105)
		rx = -25 - (cutoff * 105)
	end
	script.Parent.Right.Position = UDim2.new(0.5, rx, 1, -100)
	script.Parent.Left.Position = UDim2.new(0.5, lx, 1, -100)
	script.Parent.Selected.Position = UDim2.new(0.5, x, 1, -100)
end