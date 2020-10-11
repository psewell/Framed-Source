R = script.Parent.GAME.RedScore
B = script.Parent.GAME.BluScore
Rd = script.Parent.ScoreRed
Bd = script.Parent.ScoreBlu

R.Changed:connect(function()
	  Rd.Text = "Score: " .. R.Value
	if R.Value == 300 then
script.Parent.Parent.RedWins.Active = true
script.Parent.Parent.RedWins.Visible = true
script.Parent.Parent.RedWins.Script.Disabled = true
script.Parent.Parent.RedWins.Script.Disabled = false
script.Parent.Visible = false
script.Parent.Active = false

	end
end)

B.Changed:connect(function()
	  Bd.Text = "Score: " .. B.Value
	if B.Value == 300 then
script.Parent.Parent.BlueWins.Active = true
script.Parent.Parent.BlueWins.Visible = true
script.Parent.Parent.BlueWins.Script.Disabled = true
script.Parent.Parent.BlueWins.Script.Disabled = false
script.Parent.Visible = false
script.Parent.Active = false

	end
end)