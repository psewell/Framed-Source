function updateboard(PKills, UKills, WKills, Accidents, image)
	script.Parent.SurfaceGui.PoliceKills.Value = PKills
	script.Parent.SurfaceGui.UndercoverKills.Value = UKills
	script.Parent.SurfaceGui.WinnerKills.Value = WKills
	script.Parent.SurfaceGui.Accidents.Value = Accidents
	script.Parent.SurfaceGui.Frame.ImageLabel.Image = image
end

game.Workspace.Events.UpdateBoard.Event:connect(updateboard)