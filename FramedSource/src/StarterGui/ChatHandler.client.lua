wait()

local gui = game:GetService("StarterGui")

wait()

game.ReplicatedStorage:WaitForChild'ChatEvent'.OnClientEvent:connect(function(chat)
	gui:SetCore("ChatMakeSystemMessage", {
		Text = chat
	})
end)