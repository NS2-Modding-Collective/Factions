//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'RegenerationUpgrade' (FactionsAlienUpgrade)

RegenerationUpgrade.cost 				= { 250 }                          	// cost of the upgrade in xp
RegenerationUpgrade.upgradeName		= "regen"	                        // text code of the upgrade if using it via console
RegenerationUpgrade.upgradeTitle 		= "Regeneration"       					// Title of the upgrade, e.g. Submachine Gun
RegenerationUpgrade.upgradeDesc 		= "Get regeneration"             		// Description of the upgrade
RegenerationUpgrade.upgradeTechId 		= kTechId.Regeneration  				// techId of the upgrade, default is kTechId.Move cause its the first 

function RegenerationUpgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.cost = RegenerationUpgrade.cost
	self.upgradeName = RegenerationUpgrade.upgradeName
	self.upgradeTitle = RegenerationUpgrade.upgradeTitle
	self.upgradeDesc = RegenerationUpgrade.upgradeDesc
	self.upgradeTechId = RegenerationUpgrade.upgradeTechId
	
end

function RegenerationUpgrade:GetClassName()
	return "RegenerationUpgrade"
end