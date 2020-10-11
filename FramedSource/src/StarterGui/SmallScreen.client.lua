local CollectionService = game:GetService("CollectionService")

local viewportSize = workspace.CurrentCamera.ViewportSize
if viewportSize.Y > 480 then
	for _, scale in ipairs(CollectionService:GetTagged("SmallScreen")) do
		scale:Destroy()
	end
end
