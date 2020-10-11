function onTouch(part)
local humanoid = part.Parent:FindFirstChild("Humanoid")
if (humanoid ~=nil) then -- If a person or humanoid touches
humanoid.Health = 0 --Damage Done
end
end

script.Parent.Touched:connect(onTouch)

