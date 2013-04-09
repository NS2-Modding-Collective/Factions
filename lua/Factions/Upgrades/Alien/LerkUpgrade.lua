//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// LerkUpgrade is applied before anything else
						
class 'LerkUpgrade' (AlienClassUpgrade)

LerkUpgrade.cost 				= { 350 }                          	// cost of the upgrade in xp
LerkUpgrade.upgradeName		= "lerk"	                        // text code of the upgrade if using it via console
LerkUpgrade.upgradeTitle 		= "Lerk"       					// Title of the upgrade, e.g. Submachine Gun
LerkUpgrade.upgradeDesc 		= "Evolve into a Lerk"             		// Description of the upgrade
LerkUpgrade.upgradeTechId 		= kTechId.Lerk  				// techId of the upgrade, default is kTechId.Move cause its the first 

function LerkUpgrade:Initialize()

	AlienClassUpgrade.Initialize(self)
	
	self.cost = LerkUpgrade.cost
	self.upgradeName = LerkUpgrade.upgradeName
	self.upgradeTitle = LerkUpgrade.upgradeTitle
	self.upgradeDesc = LerkUpgrade.upgradeDesc
	self.upgradeTechId = LerkUpgrade.upgradeTechId
	
end

function LerkUpgrade:GetClassName()
	return "LerkUpgrade"
end