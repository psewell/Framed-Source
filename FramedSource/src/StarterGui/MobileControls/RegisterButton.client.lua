local ContextActionService = game:GetService("ContextActionService")

local registerFuncs = {
	Sprint = function(button)
		button.AnchorPoint = Vector2.new(1, 1)
		button.Size = UDim2.new(0.3, 0, 0.3, 0)
		button.Position = UDim2.new(0.9, 0, 0.5, 0)
		button.SizeConstraint = Enum.SizeConstraint.RelativeYY
		button.ActionTitle.Text = "Sprint"
	end,
	
	Fire = function(button)
		button.AnchorPoint = Vector2.new(1, 1)
		button.Size = UDim2.new(0.3, 0, 0.3, 0)
		button.Position = UDim2.new(0.52, 0, 0.6, 0)
		button.SizeConstraint = Enum.SizeConstraint.RelativeYY
		button.ActionTitle.Text = "Fire"
	end,
	
	Reload = function(button)
		button.AnchorPoint = Vector2.new(1, 1)
		button.Size = UDim2.new(0.3, 0, 0.3, 0)
		button.Position = UDim2.new(0.42, 0, 0.9, 0)
		button.SizeConstraint = Enum.SizeConstraint.RelativeYY
		button.ActionTitle.Text = "Reload"
	end,
}

local function register(actionName)
	local button = ContextActionService:GetButton(actionName)
	if button then
		registerFuncs[actionName](button)
	end
end

script.Parent:WaitForChild("Register").Event:Connect(register)
