-- Waits for the child of the specified parent
local function WaitForChild(parent, childName)
	while not parent:FindFirstChild(childName) do parent.ChildAdded:wait() end
	return parent[childName]
end


local Tool = script.Parent
local Handle = WaitForChild(Tool, 'Handle')
local Debounce = false

local TouchConnection


function OnTouched(hit)
	local humanoid = hit.Parent:findFirstChild('Humanoid')
	if Debounce == false then
		Debounce = true
		if humanoid then
			Handle.Splat:Play()
		else
			Handle.Ting:Play()
		end
	end
	wait(0.5)
	Debounce = false
end


Tool.Equipped:connect(function()
	TouchConnection = Handle.Touched:connect(OnTouched)
end)

Tool.Unequipped:connect(function()
	if TouchConnection then
		TouchConnection:disconnect()
		TouchConnection = nil
	end
end)
