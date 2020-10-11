local player = game.Players.LocalPlayer

local bars = {
	script.Parent.Equip.fbucks,
	script.Parent.Hats.fbucks,
	script.Parent.Shirts.fbucks,
	script.Parent.fBucks.fbucks,
	script.Parent.Guns.fbucks,
	script.Parent.Bonus.fbucks
}

function checkFBucks(bux)
	local money	
	if bux then
		money = bux
	else
		money = game.Workspace.Events.DataStore.ReadFromLocal:InvokeServer("bux", player.userId)
	end
	for _, bar in pairs(bars) do
		bar.Text = "My F$: " .. money
	end
end

game.Workspace:WaitForChild'Events':WaitForChild'PurchasedFBucks'.OnClientEvent:connect(function()
	script.Parent.Parent.Parent.Parent.Sounds.PurchaseSuccess:Play()
	checkFBucks()
end)

script.Parent:WaitForChild'Check'.Event:connect(function()
	checkFBucks()
end)