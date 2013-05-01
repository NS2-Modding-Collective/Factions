//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// GorgeUpgrade is applied before anything else
						
class 'GorgeUpgrade' (AlienClassUpgrade)

GorgeUpgrade.cost 				= { 250 }                          	// cost of the upgrade in xp
GorgeUpgrade.upgradeName		= "gorge"	                        // text code of the upgrade if using it via console
GorgeUpgrade.upgradeTitle 		= "Gorge"       					// Title of the upgrade, e.g. Submachine Gun
GorgeUpgrade.upgradeDesc 		= "Evolve into a gorge"             		// Description of the upgrade
GorgeUpgrade.upgradeTechId 		= kTechId.Gorge  				// techId of the upgrade, default is kTechId.Move cause its the first 

function GorgeUpgrade:Initialize()

	AlienClassUpgrade.Initialize(self)
	
	self.cost = GorgeUpgrade.cost
	self.upgradeName = GorgeUpgrade.upgradeName
	self.upgradeTitle = GorgeUpgrade.upgradeTitle
	self.upgradeDesc = GorgeUpgrade.upgradeDesc
	self.upgradeTechId = GorgeUpgrade.upgradeTechId
	
end

function GorgeUpgrade:GetClassName()
	return "GorgeUpgrade"
end