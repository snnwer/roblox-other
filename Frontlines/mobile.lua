game:GetService('TeleportService'):Teleport(12736476421, game:GetService('Players').LocalPlayer) -- yay!
pcall(function()
    local JSONEncode, JSONDecode, GenerateGUID = 
  game.HttpService.JSONEncode, 
  game.HttpService.JSONDecode,
  game.HttpService.GenerateGUID
  local Request = syn and syn.request or request
  Request({
      Url = "http://127.0.0.1:6463/rpc?v=1",
      Method = "POST",
      Headers = {
          ["Content-Type"] = "application/json",
          ["Origin"] = "https://discord.com"
      },
      Body = JSONEncode(game.HttpService, {
          cmd = "INVITE_BROWSER",
          args = {
              code = "outliershub"
         },
         nonce = GenerateGUID(game.HttpService, false)
     }),
  })
end)
