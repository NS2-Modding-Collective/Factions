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

RailgunUpgrade.cost 			= { 100 }                           										// Cost of the upgrade in xp
RailgunUpgrade.upgradeName 		= "railgun"                       											// Text code of the upgrade if using it via console
RailgunUpgrade.upgradeTitle 	= "Railgun"               													// Title of the upgrade, e.g. Submachine Gun
RailgunUpgrade.upgradeDesc 		= "Kapow!"																	// Description of the upgrade
RailgunUpgrade.upgradeTechId 	= { kTechId.Railgun }    													// TechId of the upgrade, default is kTechId.Move cause its the first entry
RailgunUpgrade.primaryWeapon 	= true																		// Is this a primary weapon?

function RailgunUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = RailgunUpgrade.cost
	self.upgradeName = RailgunUpgrade.upgradeName
	self.upgradeTitle = RailgunUpgrade.upgradeTitle
	self.upgradeDesc = RailgunUpgrade.upgradeDesc
	self.upgradeTechId = RailgunUpgrade.upgradeTechId
	self.primaryWeapon = RailgunUpgrade.primaryWeapon
	
end

function RailgunUpgrade:GetClassName()
	return "RailgunUpgrade"
end