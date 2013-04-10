//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________
						
class 'InkUpgrade' (FactionsTimedUpgrade)

// Define these statically so we can easily access them without instantiating too.
InkUpgrade.cost = { 100, 200, 400 }                              					// Cost of the upgrade in xp
InkUpgrade.levels = 3																// How many levels are there to this upgrade
InkUpgrade.upgradeName = "ink"                     							// Text code of the upgrade if using it via console
InkUpgrade.upgradeTitle = "Resupply"               								// Title of the upgrade, e.g. Submachine Gun
InkUpgrade.upgradeDesc = "Periodically stock up on health and ammo"				// Description of the upgrade
InkUpgrade.upgradeTechId = kTechId.Ink										// TechId of the upgrade, default is kTechId.Move cause its the first entry
InkUpgrade.triggerInterval	= { 12, 10, 8 } 										// Specify the timer interval (in seconds) per level.
InkUpgrade.teamType	 	= kFactionsUpgradeTeamType.AlienTeam					// Team Type

function InkUpgrade:Initialize()

	FactionsUpgrade.Initialize(self)

	self.cost = InkUpgrade.cost
	self.levels = InkUpgrade.levels
	self.upgradeName = InkUpgrade.upgradeName
	self.upgradeTitle = InkUpgrade.upgradeTitle
	self.upgradeDesc = InkUpgrade.upgradeDesc
	self.upgradeTechId = InkUpgrade.upgradeTechId
	self.triggerInterval = InkUpgrade.triggerInterval
	self.teamType = InkUpgrade.teamType
	
end

function InkUpgrade:GetClassName()
	return "InkUpgrade"
end

function InkUpgrade:GetTimerDescription()
	return "Ink will be available every "
end

local function InkAvailable(player)

end

function InkUpgrade:OnAdd(player)
	FactionsTimedUpgrade.OnAdd(self, player)
	
	InkAvailable(player)
end

function InkUpgrade:OnTrigger(player)
	if player and HasMixin(player, "Ink") then
		InkAvailable(player)
	end
end