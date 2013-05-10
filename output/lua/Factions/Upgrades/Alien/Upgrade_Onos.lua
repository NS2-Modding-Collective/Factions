//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// OnosUpgrade is applied before anything else
						
class 'OnosUpgrade' (AlienClassUpgrade)

OnosUpgrade.cost 				= { 1000 }                          	// cost of the upgrade in xp
OnosUpgrade.upgradeName		= "onos"	                        // text code of the upgrade if using it via console
OnosUpgrade.upgradeTitle 		= "Onos"       					// Title of the upgrade, e.g. Submachine Gun
OnosUpgrade.upgradeDesc 		= "Evolve into an ONOS!!!"             		// Description of the upgrade
OnosUpgrade.upgradeTechId 		= kTechId.Onos  				// techId of the upgrade, default is kTechId.Move cause its the first 

function OnosUpgrade:Initialize()

	AlienClassUpgrade.Initialize(self)
	
	self.cost = OnosUpgrade.cost
	self.upgradeName = OnosUpgrade.upgradeName
	self.upgradeTitle = OnosUpgrade.upgradeTitle
	self.upgradeDesc = OnosUpgrade.upgradeDesc
	self.upgradeTechId = OnosUpgrade.upgradeTechId
	
end

function OnosUpgrade:GetClassName()
	return "OnosUpgrade"
end