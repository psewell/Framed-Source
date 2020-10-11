local id = 24918890

script.Parent.MouseButton1Click:connect(function()
	game:GetService("MarketplaceService"):PromptProductPurchase(game.Players.LocalPlayer, id)
end)