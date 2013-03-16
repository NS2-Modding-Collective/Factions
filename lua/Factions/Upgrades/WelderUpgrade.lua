//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'WelderUpgrade' (FactionsWeaponUpgrade)

function WelderUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = { 50 }                           								// Cost of the upgrade in xp
	self.upgradeName = "welder"                       							// Text code of the upgrade if using it via console
	self.upgradeTitle = "Welder"               									// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "Weld stuff"												// Description of the upgrade
	self.upgradeTechId = { kTechId.Welder }    									// TechId of the upgrade, default is kTechId.Move cause its the first entry
	self.primaryWeapon = true													// Is this a primary weapon?
	
end

function WelderUpgrade:GetClassName()
	return "WelderUpgrade"
end