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
function LiveMixin:Kill(attacker, doer, point, direction)
	
	if GetGamerulesInfo():GetMarinesBecomeInjured() and self:isa("Marine") and not self:isa("InjuredPlayer") and not self:isa("MarineSpectator") then
		self:SendDirectMessage("You are injured! Call for your teammates to help!")
		self:Replace(InjuredPlayer.kMapName, self:GetTeamNumber(), false, self:GetOrigin())
	else
		originalKill(self, attacker, doer, point, direction)
	end

end