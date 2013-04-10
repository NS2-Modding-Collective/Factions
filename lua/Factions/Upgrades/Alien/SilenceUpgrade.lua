//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'SilenceUpgrade' (FactionsAlienUpgrade)

SilenceUpgrade.cost 				= { 250 }                          	// cost of the upgrade in xp
SilenceUpgrade.upgradeName		= "silence"	                        // text code of the upgrade if using it via console
SilenceUpgrade.upgradeTitle 		= "Silence"       					// Title of the upgrade, e.g. Submachine Gun
SilenceUpgrade.upgradeDesc 		= "Get silence"             		// Description of the upgrade
SilenceUpgrade.upgradeTechId 		= kTechId.Silence  				// techId of the upgrade, default is kTechId.Move cause its the first 

function SilenceUpgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.cost = SilenceUpgrade.cost
	self.upgradeName = SilenceUpgrade.upgradeName
	self.upgradeTitle = SilenceUpgrade.upgradeTitle
	self.upgradeDesc = SilenceUpgrade.upgradeDesc
	self.upgradeTechId = SilenceUpgrade.upgradeTechId
	
end

function SilenceUpgrade:GetClassName()
	return "SilenceUpgrade"
end