local LocalPlayer = game.Players.LocalPlayer
local Backpack = LocalPlayer.Backpack
local Mouse = LocalPlayer:GetMouse()

local api = {}

if not getgenv().APIranbefore then getgenv().APIranbefore = true; warn("\n This API might not work anymore and has limited features.\n You can update the repo yourself at https://raw.githubusercontent.com/snnwer/roblox-other/main/pc-store-simulator/api.lua\n") end

api.LocalPlayer = LocalPlayer
api.Backpack = Backpack
api.Mouse = Mouse

function api:Delete(instance): boolean
    if not instance then return false end
    Backpack.nDelete:FireServer(instance)
    return true
end

function api:Edit(instance, value): boolean
    if not instance or not value then return false end
    Backpack.ChangeValue:FireServer(instance, value, "GBTU6FHG325V")
    return true
end

function api:Create(type, name, value, parent): boolean
    if not type or not value then return false end
    Backpack.ncreate:FireServer(type, name or type, value, parent or workspace)
    return true
end

function api:SetModelCFrame(model, cframe): boolean
    if not model or not cframe then return false end
    Backpack.setmodelcf:FireServer(model, cframe)
    return true
end

function api:SetAnchored(instance, bool): boolean
    if not instance then return false end
    Backpack.nAnchor:FireServer(instance, bool or false, "F08ANBN7bvnV")
    return true
end

function api:Clone(child, parent): boolean
	if not child or parent then return false end
    Backpack.nClone:FireServer(child, parent)
	return true
end

return api