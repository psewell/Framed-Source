local rs = script.Parent.Parent.Parent.Parent.RedSeat
local bs = script.Parent.Parent.Parent.Parent.BlueSeat

function gameStart()
  print("Game Start")
	script.Parent.Parent.Game.Controls.Disabled = false
	script.Parent.Parent.Game.Active = true
	script.Parent.Parent.Game.Visible = true
	script.Parent.Parent.Game.Initialize.Disabled = true
	script.Parent.Parent.Game.Initialize.Disabled = false
	script.Parent.Parent.Game.GAME.Ball.Movement.Disabled = false
	script.Parent.Visible = false
	script.Parent.Active = false
end

bs.ChildAdded:connect(function()
	if not script.Parent.Visible then return end
	rs.ChildAdded:wait()
	if #bs:GetChildren() > 0 then
		if not script.Parent.Visible then return end
		gameStart()
	end
end)

rs.ChildAdded:connect(function()
	if not script.Parent.Visible then return end
	bs.ChildAdded:wait()
	if #rs:GetChildren() > 0 then
		if not script.Parent.Visible then return end
		gameStart()
	end
end)