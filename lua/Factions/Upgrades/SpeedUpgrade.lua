//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'SpeedUpgrade' (FactionsUpgrade)

// Define these statically so we can easily access them without instantiating too.
SpeedUpgrade.cost = { 50, 100, 150 }                              					// Cost of the upgrade in xp
SpeedUpgrade.levels = 3																// How many levels are there to this upgrade
SpeedUpgrade.upgradeName = "speed"                     								// Text code of the upgrade if using it via console
SpeedUpgrade.upgradeTitle = "Speed Upgrade"               							// Title of the upgrade, e.g. Submachine Gun
SpeedUpgrade.upgradeDesc = "Upgrade your player's speed"							// Description of the upgrade
SpeedUpgrade.upgradeTechId = { kTechId.Speed1, kTechId.Speed2, kTechId.Speed3 }		// TechId of the upgrade, default is kTechId.Move cause its the first entry

function SpeedUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = SpeedUpgrade.cost
	self.levels = SpeedUpgrade.levels
	self.upgradeName = SpeedUpgrade.upgradeName
	self.upgradeTitle = SpeedUpgrade.upgradeTitle
	self.upgradeDesc = SpeedUpgrade.upgradeDesc
	self.upgradeTechId = SpeedUpgrade.upgradeTechId
	
end

function SpeedUpgrade:GetClassName()
	return "SpeedUpgrade"
end

function SpeedUpgrade:OnAdd(player)
	if player:HasMixin("SpeedUpgrade") then
		player.upgradeSpeedLevel = self:GetCurrentLevel()
	end
end