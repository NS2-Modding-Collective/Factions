//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// RailgunUpgrade.lua
						
class 'RailgunUpgrade' (FactionsWeaponUpgrade)

RailgunUpgrade.cost 			= { 1 }                           											// Cost of the upgrade in xp
RailgunUpgrade.upgradeName 		= "railgun"                       											// Text code of the upgrade if using it via console
RailgunUpgrade.upgradeTitle 	= "Railgun"               													// Title of the upgrade, e.g. Submachine Gun
RailgunUpgrade.upgradeDesc 		= "Kapow!"																	// Description of the upgrade
RailgunUpgrade.upgradeTechId 	= kTechId.HandheldRailgun  													// TechId of the upgrade, default is kTechId.Move cause its the first entry
RailgunUpgrade.hudSlot		 	= kPrimaryWeaponSlot														// Is this a primary weapon?

function RailgunUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.hideUpgrade = true
	self.cost = RailgunUpgrade.cost
	self.upgradeName = RailgunUpgrade.upgradeName
	self.upgradeTitle = RailgunUpgrade.upgradeTitle
	self.upgradeDesc = RailgunUpgrade.upgradeDesc
	self.upgradeTechId = RailgunUpgrade.upgradeTechId
	self.hudSlot = RailgunUpgrade.hudSlot
	
end

function RailgunUpgrade:GetClassName()
	return "RailgunUpgrade"
end