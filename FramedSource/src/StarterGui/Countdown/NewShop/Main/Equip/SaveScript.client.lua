script.Parent:WaitForChild'SaveButton'.MouseButton1Click:connect(function()
	if script.Parent.SaveButton.Text ~= "SAVE THIS LOADOUT" then return end
	script.Parent.SaveButton.Text = "SAVING..."
	local frame = script.Parent.ScrollingFrame
	local colorz = frame.Color.Description.Text
	if colorz == "Default" then colorz = "Institutional white" end
	local facez = tonumber(frame.Face.Description.Text) or 0
	local genderz = frame.Gender.Description.Text
	local hatz = frame.Hat.Description.Text
	local shirtz = frame.Shirt.Description.Text
	local gunz = frame.Gun.Description.Text
	local loadout = {
		hat = hatz,
		color = colorz,
		isFemale = (genderz == "Female"),
		shirt = shirtz,
		gun = gunz,
		face = facez
	}
	game.Workspace.Events.DataStore.WriteToWaitLocal:InvokeServer(
		"loadout",
		game.Players.LocalPlayer.userId,
		loadout
	)
	script.Parent.SaveButton.Text = "SAVED!"
	wait(1)
	script.Parent.SaveButton.Text = "SAVE THIS LOADOUT"
end)