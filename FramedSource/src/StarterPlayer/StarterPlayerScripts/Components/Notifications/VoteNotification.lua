--[[
	A notification for when a player could votekick.
]]

local DURATION = 10

local StarterGui = game:GetService("StarterGui")

local VoteNotification = {}
local Event = game.ReplicatedStorage.Events.Event

function VoteNotification.new(data)
	local onClick = function(buttonText)
		local isYes
		if buttonText == "👍 (y)" then
			isYes = true
		else
			isYes = false
		end
		Event:FireServer(isYes)
	end
	local bindable = Instance.new("BindableFunction")
	bindable.OnInvoke = onClick

	StarterGui:SetCore("SendNotification", {
		Title = string.format("Kick Player %s", data.UserName),
		Text = string.format("%s wants to kick %s from the server.", data.VoterName, data.UserName),
		Callback = bindable,
		Button1 = "👍 (y)",
		Button2 = "👎 (n)",
		Duration = DURATION,
	})
end

return VoteNotification
