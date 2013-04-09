//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// FadeUpgrade is applied before anything else
						
class 'FadeUpgrade' (AlienClassUpgrade)

FadeUpgrade.cost 				= { 500 }                          	// cost of the upgrade in xp
FadeUpgrade.upgradeName		= "fade"	                        // text code of the upgrade if using it via console
FadeUpgrade.upgradeTitle 		= "Fade"       					// Title of the upgrade, e.g. Submachine Gun
FadeUpgrade.upgradeDesc 		= "Evolve into a Fade"             		// Description of the upgrade
FadeUpgrade.upgradeTechId 		= kTechId.Fade  				// techId of the upgrade, default is kTechId.Move cause its the first 

function FadeUpgrade:Initialize()

	AlienClassUpgrade.Initialize(self)
	
	self.cost = FadeUpgrade.cost
	self.upgradeName = FadeUpgrade.upgradeName
	self.upgradeTitle = FadeUpgrade.upgradeTitle
	self.upgradeDesc = FadeUpgrade.upgradeDesc
	self.upgradeTechId = FadeUpgrade.upgradeTechId
	
end

function FadeUpgrade:GetClassName()
	return "FadeUpgrade"
end