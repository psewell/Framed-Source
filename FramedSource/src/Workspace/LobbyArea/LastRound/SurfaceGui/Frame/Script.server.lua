while true do
	wait(10)
	script.Parent.WinKills.Visible = false
	script.Parent.Police.Visible = true
	script.Parent.Score.Text = script.Parent.Parent.PoliceKills.Value
	wait(10)
	script.Parent.Police.Visible = false
	script.Parent.Undercover.Visible = true
	script.Parent.Score.Text = script.Parent.Parent.UndercoverKills.Value
	wait(10)
	script.Parent.Undercover.Visible = false
	script.Parent.Accidents.Visible = true
	script.Parent.Score.Text = script.Parent.Parent.Accidents.Value
	wait(10)
	script.Parent.Accidents.Visible = false
	script.Parent.WinKills.Visible = true
	script.Parent.Score.Text = script.Parent.Parent.WinnerKills.Value
end