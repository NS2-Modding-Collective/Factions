//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// MineUpgrade file, weapons will be added directly after upgrading, so nothing to do here
						
class 'LaserMinesUpgrade' (FactionsWeaponUpgrade)

LaserMinesUpgrade.cost 				= { 400 }                          	// cost of the upgrade in xp
LaserMinesUpgrade.upgradeName		= "lasermines"	                    // text code of the upgrade if using it via console
LaserMinesUpgrade.upgradeTitle 		= "Laser Mines"       				// Title of the upgrade, e.g. Submachine Gun
LaserMinesUpgrade.upgradeDesc 		= "Get some Laser Mines"            // Description of the upgrade
LaserMinesUpgrade.upgradeTechId 	= kTechId.LayLaserMines  			// techId of the upgrade, default is kTechId.Move cause its the first entry
LaserMinesUpgrade.hudSlot		 	= kMinesHUDSlot						// Is this a primary weapon?
LaserMinesUpgrade.permanent			= false

function LaserMinesUpgrade:Initialize()

	FactionsWeaponUpgrade.Initialize(self)
	
	self.cost = LaserMinesUpgrade.cost
	self.upgradeName = LaserMinesUpgrade.upgradeName
	self.upgradeTitle = LaserMinesUpgrade.upgradeTitle
	self.upgradeDesc = LaserMinesUpgrade.upgradeDesc
	self.upgradeTechId = LaserMinesUpgrade.upgradeTechId
	self.hudSlot = LaserMinesUpgrade.hudSlot
	self.permanent = LaserMinesUpgrade.permanent
	
end

function LaserMinesUpgrade:GetClassName()
	return "LaserMinesUpgrade"
end

function LaserMinesUpgrade:SendAddMessage(player)
	player:SendDirectMessage("You bought " .. self:GetUpgradeTitle() .. "!")
end