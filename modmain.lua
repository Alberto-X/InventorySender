local slotsender = function(component)
	local Say = component.Say
	component.Say = function(self, script, time, noanim, force, nobroadcast, colour)
		Say(self, script, time, noanim, force, nobroadcast, colour)
		local lines = type(script) == "string" and { GLOBAL.Line(script, noanim) } or script
		if lines ~= nil then
			for k, line in pairs(lines) do
				if string.find(line.message, "%-g%s%d+") ~= nil then
					local targetplayer = GLOBAL.tonumber(string.match(line.message, "%-g%s(%d+)"))
					self.task = self.inst:StartThread(function() GLOBAL.sendtoplayer(self.inst, targetplayer) end)
				end
			end
		end
	end
end

GLOBAL.sendtoplayer = function(from, target)
	local item = from.components.inventory:GetItemInSlot(15)
	if GLOBAL.AllPlayers[target] ~= nil and item ~= nil then
		GLOBAL.AllPlayers[target].components.inventory:GiveItem(from.components.inventory:RemoveItemBySlot(15))
	end
end

AddComponentPostInit("talker", slotsender)

--ListingOrConsolePlayer(player)