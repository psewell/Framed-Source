game.Workspace.ChildAdded:connect(function(child)
	if child:IsA("Tool") or child:IsA("Hat") or child:IsA("Accessory") then
		wait()
		child:Destroy()
	end
end)