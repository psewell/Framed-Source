--[[
	Controls for votekicking.
]]

local Roact = require(game.ReplicatedStorage.Packages.Roact)
local ContextAction = require(script.Parent.Input.ContextAction)
local Event = game.ReplicatedStorage.Events.Event

local VotekickControls = Roact.PureComponent:extend("VotekickControls")

function VotekickControls:init()
	self.onYesInput = function(_, state)
		if state == Enum.UserInputState.Begin then
			Event:FireServer(true)
		end
	end

	self.onNoInput = function(_, state)
		if state == Enum.UserInputState.Begin then
			Event:FireServer(false)
		end
	end
end

function VotekickControls:render()
	return Roact.createFragment({
		YesVote = Roact.createElement(ContextAction, {
			Name = "YesVote",
			InputTypes = {Enum.KeyCode.Y},
			OnInput = self.onYesInput,
		}),

		NoVote = Roact.createElement(ContextAction, {
			Name = "NoVote",
			InputTypes = {Enum.KeyCode.N},
			OnInput = self.onNoInput,
		}),
	})
end

return VotekickControls
