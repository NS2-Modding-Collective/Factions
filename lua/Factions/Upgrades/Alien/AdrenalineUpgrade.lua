//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'AdrenalineUpgrade' (FactionsAlienUpgrade)

AdrenalineUpgrade.cost 				= { 250 }                          	// cost of the upgrade in xp
AdrenalineUpgrade.upgradeName		= "adrenaline"	                        // text code of the upgrade if using it via console
AdrenalineUpgrade.upgradeTitle 		= "Adrenaline"       					// Title of the upgrade, e.g. Submachine Gun
AdrenalineUpgrade.upgradeDesc 		= "Get Adrenaline"             		// Description of the upgrade
AdrenalineUpgrade.upgradeTechId 		= kTechId.Adrenaline  				// techId of the upgrade, default is kTechId.Move cause its the first 

function AdrenalineUpgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.cost = AdrenalineUpgrade.cost
	self.upgradeName = AdrenalineUpgrade.upgradeName
	self.upgradeTitle = AdrenalineUpgrade.upgradeTitle
	self.upgradeDesc = AdrenalineUpgrade.upgradeDesc
	self.upgradeTechId = AdrenalineUpgrade.upgradeTechId
	
end

function AdrenalineUpgrade:GetClassName()
	return "AdrenalineUpgrade"
end