local MarketplaceService = game:GetService("MarketplaceService")
local fBucks50 = 24918869
local fBucks100 = 24918873
local fBucks500 = 24918880
local fBucks1000 = 24918890
 
MarketplaceService.ProcessReceipt = function(receiptInfo)
    -- find the player based on the PlayerId in receiptInfo
    for i, player in ipairs(game.Players:GetPlayers()) do
        if player.userId == receiptInfo.PlayerId then
            -- check which product was purchased (required, otherwise you'll award the wrong items if you're using more than one developer product)
            if receiptInfo.ProductId == fBucks50 then
            	game.Workspace.Events.DataStore.WriteToWait:Invoke('bux', player.userId, 50)
				game.Workspace.Events.PurchasedFBucks:FireClient(player)
				return Enum.ProductPurchaseDecision.PurchaseGranted
            elseif receiptInfo.ProductId == fBucks100 then
				game.Workspace.Events.DataStore.WriteToWait:Invoke('bux', player.userId, 100)
				game.Workspace.Events.PurchasedFBucks:FireClient(player)
				return Enum.ProductPurchaseDecision.PurchaseGranted
            elseif receiptInfo.ProductId == fBucks500 then
				game.Workspace.Events.DataStore.WriteToWait:Invoke('bux', player.userId, 500)
				game.Workspace.Events.PurchasedFBucks:FireClient(player)
				return Enum.ProductPurchaseDecision.PurchaseGranted
			elseif receiptInfo.ProductId == fBucks1000 then
				game.Workspace.Events.DataStore.WriteToWait:Invoke('bux', player.userId, 1000)
				game.Workspace.Events.PurchasedFBucks:FireClient(player)
				return Enum.ProductPurchaseDecision.PurchaseGranted
			end
        end	
    end
    return Enum.ProductPurchaseDecision.NotProcessedYet		
end