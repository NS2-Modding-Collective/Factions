//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'UnlockGrenadeLauncherUpgrade' (FactionsUnlockUpgrade)

// Define these statically so we can easily access them without instantiating.
UnlockGrenadeLauncherUpgrade.upgradeType 		= kFactionsUpgradeTypes.Weapon        						// the type of the upgrade
UnlockGrenadeLauncherUpgrade.cost				= { 500 }                          							// cost of the upgrade in xp
UnlockGrenadeLauncherUpgrade.upgradeName 		= "unlockgl"	                        					// text code of the upgrade if using it via console
UnlockGrenadeLauncherUpgrade.upgradeTitle 		= "Unlock Grenade Launcher"       							// Title of the upgrade, e.g. Submachine Gun
UnlockGrenadeLauncherUpgrade.upgradeDesc 		= "Unlock the grenade launcher!"  							// Description of the upgrade
UnlockGrenadeLauncherUpgrade.upgradeTechId		= kTechId.GrenadeLauncher 	 		    					// TechId of the upgrade, default is kTechId.Move cause its the first entry


function UnlockGrenadeLauncherUpgrade:Initialize()

	FactionsUnlockUpgrade.Initialize(self)
	
	self.upgradeType = UnlockGrenadeLauncherUpgrade.upgradeType
	self.cost = UnlockGrenadeLauncherUpgrade.cost
	self.upgradeName = UnlockGrenadeLauncherUpgrade.upgradeName
	self.upgradeTitle = UnlockGrenadeLauncherUpgrade.upgradeTitle
	self.upgradeDesc = UnlockGrenadeLauncherUpgrade.upgradeDesc
	self.upgradeTechId = UnlockGrenadeLauncherUpgrade.upgradeTechId
	
end

function UnlockGrenadeLauncherUpgrade:GetClassName()
	return "UnlockGrenadeLauncherUpgrade"
end

function UnlockGrenadeLauncherUpgrade:GetUnlockUpgradeId()
	return kFactionsUpgrade.GrenadeLauncherUpgrade
end