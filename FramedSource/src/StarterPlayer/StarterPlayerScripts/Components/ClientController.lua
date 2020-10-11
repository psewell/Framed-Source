--[[
	Client controller.
]]

local Roact = require(game.ReplicatedStorage.Packages.Roact)
local EventHandler = require(script.Parent.EventHandler)
local VotekickControls = require(script.Parent.VotekickControls)

local ClientController = Roact.PureComponent:extend("ClientController")

function ClientController:render()
	return Roact.createFragment({
		EventHandler = Roact.createElement(EventHandler),
		VotekickControls = Roact.createElement(VotekickControls),
	})
end

return ClientController
