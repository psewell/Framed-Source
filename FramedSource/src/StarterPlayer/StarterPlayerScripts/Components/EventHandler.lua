--[[
	Handles when the server fires an event at the local user.
]]

local Roact = require(game.ReplicatedStorage.Packages.Roact)
local Event = game.ReplicatedStorage.Events.Event

local EventHandler = Roact.PureComponent:extend("EventHandler")

local Notifications = script.Parent.Notifications
local Handlers = {
	VoteBegan = require(Notifications.VoteNotification),
	VoteFinished = require(Notifications.VoteFinishedNotification),
	VoteRecorded = require(Notifications.VoteUpdatedNotification),
}

function EventHandler:init(props)
	self.connection = Event.OnClientEvent:Connect(function(name, data)
		local handler = Handlers[name]
		if handler then
			handler.new(data)
		end
	end)
end

function EventHandler:render()
	return nil
end

function EventHandler:willUnmount()
	self.connection:Disconnect()
end

return EventHandler
