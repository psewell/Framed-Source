-- Waits for the child of the specified parent
local function WaitForChild(parent, childName)
	while not parent:FindFirstChild(childName) do parent.ChildAdded:wait() end
	return parent[childName]
end

local Tool = script.Parent

local downStabAnim
local stabPunchAnim
local throwAnim
local throwChargeAnim

local MyHumanoid

-- This table will make sure that when we stop an animation it is
-- because it is the only animation of it running
local PlayCountTable = {}


local function PlayAnimation(animation, valueToCheck, animationLength)
	if valueToCheck and valueToCheck.Value then
		if MyHumanoid then
			animation:Play()
			if PlayCountTable[animation] then
				PlayCountTable[animation] = PlayCountTable[animation] + 1
			end
			-- wait the duration of the animation	
			if animationLength then
				wait(animationLength)
				if PlayCountTable[animation] then
					PlayCountTable[animation] = PlayCountTable[animation] - 1
					if PlayCountTable[animation] == 0 then
						animation:Stop()
					end
				end
			end
		end
	end
end

function OnEquipped()
	MyHumanoid = Tool.Parent:FindFirstChild('Humanoid')
	downStabAnim = MyHumanoid:LoadAnimation(WaitForChild(Tool, 'DownStab'))
	PlayCountTable[downStabAnim] = 0
	stabPunchAnim = MyHumanoid:LoadAnimation(WaitForChild(Tool, 'StabPunch'))
	PlayCountTable[stabPunchAnim] = 0
	throwAnim = MyHumanoid:LoadAnimation(WaitForChild(Tool, 'Throw'))
	PlayCountTable[throwAnim] = 0
	throwChargeAnim = MyHumanoid:LoadAnimation(WaitForChild(Tool, 'ThrowCharge'))
	PlayCountTable[throwChargeAnim] = 0
	

	local playStabPunch = WaitForChild(Tool, 'PlayStabPunch')
	local playDownStab = WaitForChild(Tool, 'PlayDownStab')
	local playThrow = WaitForChild(Tool, 'PlayThrow')
	local playThrowCharge = WaitForChild(Tool, 'PlayThrowCharge')

	playStabPunch.Changed:connect(function() PlayAnimation(stabPunchAnim, playStabPunch, 1.0) end)
	playDownStab.Changed:connect(function() PlayAnimation(downStabAnim, playDownStab, 1.0) end)
	playThrow.Changed:connect(function() PlayAnimation(throwAnim, playThrow, 1.5) end)
	playThrowCharge.Changed:connect(function(value)
		if value then
			PlayAnimation(throwChargeAnim, playThrowCharge, 1.0)
		else
			throwChargeAnim:Stop()
		end
	end)
end

function OnUnequipped()
	if downStabAnim then
		downStabAnim:Stop()
		downStabAnim = nil
	end
	if stabPunchAnim then
		stabPunchAnim:Stop()
		stabPunchAnim = nil
	end
	if throwAnim then
		throwAnim:Stop()
		throwAnim = nil
	end
	if throwChargeAnim then
		throwChargeAnim:Stop()
		throwChargeAnim = nil
	end
	PlayCountTable = {}
end

Tool.Equipped:connect(OnEquipped)
Tool.Unequipped:connect(OnUnequipped)

