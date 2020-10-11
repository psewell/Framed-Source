tab = {
	shop = {
		text = " : Toggle Shop",
		ctrl = 'http://www.roblox.com/asset/?id=270302838',
		key = 'http://www.roblox.com/asset/?id=272306524'
	},
	mark = {
		text = " : Mark Player",
		ctrl = 'http://www.roblox.com/asset/?id=270302940',
		key = 'http://www.roblox.com/asset/?id=272306575'
	},
	hide = {
		text = " : Hide Weapons",
		ctrl = 'http://www.roblox.com/asset/?id=270302829',
		key = 'http://www.roblox.com/asset/?id=272306487'
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