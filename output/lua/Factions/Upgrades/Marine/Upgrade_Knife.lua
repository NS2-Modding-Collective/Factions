//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// Upgrade_Knife.lua
						
class 'KnifeUpgrade' (FactionsWeaponUpgrade)

KnifeUpgrade.cost 			= { 250 }                           							// Cost of the upgrade in xp
KnifeUpgrade.upgradeName 	= "knife"                       								// Text code of the upgrade if using it via console
KnifeUpgrade.upgradeTitle 	= "Knife"               										// Title of the upgrade, e.g. Submachine Gun
KnifeUpgrade.upgradeDesc 	= "Default Scout weapon... Stabby!"								// Description of the upgrade
KnifeUpgrade.upgradeTechId 	= kTechId.Knife 		    									// TechId of the upgrade, default is kTechId.Move cause its the first entry
KnifeUpgrade.hudSlot 		= kAxeHUDSlot													// Is this a primary weapon?

function KnifeUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = KnifeUpgrade.cost
	self.upgradeName = KnifeUpgrade.upgradeName
	self.upgradeTitle = KnifeUpgrade.upgradeTitle
	self.upgradeDesc = KnifeUpgrade.upgradeDesc
	self.upgradeTechId = KnifeUpgrade.upgradeTechId
	self.hudSlot = KnifeUpgrade.hudSlot
	
end

function KnifeUpgrade:GetClassName()
	return "KnifeUpgrade"
end