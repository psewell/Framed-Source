script.Parent.GAME.BluPdl.Position = UDim2.new(0,0,0,200)
script.Parent.GAME.RedPdl.Position = UDim2.new(0,560,0,200)
script.Parent.Controls.Disabled = false
script.Parent.GAME.Ball.Visible = false
script.Parent.GAME.Ball.Position = UDim2.new (0, 290, 0, 250)
script.Parent.GAME.Ready.Text = "3"
script.Parent.GAME.Ready.Visible = true
script.Parent.GAME.bScore.Visible = false
script.Parent.GAME.rScore.Visible = false
			wait(1)
			script.Parent.GAME.Ready.Text = "2"
			script.Parent.GAME.Ball.Position = UDim2.new (0, 290, 0, 250)
			wait(1)
			script.Parent.GAME.Ready.Text = "1"
			script.Parent.GAME.Ball.Position = UDim2.new (0, 290, 0, 250)
			wait(1)
			script.Parent.GAME.Ready.Text = "GO"
			script.Parent.GAME.Ball.Position = UDim2.new (0, 290, 0, 250)
			wait(1)
			script.Parent.GAME.Ready.Visible = false
			script.Parent.GAME.Ready.Text = "3"
script.Parent.GAME.Ball.Visible = true
script.Parent.GAME.Ball.Position = UDim2.new (0, 90, 0, 250)
script.Parent.GAME.BluScore.Value = 0
script.Parent.GAME.RedScore.Value = 0
	script.Parent.Parent.Game.GAME.Ball.Movement.Disabled = true
	script.Parent.Parent.Game.GAME.Ball.Movement.Disabled = false