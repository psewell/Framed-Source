game.Workspace:WaitForChild'Events':WaitForChild'GetPack'.OnServerInvoke = function(plr)
	if (plr:FindFirstChild('MyBackpack') == nil) then
		local pack = Instance.new("Folder")
		pack.Name = "MyBackpack"
		pack.Parent = plr
		return pack
	else
		return nil
	end
end