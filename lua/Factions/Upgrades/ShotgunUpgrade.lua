//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'ShotgunUpgrade' (FactionsWeaponUpgrade)

function MinesUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = { 150 }                          								// Cost of the upgrade in xp
	self.upgradeName = "shotgun"	                        					// Text code of the upgrade if using it via console
	self.upgradeTitle = "Shotgun"       										// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "Does high damage at close range, contains 5 shells."	// Description of the upgrade
	self.upgradeTechId = { kTechId.Shotgun } 		    						// TechId of the upgrade, default is kTechId.Move cause its the first entry
	self.primaryWeapon = true													// Is this a primary weapon?
	
end

function ShotgunUpgrade:GetClassName()
	return "ShotgunUpgrade"
end