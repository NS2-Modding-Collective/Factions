//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_StaticTargetMixin.lua

Script.Load("lua/StaticTargetMixin.lua") 

local function setDecimalPlaces(num, idp)
    local mult = 10^(idp or 0)
    if num >= 0 then return math.floor(num * mult) / mult
    else return math.ceil(num * mult) / mult end
end

// Give some XP to the damaging entity.
if Server then
	function StaticTargetMixin:OnTakeDamage(damage, attacker, doer, point)

		// Give XP to attacker.
		local pointOwner = attacker
		
		// If the pointOwner is not a player, award it's points to it's owner.
		if pointOwner ~= nil and not HasMixin(pointOwner, "Scoring") and pointOwner.GetOwner then
			pointOwner = pointOwner:GetOwner()
		end
		
		// Give Xp for Players - only when on opposing sides.
		// to fix a bug, check before if the pointOwner is a Player
		if pointOwner and pointOwner:isa("Player") then
			if(pointOwner:GetTeamNumber() ~= self:GetTeamNumber()) then
				// Used to check whether an entity should deliver Xp on death or on damage
				if self:isa("Hive") or self:isa("CommandStation") or self:isa("Armory") then
					local maxXp = self:GetPointValue()
					local dmgXp = setDecimalPlaces(maxXp * damage / self:GetMaxHealth(), 1)
					
					// Award XP
					pointOwner:AddResources(dmgXp)
				end
			end
		end
		
	end
end