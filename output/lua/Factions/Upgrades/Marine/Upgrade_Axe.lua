//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// AxeUpgrade.lua
						
class 'AxeUpgrade' (FactionsWeaponUpgrade)

AxeUpgrade.cost			= { 100 }                           				// Cost of the upgrade in xp
AxeUpgrade.upgradeName 	= "axe"                       						// Text code of the upgrade if using it via console
AxeUpgrade.upgradeTitle	= "Axe"               								// Title of the upgrade, e.g. Submachine Gun
AxeUpgrade.upgradeDesc 	= "Axe things"										// Description of the upgrade
AxeUpgrade.upgradeTechId = kTechId.Axe 	    								// TechId of the upgrade, default is kTechId.Move cause its the first entry
AxeUpgrade.hudSlot		= kAxeHUDSlot										// Is this a primary weapon?

function AxeUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.hideUpgrade = true
	self.cost = AxeUpgrade.cost
	self.upgradeName = AxeUpgrade.upgradeName
	self.upgradeTitle = AxeUpgrade.upgradeTitle
	self.upgradeDesc = AxeUpgrade.upgradeDesc
	self.upgradeTechId = AxeUpgrade.upgradeTechId
	self.hudSlot = AxeUpgrade.hudSlot
	
end

function AxeUpgrade:GetClassName()
	return "AxeUpgrade"
end