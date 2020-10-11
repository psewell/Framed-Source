game.Workspace:WaitForChild'Events':WaitForChild'LocalShot'.OnClientEvent:connect(function(isBad)
	script.Parent.Frame:ClearAllChildren()
	local hitmark
	if isBad then
		hitmark = script.Parent.HitMarkBad:Clone()
		script.Parent.Parent.Sounds.GunHitBad:Play()
	else
		hitmark = script.Parent.HitMark:Clone()
		script.Parent.Parent.Sounds.GunHit:Play()
	end
	hitmark.Parent = script.Parent.Frame
	hitmark.Visible = true
	game.Debris:AddItem(hitmark, 0.2)
end)