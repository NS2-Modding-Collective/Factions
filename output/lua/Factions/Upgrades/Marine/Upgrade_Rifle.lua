//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// RifleUpgrade.lua
						
class 'RifleUpgrade' (FactionsWeaponUpgrade)

RifleUpgrade.cost 				= { 500 }                           							// Cost of the upgrade in xp
RifleUpgrade.upgradeName 		= "rifle"                       								// Text code of the upgrade if using it via console
RifleUpgrade.upgradeTitle 		= "Rifle"               										// Title of the upgrade, e.g. Submachine Gun
RifleUpgrade.upgradeDesc 		= "There are many others like it, but this one is mine."		// Description of the upgrade
RifleUpgrade.upgradeTechId 		= kTechId.Rifle 	    										// TechId of the upgrade, default is kTechId.Move cause its the first entry
RifleUpgrade.hudSlot 			= kPrimaryWeaponSlot											// Is this a primary weapon?

function RifleUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = RifleUpgrade.cost
	self.upgradeName = RifleUpgrade.upgradeName
	self.upgradeTitle = RifleUpgrade.upgradeTitle
	self.upgradeDesc = RifleUpgrade.upgradeDesc
	self.upgradeTechId = RifleUpgrade.upgradeTechId
	self.hudSlot = RifleUpgrade.hudSlot
	
end

function RifleUpgrade:GetClassName()
	return "RifleUpgrade"
end