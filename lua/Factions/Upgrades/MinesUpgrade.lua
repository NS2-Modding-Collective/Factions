//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'MinesUpgrade' (FactionsUpgrade)

MinesUpgrade.upgradeType = kUpgradeTypes.Weapon       // see combat_UpgradeUtility, the type of the upgrade
MinesUpgrade.cost = 60                                  // cost of the upgrade in xp
MinesUpgrade.upgradeName = "mines"                       // text code of the upgrade if using it via console
MinesUpgrade.upgradeDesc = "Mines"                // discription of the upgrade
MinesUpgrade.upgradeTechId =  kTechId.LayMines                 // techId of the upgrade, default is kTechId.Move cause its the first entry

