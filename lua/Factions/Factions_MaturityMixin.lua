//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Factions_MaturityMixin.lua

// Give some XP to the damaging entity.
if Server then
	local overrideInitMixin = MaturityMixin.__initmixin
	function MaturityMixin:__initmixin()

		overrideInitMixin(self)
		self.startsMature = true
		self:SetMature(true)
		
	end
end