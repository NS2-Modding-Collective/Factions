//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'GrenadeLauncherUpgrade' (FactionsWeaponUpgrade)

// Define these statically so we can easily access them without instantiating.
GrenadeLauncherUpgrade.cost				= { 300 }                          							// cost of the upgrade in xp
GrenadeLauncherUpgrade.upgradeName 		= "gl"	                        							// text code of the upgrade if using it via console
GrenadeLauncherUpgrade.upgradeTitle 	= "Grenade Launcher"       									// Title of the upgrade, e.g. Submachine Gun
GrenadeLauncherUpgrade.upgradeDesc 		= "Launches grenades... What more do you need to know?"  	// Description of the upgrade
GrenadeLauncherUpgrade.upgradeTechId	= { kTechId.GrenadeLauncher } 		    					// TechId of the upgrade, default is kTechId.Move cause its the first entry
GrenadeLauncherUpgrade.requirements 	= { "UnlockGrenadeLauncherUpgrade" }						// Any requirements?
GrenadeLauncherUpgrade.primaryWeapon	= true														// Is this a primary weapon?

function GrenadeLauncherUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = GrenadeLauncherUpgrade.cost
	self.upgradeName = GrenadeLauncherUpgrade.upgradeName
	self.upgradeTitle = GrenadeLauncherUpgrade.upgradeTitle
	self.upgradeDesc = GrenadeLauncherUpgrade.upgradeDesc
	self.upgradeTechId = GrenadeLauncherUpgrade.upgradeTechId
	self.requirements = GrenadeLauncherUpgrade.requirements
	self.primaryWeapon = GrenadeLauncherUpgrade.primaryWeapon
	
end

function GrenadeLauncherUpgrade:GetClassName()
	return "GrenadeLauncherUpgrade"
end