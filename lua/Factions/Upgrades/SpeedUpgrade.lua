//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'SpeedUpgrade' (FactionsUpgrade)

function SpeedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = { 50, 100, 150 }                              							// Cost of the upgrade in xp
	self.levels = 3																		// How many levels are there to this upgrade
	self.upgradeName = "speed"                     										// Text code of the upgrade if using it via console
	self.upgradeTitle = "Speed Upgrade"               									// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "Upgrade your player's speed"									// Description of the upgrade
	self.upgradeTechId = { kTechId.Speed1, kTechId.Speed2, kTechId.Speed3 }				// TechId of the upgrade, default is kTechId.Move cause its the first entry
	
end

function SpeedUpgrade:GetClassName()
	return "SpeedUpgrade"
end

function SpeedUpgrade:OnAdd(player)
	if player:HasMixin("SpeedUpgrade") then
		player.upgradeSpeedLevel = self:GetCurrentLevel()
	end
end