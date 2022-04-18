local player = game.Players.LocalPlayer

local lib = {}

function lib:Copy(victim, number: number)
	if (victim == nil) or (number == nil) then return false end
	local tg = workspace.Plots[victim.Name].Easels[number].Canvas.SurfaceGui.Grid

	function copyGrid()
		local destination = player.PlayerGui.MainGui.PaintFrame.GridHolder.Grid

		for i = 1, 1024 do
			destination[i].BackgroundColor3 = tg[i].BackgroundColor3
			if #tg[i]:GetChildren() > 0 then
				for a,b in next, tg[i]:GetChildren() do
					b:Clone().Parent = destination[i]
				end
			end
		end
	end

	copyGrid()

end
return lib
