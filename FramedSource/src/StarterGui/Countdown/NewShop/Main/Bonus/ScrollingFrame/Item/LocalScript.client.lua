script.Parent.MouseEnter:connect(function()
	script.Parent.Style = "ChatGreen"
end)

script.Parent.MouseLeave:connect(function()
	script.Parent.Style = "ChatRed"
end)

script.Parent.BuyThis.MouseButton1Click:connect(function()
	if game.Players.LocalPlayer.UndercoverNow.Value then return end
	local info = {
		preview = script.Parent.Preview.Image,
		price = script.Parent.Price.Value,
		item = script.Parent.ItemToBuy.Value
	}
	game.Players.LocalPlayer.PlayerGui.Countdown.NewShop.Frame.Main.PromptPurchase:Invoke(
		info, script.Parent.Parent.Parent, script.Parent.Category.Value)
end)