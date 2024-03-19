local esp = {cache = {} };
local Camera = workspace.CurrentCamera
local Player = game.Players.LocalPlayer

function esp:unload()
  for i,v in next, esp.cache do
    esp.remove_plr(i)
  end
end
function esp.rotatev2(V2, r)
  local c = math.math.cos(r);
  local s = math.math.sin(r);
  return Vector2.new(c * V2.X - s * V2.Y, s * V2.X + c * V2.Y);
end;

function esp.getmagnitude(p1,p2)
  return (p1 - p2).Magnitude
end;

function esp.getprimarypart(model)
  local found_part = model ~= nil and model:FindFirstChild('HumanoidRootPart')
  return found_part
end;

function esp.inst(instance,prop)
  local INEW = Instance.new(instance)
  local s, e  = pcall(function()
    for i,v in next, prop do
      INEW[i] = v
    end
  end)
  return INEW
end;

function esp.draw(drawing,prop)
  local NEWDRAWING = Drawing.new(drawing)
  local s, e = pcall(function()
    for i,v in next, prop do
      NEWDRAWING[i] = v
    end
  end)
  return NEWDRAWING
end;

function esp.setall(array,prop,value)
  for i,v in next, array do
    if tostring(v) ~= 'Highlight' and tostring(i) ~= 'arrow' and tostring(i) ~= 'arrow_outline' then
      v[prop] = value
    end
  end
end;

function esp.remove_plr(character)
  if rawget(esp.cache,character) then
    for _,v in pairs(esp.cache[character]) do
      v:Remove()
    end;
    esp.cache[character] = nil;
  end;
end;

function esp.check(handler, character)
  if character.Parent ~= workspace then return false end

  local plr = handler.Functions.getPlayerFromCharacter(character)

  if not plr then return false end
  local plr_team = handler.Functions.getTeam(plr)
  local client_team = handler.Functions.getTeam(Player)

  if plr_team == client_team then return false end
  if not handler.Functions.isAlive(plr) then return false end
  if handler.Functions.getHealth(plr) <= 0 then return false end

  return true
end;

function esp.add_plr(character)
  local plr_tab = {}
  plr_tab.inner_box = esp.draw('Square',{
    Filled = true,
  });
  plr_tab.tracer = esp.draw('Line',{
    Thickness = 1,
  });
  plr_tab.box_outline = esp.draw('Square',{
    Filled = false,
    Transparency = 1,
    Thickness = 3,
  });
  plr_tab.box = esp.draw('Square',{
    Filled = false,
    Transparency = 1,
    Thickness = 1,
  });
  plr_tab.name_bold = esp.draw('Text',{
    Center = true,
    Outline = false,
    Transparency = 1,
  });
  plr_tab.distance = esp.draw('Text',{
    Center = true,
  });
  plr_tab.highlight = esp.inst('Highlight',{
  });
  plr_tab.health = esp.draw('Text',{
    Center = false,
  });
  plr_tab.healthbar_outline = esp.draw('Line',{
    Thickness = 3,
  });
  plr_tab.healthbar = esp.draw('Line',{
    Thickness = 1,
  });
  plr_tab.name = esp.draw('Text',{
    Center = true,
  });
  plr_tab.highlight = esp.inst('Highlight',{
  });
  esp.cache[character] = plr_tab;
end

