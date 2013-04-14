//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'FlamethrowerUpgrade' (FactionsWeaponUpgrade)

// Define these statically so we can easily access them without instantiating.
FlamethrowerUpgrade.cost				= { 300 }                          							// cost of the upgrade in xp
FlamethrowerUpgrade.upgradeName 		= "flamer"			                        				// text code of the upgrade if using it via console
FlamethrowerUpgrade.upgradeTitle 		= "Flamethrower"       										// Title of the upgrade, e.g. Submachine Gun
FlamethrowerUpgrade.upgradeDesc 		= "Come on baby light my fire"  							// Description of the upgrade
FlamethrowerUpgrade.upgradeTechId		= kTechId.Flamethrower 		    							// TechId of the upgrade, default is kTechId.Move cause its the first entry
FlamethrowerUpgrade.requirements 		= { "UnlockFlamethrowerUpgrade" }							// Any requirements?
FlamethrowerUpgrade.primaryWeapon		= true														// Is this a primary weapon?

function FlamethrowerUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = FlamethrowerUpgrade.cost
	self.upgradeName = FlamethrowerUpgrade.upgradeName
	self.upgradeTitle = FlamethrowerUpgrade.upgradeTitle
	self.upgradeDesc = FlamethrowerUpgrade.upgradeDesc
	self.upgradeTechId = FlamethrowerUpgrade.upgradeTechId
	self.requirements = FlamethrowerUpgrade.requirements
	self.primaryWeapon = FlamethrowerUpgrade.primaryWeapon
	
end

function FlamethrowerUpgrade:GetClassName()
	return "FlamethrowerUpgrade"
end