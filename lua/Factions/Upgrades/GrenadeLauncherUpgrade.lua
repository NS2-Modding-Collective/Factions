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

function GrenadeLauncherUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = { 300 }                          								// cost of the upgrade in xp
	self.upgradeName = "gl"	                        							// text code of the upgrade if using it via console
	self.upgradeTitle = "Grenade Launcher"       								// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "Launches grenades... What more do you need to know?"  	// Description of the upgrade
	self.upgradeTechId = { kTechId.GrenadeLauncher } 		    				// TechId of the upgrade, default is kTechId.Move cause its the first entry
	self.primaryWeapon = true													// Is this a primary weapon?
	
end

function GrenadeLauncherUpgrade:GetClassName()
	return "GrenadeLauncherUpgrade"
end