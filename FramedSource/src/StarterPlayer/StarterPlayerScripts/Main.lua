--[[
	Mounts the main tree.
]]

local Roact = require(game.ReplicatedStorage.Packages.Roact)

local player = game.Players.LocalPlayer
local ClientController = require(script.Parent:WaitForChild("Components"):WaitForChild("ClientController"))

local Main = {}
Main.__index = Main

function Main.new()
	local self = {}
	return setmetatable(self, Main)
end

function Main:connect()
	local function onCharacter(char)
		player:WaitForChild("PlayerGui")
		local handle = Roact.mount(Roact.createElement(ClientController))

		local connection
		connection = player.CharacterRemoving:Connect(function()
			connection:Disconnect()
			Roact.unmount(handle)
		end)
	end

	player.CharacterAdded:Connect(onCharacter)

	if player.Character ~= nil then
		onCharacter(player.Character)
	end
end

return Main
