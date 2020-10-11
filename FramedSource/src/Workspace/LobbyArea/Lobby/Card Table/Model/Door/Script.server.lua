debounce = true

function onClick()
	if not debounce then return end
	debounce = false
	local cards = script.Parent.Parent:GetChildren()
	for _, card in pairs(cards) do
		if card ~= script.Parent then
			local d = card.Decal
		local n = (math.random(1,13))
		if (n == 1) then 
			d.Value = "http://www.roblox.com/asset/?id=13283720"
		elseif (n == 2) then
			d.Value = "http://www.roblox.com/asset/?id=13283735"
		elseif (n == 3) then
			d.Value = "http://www.roblox.com/asset/?id=13283740"
		elseif (n == 4) then
			d.Value = "http://www.roblox.com/asset/?id=13283744"
		elseif (n == 5) then
			d.Value = "http://www.roblox.com/asset/?id=13283752"
		elseif (n == 6) then
			d.Value = "http://www.roblox.com/asset/?id=13283758"
		elseif (n == 7) then
			d.Value = "http://www.roblox.com/asset/?id=13283761"
		elseif (n == 8) then
			d.Value = "http://www.roblox.com/asset/?id=13283768"
		elseif (n == 9) then
			d.Value = "http://www.roblox.com/asset/?id=13283772"
		elseif (n == 10) then
			d.Value = "http://www.roblox.com/asset/?id=13283781"
		elseif (n == 11) then
			d.Value = "http://www.roblox.com/asset/?id=13283789"
		elseif (n == 12) then
			d.Value = "http://www.roblox.com/asset/?id=13283800"
		elseif (n == 13) then
			d.Value = "http://www.roblox.com/asset/?id=13283810"
		end
		d.Parent.Pic.Texture = "http://www.roblox.com/asset/?id=13284263"
		end
	end
	wait(5)
	debounce = true
end

script.Parent.MouseClick.OnServerEvent:connect(onClick)