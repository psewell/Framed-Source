--[[
	A notification for when a votekick finished.
]]

local DURATION = 5

local StarterGui = game:GetService("StarterGui")

local VoteFinishedNotification = {}

function VoteFinishedNotification.new(data)
	local didKick = data.KickedPlayer
	if didKick then
		StarterGui:SetCore("SendNotification", {
			Title = "Player Kicked",
			Text = string.format("Player %s was kicked.", data.UserName),
			Duration = DURATION,
		})
	else
		StarterGui:SetCore("SendNotification", {
			Title = "Vote Failed",
			Text = string.format("Player %s was not kicked.", data.UserName),
			Duration = DURATION,
		})
	end
end

return VoteFinishedNotification
