--[[
	A simple context action handler.
]]

local ContextActionService = game:GetService("ContextActionService")

local Roact = require(game.ReplicatedStorage.Packages.Roact)

local ContextAction = Roact.PureComponent:extend("ContextAction")

local t = require(game.ReplicatedStorage.Packages.t)
local typecheck = t.interface({
	Name = t.string,
	InputTypes = t.table,
	OnInput = t.callback,
})

function ContextAction:init(props)
	assert(typecheck(props))
	ContextActionService:BindAction(props.Name,
		props.OnInput,
		false,
		table.unpack(props.InputTypes))
end

function ContextAction:render()
	return nil
end

function ContextAction:willUnmount()
	ContextActionService:UnbindAction(self.props.Name)
end

return ContextAction
