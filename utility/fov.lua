local lib = {}
local utility = { tables = {} }

utility.tables.copyMissing = function(self, toCopy, noticeTypes)
	for index, value in next, toCopy do
		if self[index] == nil or (noticeTypes and typeof(self[index]) ~= typeof(value)) then
			self[index] = value
		end
	end
end

utility.tables.getLen = function(self)
	local count = 0

	for i, v in next, self do
		count += 1
	end

	return count
end
local connection = {}

local cons = {}

connection.new = function(con, id, callback)
	assert(typeof(con) == "RBXScriptSignal", "connection isn't a RBXScriptSignal")
	assert(typeof(id) == "string", "id type is " .. typeof(id) .. ", expected string")
	callback = callback or function() end
	if cons[tostring(con)] == nil then
		cons[tostring(con)] = {}
		local newCon
		newCon = con:Connect(function()
			local count = 0
			for index, value in next, cons[tostring(con)] do
				local success, error = pcall(value)

				if not success then
					rconsoleprint("[OUTLIERS] Loop error: " .. error)
				end
				count += 1
			end
			if count == 0 then
				cons[tostring(con)] = nil
				cons = cons
				if newCon then
					newCon:Disconnect()
				end
			end
		end)
	end
	assert(cons[tostring(con)][id] == nil, "ID already exists")
	cons[tostring(con)][id] = callback

	local types = {}

	types.disconnect = function(self)
		cons[tostring(con)][id] = nil
		cons[tostring(con)] = cons[tostring(con)]
	end
	types.setCallback = function(self, newCallback)
		cons[tostring(con)][id] = newCallback
	end

	return types
end

local fov = {
	stable = false,
	id = "",
	options = {
		Filled = true,
		Color = Color3.new(1, 1, 1),
		Transparency = 1,
		Thickness = 1,
		NumSides = 50,
		Radius = 1,
	},
}
--[[
	
	// fov contains:
	* instance: table (drawing) = fov instance
	* stable: bool = should move with cursor or not
	* id: string = the id of the object
	* options: table []
		* Filled: bool = is filled
		* Color: color3.new = fov color
		* Transparency: number = fov alpha
		* Thickness: number = fov thickness
		* NumSides: number = fov num sides
		* Radius: number = fov

]]
--

local function getPositionOnScreen(Vector)
	local vec3, onscreen = workspace.CurrentCamera:WorldToScreenPoint(Vector)
	return Vector2.new(vec3.X, vec3.Y), onscreen
end

getgenv().fovlist = getgenv().fovlist or {}
local functions = {}

functions.edit = function(self, options, stable)
	stable = stable == nil and self['stable'] or stable

	utility.tables.copyMissing(options, self["options"], true)

	local new = self["instance"]
	self["stable"] = stable

	for index, value in next, options do
		local s, e = pcall(function()
			new[index] = value
			self["options"][index] = value
		end)
		if not s then print('got an error with', index, 'value is', value) end
	end

	return new
end
functions.remove = function(self)
	if self["instance"] then
		self["instance"]:Remove()
	end
	if self['connection'] then
		self['connection']:disconnect()
	end
	getgenv().fovlist[self["id"]] = nil

	getgenv().fovlist = fovlist
	return
end
functions.check = function(self, player, part)
	if not self["instance"] then
		return false
	end
	if not player.Character or not player.Character:FindFirstChild(part) then
		return false
	end
	local pos, vis = getPositionOnScreen(player.Character:FindFirstChild(part).Position)
	if not vis then
		return false
	end

	return (self['instance'].Position - Vector2.new(pos.X, pos.Y)).Magnitude <= self["instance"].Radius
end
functions.getAll = function(self, part)
	if not self["instance"] then
		return false
	end

	local players = {}
	for _, player in next, game:GetService("Players"):GetPlayers() do
	
	if player == game:GetService('Players').LocalPlayer then continue end
		local character = player.Character
		if
			(not character)
			or (not character:FindFirstChild("HumanoidRootPart"))
			or (not character:FindFirstChild(part))
			or (character:FindFirstChild("Humanoid").Health <= 0)
		then
			continue
		end
		local pos, vis = getPositionOnScreen(character:FindFirstChild(part).Position)
		if not vis then
			continue
		end

		if
			not ((self['instance'].Position - pos).Magnitude <= self["instance"].Radius)
		then
			continue
		end

		table.insert(players, player)
	end
	return players
end
functions.getClosest = function(self, part, team)
	if not self["instance"] then
		return
	end
	part = part or "HumanoidRootPart"
	team = team == nil and false or team

	local closest
	local magnitude = self["instance"].Radius
	for _, player in next, game:GetService("Players"):GetPlayers() do
		local character = player.Character
		if not character or not character:FindFirstChild(part) then
			continue
		end
		if player == game:GetService("Players").LocalPlayer then
			continue
		end
		if team and player.Team == game:GetService("Players").LocalPlayer.Team then
			continue
		end

		local pos, onscreen = getPositionOnScreen(character:FindFirstChild(part).Position)
		if not onscreen then
			continue
		end

		local dist = (self['instance'].Position - pos).Magnitude
		if dist <= magnitude then
			closest = player
			magnitude = dist
		end
	end
	return closest
end

lib.new = function(id, options, stable)
	assert(typeof(id) == "string", "ID is " .. typeof(id) .. ", expected a string")
	assert(getgenv().fovlist[id] == nil, "ID already exists")
	stable = stable == nil and false or stable
	local new = table.clone(fov)

	utility.tables.copyMissing(options, fov["options"], true)

	new["options"] = options
	new["stable"] = stable
	new["id"] = id

	for i, v in next, functions do
		rawset(new, i, v)
	end

	local fov = Drawing.new("Circle")

	for index, value in next, options do
		fov[index] = value
	end

	new["instance"] = fov
	new['connection'] = connection.new(game:GetService('RunService').RenderStepped, id, function()
		if not new or not new['instance'] or not new['instance'].Visible or new['instance'].Transparency == 0 then print(1) return end
		if not workspace.CurrentCamera then return end

		new['instance'].Position = new['stable'] and Vector2.new(workspace.CurrentCamera.ViewportSize.X / 2, workspace.CurrentCamera.ViewportSize.Y / 2) or game:GetService('UserInputService'):GetMouseLocation()
	end)

	getgenv().fovlist[id] = new

	return new, fov
end

lib.getById = function(id)
	return getgenv().fovlist[id]
end

return lib
