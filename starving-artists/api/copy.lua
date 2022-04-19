local player = game.Players.LocalPlayer

local lib = {}

getgenv().IrisAd = true
if (getgenv().notificationlib == nil) then getgenv().notificationlib = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))() end
if (getgenv().sendNotification == nil) then 
    getgenv().sendNotification = function(title, text)
        title = title or "None"
        text = text or "No text"
    
        getgenv().notificationlib.Notify(title, text, "rbxassetid://6492856164", {
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
                SolidColor = Color3.fromRGB(35,35,35),
                Retract = false,
                Extend = false
            },
        
            Main = {
                BorderColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BackgroundTransparency = 0.05,
                Rounding = false,
                BorderSizePixel = 0
            }
        })
    end
end

local numbers = {}

function arrangerandom()
	local number = math.random(1, 1024)
	if not table.find(numbers, number) then table.insert(numbers, number) else arrangerandom() end
end

function lib:Copy(victim, number: number, waittime: number, notifications: bool, style: string)

	waittime = waittime or 0.03
	style = style or "random"
	if notifications ~= false then notifications = true end
	if string.lower(style) ~= "random" and string.lower(style) ~= "rows" and string.lower(style) ~= "reverserows" then style = "random" end

	if (victim == nil) or (number == nil) then return getgenv().sendNotification("Important", "Important values not set!") end

	local tg = workspace.Plots[victim.Name].Easels[number].Canvas.SurfaceGui.Grid
	local destination = player.PlayerGui.MainGui.PaintFrame.GridHolder.Grid

	function copy()
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

	copy()

end

return lib