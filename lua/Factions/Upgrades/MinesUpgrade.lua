//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'MinesUpgrade' (FactionsWeaponUpgrade)

function MinesUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = { 100 }                          			// cost of the upgrade in xp
	self.upgradeName = "mines"	                        	// text code of the upgrade if using it via console
	self.upgradeTitle = "Mines"       						// Title of the upgrade, e.g. Submachine Gun
	self.upgradeDesc = "Get some Mines"             		// Description of the upgrade
	self.upgradeTechId = { kTechId.LayMines } 				// techId of the upgrade, default is kTechId.Move cause its the first entry
	self.primaryWeapon = false								// Is this a primary weapon?
	
end

function MinesUpgrade:GetClassName()
	return "MinesUpgrade"
end