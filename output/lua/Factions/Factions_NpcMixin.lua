//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_NpcMixin.lua

function NpcMixin:SetBaseDifficulty()
	if self.baseDifficulty then
		if HasMixin(self, "Xp") then
			self:SetLevel()
		end
	end
end

function NpcMixin:ApplyNpcUpgrades()
	if self.npcUpgrades then
	end
end