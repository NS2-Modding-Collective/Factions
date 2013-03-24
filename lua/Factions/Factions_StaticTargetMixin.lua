//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_StaticTargetMixin.lua

// Give some XP to the damaging entity.
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
			if entity:isa("Hive") or entity:isa("CommandStation") or entity:isa("Armory") then
				local maxXp = GetXpValue(self)
				local dmgXp = setDecimalPlaces(maxXp * damage / self:GetMaxHealth(), 1)
				
				// Award XP
				pointOwner:AddXp(dmgXp)
			end
		end
	end
    
end