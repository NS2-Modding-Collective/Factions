//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'MinesUpgrade' (FactionsWeaponUpgrade)

MinesUpgrade.cost 				= { 100 }                          	// cost of the upgrade in xp
MinesUpgrade.upgradeName		= "mines"	                        // text code of the upgrade if using it via console
MinesUpgrade.upgradeTitle 		= "Mines"       					// Title of the upgrade, e.g. Submachine Gun
MinesUpgrade.upgradeDesc 		= "Get some Mines"             		// Description of the upgrade
MinesUpgrade.upgradeTechId 		= kTechId.LayMines  				// techId of the upgrade, default is kTechId.Move cause its the first entry
MinesUpgrade.primaryWeapon 		= false								// Is this a primary weapon?

function MinesUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = MinesUpgrade.cost
	self.upgradeName = MinesUpgrade.upgradeName
	self.upgradeTitle = MinesUpgrade.upgradeTitle
	self.upgradeDesc = MinesUpgrade.upgradeDesc
	self.upgradeTechId = MinesUpgrade.upgradeTechId
	self.primaryWeapon = MinesUpgrade.primaryWeapon
	
end

function MinesUpgrade:GetClassName()
	return "MinesUpgrade"
end

function MinesUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You bought " .. self:GetUpgradeTitle() .. "!")
end