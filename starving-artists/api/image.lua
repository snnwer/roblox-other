local Grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.GridHolder.Grid
local HTTPService = game:GetService("HttpService")

function GetJSON(url)
	return HTTPService:JSONDecode(game:HttpGet("http://localhost:57554/get?url="..url))
end

getgenv().IrisAd = true
local notifications = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

function sendNotification(title, text, color)
	 title = title or "None"
	 text = text or "No text"
	 color = color or Color3.fromRGB(35,35,35)

	 notifications.Notify(title, text, "rbxassetid://6492856164", {
	 Duration = 5,

	 TitleSettings = {
			Font = Enum.Font.GothamBlack,
			TextScaled = false,
			TextSize = 16
	 },

	 DescriptionSettings = {
			Font = Enum.Font.Gotham,
			TextScaled = true,
			TextSize = 18
	 },

	 GradientSettings = {
			GradientEnabled = false,
			SolidColorEnabled = false,
			SolidColor = color,
			Retract = false,
			Extend = false
	 },

	 Main = {
			BorderColor3 = color,
			BackgroundColor3 = color,
			BackgroundTransparency = 0.05,
			Rounding = false,
			BorderSizePixel = 0
	 }
})
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

function lib:Draw(image, waittime, notifications, style)
	if not image then return sendNotification("Image", "No image!") end

	waittime = waittime or 0.05
	style = style or "random"
	if notifications ~= false then notifications = true end
	if string.lower(style) ~= "random" and string.lower(style) ~= "rows" and string.lower(style) ~= "reverserows" then style = nil end
	style = style or "random"

	function import(url)
		local start = os.time()
		local pixels = lib:GetPixels(url)
	
		if notifications then
			sendNotification("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. math.round((1024/(1/waittime)) + os.time()-start) .."s")
			sendNotification("Start", "If it did not start painting for you, check F9", Color3.fromRGB(255, 100, 100))
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
		if notifications then sendNotification("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s") end
	end
	import(image)
end

return lib