function esp.update_esp(handler, character, array)
  local rootpart = character:FindFirstChild('HumanoidRootPart')
  local player = handler.Functions.getPlayerFromCharacter(character)

  local screenpos, onscreen = Camera.WorldToViewportPoint(Camera, rootpart.Position)
  local health = player and handler.Functions.getHealth(player) or 100
  
  local scale_factor = 1 / (screenpos.Z * math.tan(math.rad(Camera.FieldOfView * 0.5)) * 2) * 100
  local width, height = math.floor(45 * scale_factor), math.floor(65 * scale_factor)
  local size = Vector2.new(width,height)

  if size.X < 3 or size.Y < 6 then
    size = Vector2.new(5,10)
  end

  local position = Vector2.new(math.floor(screenpos.X - size.X / 2), math.floor(screenpos.Y - size.Y / 2))
  local bottom_offset = Vector2.new(math.floor(size.X / 2 + position.X), math.floor(size.Y + position.Y + 1))
  local top_offset = Vector2.new(math.floor(size.X / 2 + position.X), math.floor(position.Y - 16))

  local bottom_bounds = 0
  local top_bounds = 0

  local check = esp.check(handler, character)

  if onscreen and check then
    if handler.ESP.Tracers and handler.ESP.Enabled then
      array.tracer.Visible = true
      array.tracer.From = Vector2.new(screenpos.X, screenpos.Y) + Vector2.new(0, size.Y / 2)
      array.tracer.To = Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/handler.ESP.TracerAttachShift or 1)
      array.tracer.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.TracerColor
    else
      array.tracer.Visible = false
    end
    if handler.ESP.Chams and handler.ESP.Enabled and health > 0 then
      array.highlight.Parent = CoreGui
      array.highlight.Adornee = character
      array.highlight.Enabled = true
      array.highlight.DepthMode = handler.ESP.Chams_Visible_Check and Enum.HighlightDepthMode.Occluded or Enum.HighlightDepthMode.AlwaysOnTop
      array.highlight.FillTransparency = handler.ESP.ChamsFillTransparency
      array.highlight.OutlineTransparency = handler.ESP.ChamsOutlineTransparency
      if handler.ESP.Highlight_Target and handler.Functions.isVisible(rootpart.Position) then
        array.highlight.FillColor = Color3.fromRGB(0,255,0)
        array.highlight.OutlineColor = Color3.fromRGB(0,255,0)
      else
        array.highlight.FillColor = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.ChamsFillColor
        array.highlight.OutlineColor = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.ChamsOutlineColor
      end
    else
      array.highlight.Enabled = false
    end
    if handler.ESP.Boxes and handler.ESP.Enabled then
      array.box.Visible = true
      array.box.Size = size
      array.box.Position = position
      array.box.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.BoxColor
      array.box_outline.Size = size
      array.box_outline.Position = position
      array.box_outline.Visible = false
      array.box_outline.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.BoxColor
      array.inner_box.Size = Vector2.new(array.box.Size.X - 3,array.box.Size.Y - 3)
      array.inner_box.Position = Vector2.new(position.X+1.5,position.Y+1.5)
      array.inner_box.Transparency = 0.5
      array.inner_box.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.BoxColor
      array.inner_box.Visible = false
    else
      array.box.Visible = false
    end
    if handler.ESP.HealthBar and handler.ESP.Enabled then
      array.healthbar.Transparency = 1
      array.healthbar_outline.Transparency = 1
      array.healthbar.Visible = true
      array.healthbar.Color = Color3.fromRGB(255,0,0):Lerp(Color3.fromRGB(0,255,0),health / 100);
      array.healthbar.From = Vector2.new((position.X - 5), position.Y + size.Y)
      array.healthbar.To = Vector2.new(array.healthbar.From.X, array.healthbar.From.Y - (health / 100) * size.Y)
      array.healthbar_outline.Visible = false
      array.healthbar_outline.Color = Color3.fromRGB(255,255,255)
      array.healthbar_outline.From = Vector2.new(array.healthbar.From.X, position.Y + size.Y + 1 )
      array.healthbar_outline.To = Vector2.new(array.healthbar.From.X, (array.healthbar.From.Y -1 * size.Y) - 1)
    else
      array.healthbar.Visible = false
      array.healthbar_outline.Visible = false
    end
    if handler.ESP.Names and handler.ESP.Enabled then
      array.name.Transparency = 1
      array.name_bold.Transparency = 0.5
      array.name.Visible = true
      array.name.Text = tostring(player)
      array.name.Size = handler.ESP.FontSize
      array.name.Font = 2
      --if esp.highlight_target.enabled and esp.highlight_target.target == tostring(character) then
      --    array.name.Color = esp.highlight_target.color
      --else
        array.name.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.TextColor
      --end
      array.name.Outline = false
      array.name.OutlineColor = Color3.fromRGB(255,255,255)
      array.name.Position = Vector2.new(top_offset.X,top_offset.Y - (top_bounds))
    else
      array.name.Visible = false
      array.name_bold.Visible = false
    end
    if handler.ESP.Health and handler.ESP.Enabled then
      local From = Vector2.new((position.X - 5), position.Y + size.Y)
      local To = Vector2.new(From.X, From.Y - 1 * size.Y)
      array.health.Transparency = 1
      array.health.Visible = true
      array.health.Text = tostring(math.floor(health))
      array.health.Size = handler.ESP.FontSize
      array.health.Font = 2
      array.health.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.TextColor
      array.health.Outline = false
      array.health.OutlineColor = Color3.fromRGB(255,255,255)
      array.health.Position = Vector2.new(position.X - 30, To.Y)
    else
      array.health.Visible = false
    end
    if handler.ESP.Distance and handler.ESP.Enabled then
      local distance = esp.getmagnitude(rootpart.Position, Camera.CFrame.Position)

      array.distance.Transparency = 1
      array.distance.Visible = true
      array.distance.Text = tostring(math.floor(distance))..'s'
      array.distance.Size = handler.ESP.FontSize
      array.distance.Font = 2
      array.distance.Color = (handler.ESP.Rainbow and Color3.fromHSV(tick() % 5 / 5, 1 + 0, 1)) or handler.ESP.TextColor
      array.distance.Outline = false
      array.distance.OutlineColor = Color3.fromRGB(255,255,255)
      array.distance.Position = Vector2.new(bottom_offset.X, bottom_offset.Y + bottom_bounds)
      bottom_bounds += 14
    else
      array.distance.Visible = false
    end
  else
    esp.setall(array, 'Visible', false)
  end
  if not success and error then
    esp.setall(array, 'Visible', false)
    array.highlight.Enabled = false
  end
end

return esp
