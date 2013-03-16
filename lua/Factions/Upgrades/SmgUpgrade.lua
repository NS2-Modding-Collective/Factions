//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'SMGUpgrade' (FactionsWeaponUpgrade)

function SMGUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = { 50 }                           											// Cost of the upgrade in xp
	self.upgradeName = "smg"                       											// Text code of the upgrade if using it via console
	self.upgradeTitle = "Submachine Gun"               										// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "Rapid firing, mini version of the rifle. Great at medium range."	// Description of the upgrade
	self.upgradeTechId = { kTechId.LightMachineGun }    									// TechId of the upgrade, default is kTechId.Move cause its the first entry
	self.primaryWeapon = true																// Is this a primary weapon?
	
end

function SMGUpgrade:GetClassName()
	return "SMGUpgrade"
end