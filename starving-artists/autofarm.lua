--[[ fixed as 3/27/2022
created by Xyba and fixed by juN aka felipe rumanov.
forked by snnwer
]]--

repeat
    wait()
until game:IsLoaded()

local defaultSettings = {
  MinimumPlayers = 10,
  MinimumBuyers = 5,
  MinutesOnServer = 5,
  JoinMSG = "Buy my art and I will buy yours for double!",
  ClaimBooth = true,
  minimumBought = nil
}

getgenv().settings = getgenv().settings or defaultSettings

wait(2)
pcall(function()
        if getgenv().settings.ClaimBooth then
            local lp = game.Players.LocalPlayer
            local waitForPlots = workspace:WaitForChild("Plots")

            spawn(function()
                    while not waitForPlots:FindFirstChild(lp.Name) do
                        local unclaimed = game:GetService("Workspace").Plots:FindFirstChild("Unclaimed")
                        if unclaimed then
                            if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                                for i, v in pairs(unclaimed:GetDescendants()) do
                                    if v.Name == "tablePart" then
                                        lp.Character.HumanoidRootPart.CFrame =
                                            unclaimed.Table:FindFirstChild("tablePart").CFrame + Vector3.new(0, 3, 0)
                                    end
                                end

                                if getgenv().settings.JoinMSG then
                                    pcall(
                                        function()
                                            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                                                getgenv().settings.JoinMSG,
                                                "All")
                                            getgenv().settings.JoinMSG = nil
                                        end)
                                end
                            end
                            wait(1.5)
                            for i, v in pairs(unclaimed:GetDescendants()) do
                                if v.Name == "BoothClaimPrompt" then
                                    fireproximityprompt(v)
                                end
                            end
                        end
                    end
                end)
        end
        function hop()
            pcall(
                function()
                    spawn(function()
                            while wait(2) do
                                rejoining = true
                                if queue_on_teleport then
                                    queue_on_teleport('game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()')
                                end
                                -- thanks for cmd-x serverhopper
                                local Decision = "any"
                                local GUIDs = {}
                                local maxPlayers = 0
                                local pagesToSearch = 100
                                if Decision == "fast" then
                                    pagesToSearch = 5
                                end
                                local Http =
                                    game:GetService("HttpService"):JSONDecode(
                                    game:HttpGet(
                                        "https://games.roblox.com/v1/games/" ..
                                            game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100&cursor="))
                                for i = 1, pagesToSearch do
                                    for i, v in pairs(Http.data) do
                                        if v.playing ~= v.maxPlayers and v.id ~= game.JobId then
                                            maxPlayers = v.maxPlayers
                                            table.insert(GUIDs, {id = v.id, users = v.playing})
                                        end
                                    end

                                    if Http.nextPageCursor ~= null then
                                        Http =
                                            game:GetService("HttpService"):JSONDecode(
                                            game:HttpGet(
                                                "https://games.roblox.com/v1/games/" ..
                                                    game.PlaceId ..
                                                        "/servers/Public?sortOrder=Asc&limit=100&cursor=" ..
                                                            Http.nextPageCursor))
                                    else
                                        break
                                    end
                                end

                                if Decision == "any" or Decision == "fast" then
                                    game:GetService("TeleportService"):TeleportToPlaceInstance(
                                        game.PlaceId,
                                        GUIDs[math.random(1, #GUIDs)].id)
                                elseif Decision == "smallest" then
                                    game:GetService("TeleportService"):TeleportToPlaceInstance(
                                        game.PlaceId,
                                        GUIDs[#GUIDs].id)
                                elseif Decision == "largest" then
                                    game:GetService("TeleportService"):TeleportToPlaceInstance(
                                        game.PlaceId,
                                        GUIDs[1].id)
                                end
                                wait(3)
                                rejoining = false
                            end
                        end)
                end)
        end

        local players = game.Players:GetChildren()
        local countPlayers = #players

        local buyers = 0
        local suggarAmount = 0
        for i, v in pairs(players) do
            if v == game.Players.LocalPlayer then continue end
            for i, v in pairs(v:GetDescendants()) do
                if v.Name == "Bought" then
                    if v.Value > 0 then
                        buyers = buyers + 1
                    end

                    if getgenv().settings.minimumBought then
                        if v.Value > getgenv().settings.minimumBought then
                            suggarAmount = suggarAmount + 1
                        end
                    end
                end
            end
        end

        if countPlayers >= getgenv().settings.MinimumPlayers and buyers >= getgenv().settings.MinimumBuyers then
            if getgenv().settings.minimumBought then
                if suggarAmount > 0 then
                    local waitTime = getgenv().settings.MinutesOnServer * 60
                    local client = game.GetService(game, "Players").LocalPlayer

                    for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
                        v:Disable()
                    end
                    wait(waitTime)
                    hop()
                else
                    hop()
                end
            else
                local waitTime = MinutesOnServer * 60
                local client = game.GetService(game, "Players").LocalPlayer

                for i, v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
                    v:Disable()
                end
                wait(waitTime)
                hop()
            end
        else
            hop()
        end
    end)


local a=loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()getgenv().IrisAd=true;a.Notify("Tux","loaded your config, it should teleport you based on settings.","rbxassetid://9211241843",{Duration=11,TitleSettings={TextXAlignment=Enum.TextXAlignment.Center,Font=Enum.Font.SourceSansSemibold},GradientSettings={GradientEnabled=false,SolidColorEnabled=true,SolidColor=Color3.fromRGB(124,83,240),Retract=true}})
