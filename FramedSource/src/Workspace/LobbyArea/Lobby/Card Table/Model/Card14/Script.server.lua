function onClick()
	script.Parent.Pic.Texture = script.Parent.Decal.Value
end

script.Parent.MouseClick.OnServerEvent:connect(onClick)