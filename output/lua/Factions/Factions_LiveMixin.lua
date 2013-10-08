//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_LiveMixin.lua

local originalKill = LiveMixin.Kill
function LiveMixin:Kill(attacker, doer, point, direction, force)
	
	if GetGamerulesInfo():GetMarinesBecomeInjured() 
		and self:isa("Marine") 
		and not HasMixin(self, "Npc") 
		and not self:isa("InjuredPlayer") 
		and not self:isa("MarineSpectator") 
		and not force then
		
		local killStraightAway = true
		local team = self:GetTeam()
		local teammates = team:GetPlayers()
		// Find out whether we have teammates who are alive
		for index, player in ipairs(teammates) do
			if self ~= player and not player:isa("InjuredPlayer") then
				killStraightAway = false
				break
			end
		end
		
		// Kill the player and all teammates if no one will be around to resurrect them
		if killStraightAway then
			local allTeamDeadMessage = "Your entire team has died... You will respawn back at base!"
			self:SendDirectMessage(allTeamDeadMessage)
			originalKill(self, attacker, doer, point, direction)
		
			for index, player in ipairs(teammates) do
				if player:GetIsAlive() then
					player:SendDirectMessage(allTeamDeadMessage)
					player:Kill(nil, nil, player:GetOrigin())
				end
			end
		else
			// Otherwise, let the player become injured.
			self:SendDirectMessage("You are injured! Call for your teammates to help!")
			self:Replace(InjuredPlayer.kMapName, self:GetTeamNumber(), false, self:GetOrigin())
		end
	else
		// For non-xenoswarm game mechanics, just die straight away like normal
		originalKill(self, attacker, doer, point, direction)
	end

end