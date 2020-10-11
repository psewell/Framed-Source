B = script.Parent
Pr = script.Parent.Parent.RedPdl
Pb = script.Parent.Parent.BluPdl
Vy = 5
Vx = 8

math.randomseed(tick())

script.Changed:connect(function()
while true do
	wait(0.03)
	if B.Position.Y.Offset <= 10 then
		Vy = 5 + ((math.random()+0.3)*10)
	end
	if B.Position.Y.Offset >= 480 then
		Vy = -5 - ((math.random()+0.3)*10)
	end
	--Oh ho ho ho, here goes the paddling system
		--RED PADDLES
	if B.Position.X.Offset >= 540 then
		if B.Position.Y.Offset > (Pr.Position.Y.Offset - 20) and B.Position.Y.Offset < (Pr.Position.Y.Offset + 30) then
			Vx = -8
			Vy = -5 - ((math.random()+0.3)*10)
		end
		if B.Position.Y.Offset >= (Pr.Position.Y.Offset + 30) and B.Position.Y.Offset < (Pr.Position.Y.Offset + 100) then
			Vx = -8
			Vy = 5 + ((math.random()+0.3)*10)
		end
	end
	
		--BLUE PADDLES
	if B.Position.X.Offset <= 20 then
		if B.Position.Y.Offset > (Pb.Position.Y.Offset - 20) and B.Position.Y.Offset < (Pb.Position.Y.Offset + 30) then
			Vx = 8
			Vy = -5 - ((math.random()+0.3)*10)
		end
		if B.Position.Y.Offset >= (Pb.Position.Y.Offset + 30) and B.Position.Y.Offset < (Pb.Position.Y.Offset + 100) then
			Vx = 8
			Vy = 5 + ((math.random()+0.3)*10)
		end
	end
	
	--SCORING
		--RED SIDE ( BLUE SCORES )
		if B.Position.X.Offset >= 560 then
			B.Visible = false
			Vx = -8
			Vy = -5 - ((math.random()+0.3)*10)
			B.Position = UDim2.new (0, 490, 0, 250)
			script.Parent.Parent.bScore.Visible = true
			wait(1)
			script.Parent.Parent.bScore.Visible = false
			wait(0.2)
			script.Parent.Parent.bScore.Visible = true
			wait(1)
			script.Parent.Parent.bScore.Visible = false
			wait(1)
			script.Parent.Parent.BluScore.Value = (script.Parent.Parent.BluScore.Value + 100)
			if script.Parent.Parent.BluScore.Value == 300 then
				break
			end
			script.Parent.Parent.Ready.Visible = true
			wait(1)
			script.Parent.Parent.Ready.Text = "2"
			wait(1)
			script.Parent.Parent.Ready.Text = "1"
			wait(1)
			script.Parent.Parent.Ready.Text = "GO"
			wait(1)
			script.Parent.Parent.Ready.Visible = false
			script.Parent.Parent.Ready.Text = "3"
			B.Visible = true
		end
		--BLU SIDE ( RED SCORES )
		if B.Position.X.Offset <= 0 then
			B.Visible = false
			Vx = 8
			Vy = 5 + ((math.random()+0.3)*10)
			B.Position = UDim2.new (0, 90, 0, 250)
			script.Parent.Parent.rScore.Visible = true
			wait(1)
			script.Parent.Parent.rScore.Visible = false
			wait(0.2)
			script.Parent.Parent.rScore.Visible = true
			wait(1)
			script.Parent.Parent.rScore.Visible = false
			wait(1)
			script.Parent.Parent.RedScore.Value = (script.Parent.Parent.RedScore.Value + 100)
			if script.Parent.Parent.RedScore.Value == 300 then
				break
			end
			script.Parent.Parent.Ready.Visible = true
			wait(1)
			script.Parent.Parent.Ready.Text = "2"
			wait(1)
			script.Parent.Parent.Ready.Text = "1"
			wait(1)
			script.Parent.Parent.Ready.Text = "GO"
			wait(1)
			script.Parent.Parent.Ready.Visible = false
			script.Parent.Parent.Ready.Text = "3"
			B.Visible = true
		end
	
	B.Position = UDim2.new(0, (B.Position.X.Offset + Vx), 0, (B.Position.Y.Offset + Vy))
	if script.Parent.Parent.BluScore.Value == 300 then
		break
	end
	if script.Parent.Parent.RedScore.Value == 300 then
		break
	end
end
end)