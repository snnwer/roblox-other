--[[

  Huge thanks to https://v3rmillion.net/member.php?action=profile&uid=2615433 and his script, https://v3rmillion.net/showthread.php?tid=1162888

]]--

local grid = game.Players.LocalPlayer.PlayerGui.MainGui.PaintFrame.Grid
local HTTPService = game:GetService("HttpService")

function GetJSON(url)
   return HTTPService:JSONDecode(game:HttpGet("http://localhost:57554/get?url="..url))
end

getgenv().IrisAd = true
local lib = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

function sendNotification(title, text)
    title = title or "None"
    text = text or "No text"

    lib.Notify(title, text, "rbxassetid://6492856164", {
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
  
if not getgenv().image then sendNotification("ERROR", "No image input") return end
getgenv().waittime = getgenv().waittime or 0.05


local numbers = {}

function arrangerandom()
    local number = math.random(1, 1024)
    if not table.find(numbers, number) then table.insert(numbers, number) else arrangerandom() end
end

function import(url)
   local start = os.time()
   local pixels = GetJSON(url)

   sendNotification("Start", "Started at ".. os.date("%b. %d, %H:%M", start) .. ", approx. time: ".. ((1024/(1/waittime)) + os.time()-start) .."s")
   sendNotification("Start", "If it did not start painting for you, check F9")
    
   local cells = {}
   local index = 1
   grid['1'].BackgroundColor3 = Color3.fromRGB(
       pixels[1][1],
       pixels[1][2],
       pixels[1][3]
   )

    for i = 1, 1024 do
        arrangerandom()
    end

    for index, random in ipairs(numbers) do
        local pixel = pixels[random]

        local r, g, b = pixels[random][1], pixels[random][2], pixels[random][3]
        
        wait(waittime)
        
        grid[tostring(random)].BackgroundColor3 = Color3.fromRGB(r,g,b)
        table.insert(cells, pixel)
    end

    sendNotification("Finish", "Finished at ".. os.date("%b. %d, %H:%M", os.time()) .. ", time taken: ".. os.time() - start .."s")
end

import(image)
