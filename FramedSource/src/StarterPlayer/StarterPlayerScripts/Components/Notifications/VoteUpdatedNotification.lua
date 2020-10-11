--[[
	A notification for when the vote is updated.
]]

local DURATION = 5

local StarterGui = game:GetService("StarterGui")

local VoteUpdatedNotification = {}

function VoteUpdatedNotification.new(data)
	if data.UserName == game.Players.LocalPlayer.Name then
		StarterGui:SetCore("SendNotification", {
			Title = "Vote Received",
			Text = "Thank you for voting.",
			Duration = DURATION,
		})
	end
end

return VoteUpdatedNotification
