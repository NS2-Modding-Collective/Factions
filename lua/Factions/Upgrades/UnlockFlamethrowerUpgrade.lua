//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'UnlockFlamethrowerUpgrade' (FactionsUnlockUpgrade)

// Define these statically so we can easily access them without instantiating.
UnlockFlamethrowerUpgrade.cost				= { 500 }                          							// cost of the upgrade in xp
UnlockFlamethrowerUpgrade.upgradeName 		= "unlockflamer"	                        				// text code of the upgrade if using it via console
UnlockFlamethrowerUpgrade.upgradeTitle 		= "Unlock Flamethrower"       								// Title of the upgrade, e.g. Submachine Gun
UnlockFlamethrowerUpgrade.upgradeDesc 		= "Unlock the flame thrower!"  								// Description of the upgrade
UnlockFlamethrowerUpgrade.upgradeTechId		= kTechId.Flamethrower 	 		    						// TechId of the upgrade, default is kTechId.Move cause its the first entry

function UnlockFlamethrowerUpgrade:Initialize()

	FactionsUnlockUpgrade.Initialize(self)
	
	self.cost = UnlockFlamethrowerUpgrade.cost
	self.upgradeName = UnlockFlamethrowerUpgrade.upgradeName
	self.upgradeTitle = UnlockFlamethrowerUpgrade.upgradeTitle
	self.upgradeDesc = UnlockFlamethrowerUpgrade.upgradeDesc
	self.upgradeTechId = UnlockFlamethrowerUpgrade.upgradeTechId
	
end

function UnlockFlamethrowerUpgrade:GetClassName()
	return "UnlockFlamethrowerUpgrade"
end

function UnlockFlamethrowerUpgrade:GetUnlockUpgradeId()
	return kFactionsUpgrade.FlamethrowerUpgrade
end