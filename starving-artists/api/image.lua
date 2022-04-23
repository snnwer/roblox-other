local Grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid
local HTTPService = game:GetService("HttpService")

function GetJSON(url)
    local result
   
	local success, err = pcall(function()
        result = HTTPService:JSONDecode(game:HttpGet("http://localhost:57554/get?url="..url))
    end)

    if not success then
        return getgenv().sendNotification("Error", "Got error: "..err)
    end
    return result

end

if (getgenv().sendNotification == nil) then 
	getgenv().sendNotification = function(title, text)
		library:MakeNotification({
			Name = title,
			Content = text,
			Time = 3
		})
	end
end


local numbers = {}

function arrangerandom()
	local number = math.random(1, 1024)
	if not table.find(numbers, number) then table.insert(numbers, number) else arrangerandom() end
end

local lib = {}

lib.Player = game.Players.LocalPlayer

function lib:GetPixels(image)
	return GetJSON(image)	
end

function lib:Copy(victim, number: number, waittime: number, notifications: bool, style: string)

	waittime = waittime or 0.03
	style = style or "random"
	if notifications ~= false then notifications = true end
	if string.lower(style) ~= "random" and string.lower(style) ~= "rows" and string.lower(style) ~= "reverserows" then style = "random" end

	if (victim == nil) or (number == nil) then return getgenv().sendNotification("Important", "Important values not set!") end

	local tg = workspace.Plots[victim.Name].Easels[number].Canvas.SurfaceGui.Grid
	local destination = player.PlayerGui.MainGui.PaintFrame.GridHolder.Grid

	local start = os.time()
	if notifications then
		getgenv().sendNotification("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. math.round((1024/(1/waittime)) + os.time()-start) .."s")
		getgenv().sendNotification("Start", "If it did not start painting for you, check F9", Color3.fromRGB(255, 100, 100))
	end

	local ls = string.lower(style)

	for i=1, 1024 do
		if ls == "random" then
			arrangerandom()
		elseif ls == "rows" then
			table.insert(numbers, i)
		elseif ls == "reverserows" then
			table.insert(numbers, 1025-i)
		end
	end

	for i, v in ipairs(numbers) do
		destination[v].BackgroundColor3 = tg[v].BackgroundColor3
		if #tg[v]:GetChildren() > 0 then
			for a,b in next, tg[v]:GetChildren() do
				b:Clone().Parent = destination[v]
			end
		end
		if waittime > 0 then wait(waittime) end
	end
    if notifications then getgenv().sendNotification("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s") end

end

function lib:Draw(image, waittime, notifications, style)
	if not image then return getgenv().sendNotification("Image", "No image!") end

	waittime = waittime or 0.05
	style = style or "random"
	if notifications ~= false then notifications = true end
	if string.lower(style) ~= "random" and string.lower(style) ~= "rows" and string.lower(style) ~= "reverserows" then style = nil end

	function import(url)
		local start = os.time()
		local pixels = lib:GetPixels(url)
	
		if notifications then
			getgenv().sendNotification("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. math.round((1024/(1/waittime)) + os.time()-start) .."s")
			getgenv().sendNotification("Start", "If it did not start painting for you, check F9", Color3.fromRGB(255, 100, 100))
		end

		local ls = string.lower(style)
	
		for i=1, 1024 do
			if ls == "random" then
				arrangerandom()
			elseif ls == "rows" then
				table.insert(numbers, i)
			elseif ls == "reverserows" then
				table.insert(numbers, 1025-i)
			end
		end
	
		for index, random in ipairs(numbers) do
			local pixel = pixels[random]

			local r, g, b = pixel[1], pixel[2], pixel[3]
			if waittime > 0 then wait(waittime) end

			local nextn = random + 1

			local first = pixels[1024]
			if nextn == 2 then Grid[tostring(random)].BackgroundColor3 = Color3.fromRGB(first[1],first[2],first[3]) end
			if not Grid:FindFirstChild(tostring(nextn)) then continue end

			Grid[tostring(nextn)].BackgroundColor3 = Color3.fromRGB(r,g,b)
		end
		if notifications then getgenv().sendNotification("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s") end
	end
	import(image)
end

return lib
