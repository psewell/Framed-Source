--------------------- TEMPLATE BLADE WEAPON ---------------------------
-- Waits for the child of the specified parent
local function WaitForChild(parent, childName)
	while not parent:FindFirstChild(childName) do parent.ChildAdded:wait() end
	return parent[childName]
end


local SLASH_DAMAGE = 110
local DOWNSTAB_DAMAGE = 110
local THROWING_DAMAGE = 110
local HOLD_TO_THROW_TIME = 1


local Damage = 250

local MyHumanoid = nil
local MyTorso = nil
local MyCharacter = nil
local MyPlayer = nil

local Tool = script.Parent
local Handle = WaitForChild(Tool, 'Handle')

local BlowConnection
local Button1DownConnection
local Button1UpConnection

local PlayStabPunch
local PlayDownStab
local PlayThrow
local PlayThrowCharge

local IconUrl = Tool.TextureId  -- URL to the weapon knife icon asset

local DebrisService = Game:GetService('Debris')
local PlayersService = Game:GetService('Players')

local SlashSound

local HitPlayers = {}

local LeftButtonDownTime = nil

local Attacking = false

local Activeconnect = nil
local Deactiveconnect = nil

function Blow(hit)
	if Attacking then
		BlowDamage(hit, Damage)
	end
end

function BlowDamage(hit, damage)
	local humanoid = hit.Parent:FindFirstChild('Humanoid')
	local player = PlayersService:GetPlayerFromCharacter(hit.Parent)
	if humanoid ~= nil and MyHumanoid ~= nil and humanoid ~= MyHumanoid then
		-- final check, make sure weapon is in-hand
		local rightArm = MyCharacter:FindFirstChild('Right Arm')
		if (rightArm ~= nil) then
			-- Check if the weld exists between the hand and the weapon
			local joint = rightArm:FindFirstChild('RightGrip')
			if (joint ~= nil and (joint.Part0 == Handle or joint.Part1 == Handle)) then
				-- Make sure you only hit them once per swing
				if player and not HitPlayers[player] then
					game.Workspace.Events.Shoot:FireServer(nil, player.Character.Humanoid, script.Parent, 100)
					Handle.Splat.Volume = 1
					HitPlayers[player] = true
				end
			end
		end
	end
end

function HardAttack()
	Damage = SLASH_DAMAGE
	SlashSound:play()
	if PlayStabPunch then
		PlayStabPunch.Value = true
		wait(1.0)
		PlayStabPunch.Value = false
	end
end

function NormalAttack()
	Damage = DOWNSTAB_DAMAGE
	KnifeDown()
	SlashSound:play()
	if PlayDownStab then
		PlayDownStab.Value = true
		wait(1.0)
		PlayDownStab.Value = false
	end
	KnifeUp()
end

function ThrowAttack()
	return
end

function KnifeUp()
	Tool.GripForward = Vector3.new(-1,0,0)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(0,0,1)
end

function KnifeDown()
	Tool.GripForward = Vector3.new(-1,0,0)
	Tool.GripRight = Vector3.new(0,1,0)
	Tool.GripUp = Vector3.new(0,0,-1)
end

function KnifeOut()
	Tool.GripForward = Vector3.new(0,0,1)
	Tool.GripRight = Vector3.new(0,-1,0)
	Tool.GripUp = Vector3.new(-1,0,0)
end

Tool.Enabled = true

function OnLeftButtonDown()
	LeftButtonDownTime = time()
end

function OnLeftButtonUp()
	if not Tool.Enabled then return end
	-- Reset the list of hit players every time we start a new attack
	HitPlayers = {}
	if PlayThrowCharge then
		PlayThrowCharge.Value = false
	end
	if Tool.Enabled and MyHumanoid and MyHumanoid.Health > 0 then
		Tool.Enabled = false
		local currTime = time()
		if LeftButtonDownTime and currTime - LeftButtonDownTime > HOLD_TO_THROW_TIME and
			currTime - LeftButtonDownTime < 1.15 then
			ThrowAttack()
		else
			Attacking = true
			HardAttack()
			Attacking = false
		end
		Tool.Enabled = true
	end
end

function OnEquipped(mouse)
	PlayStabPunch = WaitForChild(Tool, 'PlayStabPunch')
	PlayDownStab = WaitForChild(Tool, 'PlayDownStab')
	PlayThrow = WaitForChild(Tool, 'PlayThrow')
	PlayThrowCharge = WaitForChild(Tool, 'PlayThrowCharge')
 	SlashSound = WaitForChild(Handle, 'Swoosh1')
	Handle.Splat.Volume = 0
	SlashSound:play()
	BlowConnection = Handle.Touched:connect(Blow)
	MyCharacter = Tool.Parent
	MyTorso = MyCharacter:FindFirstChild('Torso')
	MyHumanoid = MyCharacter:FindFirstChild('Humanoid')
	MyPlayer = PlayersService.LocalPlayer
	if mouse then
		Button1DownConnection = script.Parent.Activated:connect(OnLeftButtonUp)
	end
	KnifeUp()
end

function OnUnequipped()
	-- Unequip logic here
	if BlowConnection then
		BlowConnection:disconnect()
		BlowConnection = nil
	end
	if Button1DownConnection then
		Button1DownConnection:disconnect()
		Button1DownConnection = nil
	end
	if Button1UpConnection then
		Button1UpConnection:disconnect()
		Button1UpConnection = nil
	end
	MyHumanoid = nil
end


Tool.Equipped:connect(OnEquipped)
Tool.Unequipped:connect(OnUnequipped)
