tab = {
	shop = {
		text = " : Slash",
		ctrl = 'http://www.roblox.com/asset/?id=270302973',
		key = 'http://www.roblox.com/asset/?id=272306634'
	}
}

function change(tabz)
	script.Parent.Frame.TextLabel.Text = tabz.text
	if game:GetService("UserInputService").GamepadEnabled then
		script.Parent.Frame.ImageLabel.Image = tabz.ctrl
	else
		script.Parent.Frame.ImageLabel.Image = tabz.key
	end
end

script.Parent.Frame.Changed:connect(function()
	change(tab['shop'])
end)

while true do
	for _, t in pairs(tab) do
		wait(5)
		change(t)
	end
end