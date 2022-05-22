--[[

	Modified version
	Original not made by me

]]

local lib = {}
lib.__index = lib

lib.DefaultSettings = {
	Enabled = true,
	DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
	FillColor = Color3.fromRGB(255, 50, 50),
	OutlineColor = Color3.fromRGB(255, 255, 255),
	FillTransparency = 0.5,
	OutlineTransparency = 0
}

function lib:Create(Object: Instance, Props: table?)
	Props = Props or lib.DefaultSettings

	local newHighlight = Instance.new("Highlight")
	newHighlight.Parent = Object

	for Index, Property in next, Props do
		newHighlight[Index] = Property
	end

	return setmetatable({
		Connections = {},
		Object = newHighlight,
	}, lib)
end

function lib:Destroy()
	return self.Object:Destroy()
end

function lib:Set(Props: table?)
	Props = Props or lib.DefaultSettings
	for Index, Property in next, Props do
		self.Object[Index] = Property
	end
end

return lib