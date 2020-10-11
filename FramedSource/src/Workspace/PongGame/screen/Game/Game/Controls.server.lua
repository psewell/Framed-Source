B = script.Parent.Parent.Parent.Parent.BlueSeat
Bp = script.Parent.GAME.BluPdl
R = script.Parent.Parent.Parent.Parent.RedSeat
Rp = script.Parent.GAME.RedPdl

while true do
	wait(0)
	Rp.Position = UDim2.new(0, 560, 0, math.max(0, math.min(400, (Rp.Position.Y.Offset + (-R.Throttle * 10)))))
	Bp.Position = UDim2.new(0, 0, 0, math.max(0, math.min(400, (Bp.Position.Y.Offset + (-B.Throttle * 10)))))
end