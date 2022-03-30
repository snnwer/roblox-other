local api = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua", true))() -- credits to vynixu

local inner = {}

inner.prompt = function(invite: string, name: string | nil)
	api.Prompt({
		invite, name
	})
end

inner.invite = function(invite: string)
	api.Join(invite)
end
	
return inner