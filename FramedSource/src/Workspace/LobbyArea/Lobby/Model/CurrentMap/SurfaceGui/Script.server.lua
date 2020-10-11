game.Workspace:WaitForChild("Events")
game.Workspace.Events:WaitForChild("MapImage")

game.Workspace.Events.MapImage.Event:connect(function(img, maker)
	script.Parent.ImageLabel.Image = img
	script.Parent.Maker.Text = "Made by " .. maker
end)