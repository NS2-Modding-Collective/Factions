//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// ShotgunUpgrade.lua
						
class 'ShotgunUpgrade' (FactionsWeaponUpgrade)

ShotgunUpgrade.cost 			= { 150 }                          							// Cost of the upgrade in xp
ShotgunUpgrade.upgradeName 		= "shotgun"	                        						// Text code of the upgrade if using it via console
ShotgunUpgrade.upgradeTitle 	= "Shotgun"       											// Title of the upgrade, e.g. Submachine Gun
ShotgunUpgrade.upgradeDesc 		= "Does high damage at close range, contains 5 shells."		// Description of the upgrade
ShotgunUpgrade.upgradeTechId 	= { kTechId.Shotgun } 		    							// TechId of the upgrade, default is kTechId.Move cause its the first entry
ShotgunUpgrade.primaryWeapon 	= true														// Is this a primary weapon?

function MinesUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = ShotgunUpgrade.cost
	self.upgradeName = ShotgunUpgrade.upgradeName
	self.upgradeTitle = ShotgunUpgrade.upgradeTitle
	self.upgradeDesc = ShotgunUpgrade.upgradeDesc
	self.upgradeTechId = ShotgunUpgrade.upgradeTechId
	self.primaryWeapon = ShotgunUpgrade.primaryWeapon
	
end

function ShotgunUpgrade:GetClassName()
	return "ShotgunUpgrade"
end