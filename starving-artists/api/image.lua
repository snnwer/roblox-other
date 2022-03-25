local Grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.Grid
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

function lib:Draw(image, waittime, notifications)
	if not image then return sendNotification("Image", "No image!") end

	waittime = waittime or 0.05
	if notifications == nil then notifications = true end

	function import(url)
		local start = os.time()
		local pixels = lib:GetPixels(url)
	
		if notifications then
			sendNotification("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. math.round((1024/(1/waittime)) + os.time()-start) .."s")
			sendNotification("Start", "If it did not start painting for you, check F9", Color3.fromRGB(255, 100, 100))
		end

		local cells = {}
		--[[Grid['1'].BackgroundColor3 = Color3.fromRGB(
			pixels[1][1],
			pixels[1][2],
			pixels[1][3]
		)]]
	
		for i = 1, 1024 do
			arrangerandom()
		end
	
		for index, random in ipairs(numbers) do
			--[[local prev = random - 1
			if random == 1 then prev = random end]]
			local pixel = pixels[random]

			local r, g, b = pixel[1], pixel[2], pixel[3]
			if waittime > 0 then wait(waittime) end

			Grid[tostring(random)].BackgroundColor3 = Color3.fromRGB(r,g,b)
			table.insert(cells, pixel)
		end
		if notifications then sendNotification("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s") end
	end
	import(image)
end

return lib
