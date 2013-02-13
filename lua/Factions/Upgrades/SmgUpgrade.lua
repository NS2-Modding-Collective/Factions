//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'SMGUpgrade' (FactionsUpgrade)

SMGUpgrade.upgradeType = kUpgradeTypes.Weapon       	// see combat_UpgradeUtility, the type of the upgrade
SMGUpgrade.cost = 30                              		// cost of the upgrade in xp
SMGUpgrade.upgradeName = "smg"                       	// text code of the upgrade if using it via console
SMGUpgrade.upgradeTitle = "Submachine Gun"               // Title of the upgrade, e.g. Submachine Gun
SMGUpgrade.upgradeDesc = "Submachine Gun"               // discription of the upgrade
SMGUpgrade.upgradeTechId =  kTechId.LightMachineGun     // techId of the upgrade, default is kTechId.Move cause its the first entry

