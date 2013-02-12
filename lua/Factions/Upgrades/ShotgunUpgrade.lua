//________________________________
//
//  Factions
//	Made by Jibrail, JimWest, Sewlek
//  Puschen and Winston Smith (MCMLXXXIV)
//  
//  Licensed under LGPL v3.0
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'ShotgunUpgrade' (FactionsUpgrade)

ShotgunUpgrade.upgradeType = kUpgradeTypes.Weapon       // see combat_UpgradeUtility, the type of the upgrade
ShotgunUpgrade.cost = 60                                  // cost of the upgrade in xp
ShotgunUpgrade.upgradeName = "shotgun"                       // text code of the upgrade if using it via console
ShotgunUpgrade.upgradeDesc = "Shotgun"                // discription of the upgrade
ShotgunUpgrade.upgradeTechId =  kTechId.Shotgun                // techId of the upgrade, default is kTechId.Move cause its the first entry

