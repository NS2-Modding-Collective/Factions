//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// SkulkUpgrade is applied before anything else
						
class 'SkulkUpgrade' (AlienClassUpgrade)

SkulkUpgrade.cost 				= { 0 }                          	// cost of the upgrade in xp
SkulkUpgrade.upgradeName		= "skulk"	                        // text code of the upgrade if using it via console
SkulkUpgrade.upgradeTitle 		= "Skulk"       					// Title of the upgrade, e.g. Submachine Gun
SkulkUpgrade.upgradeDesc 		= "Evolve back into a Skulk"         // Description of the upgrade
SkulkUpgrade.upgradeTechId 		= kTechId.Skulk  					// techId of the upgrade, default is kTechId.Move cause its the first 

function SkulkUpgrade:Initialize()

	AlienClassUpgrade.Initialize(self)
	
	self.cost = SkulkUpgrade.cost
	self.upgradeName = SkulkUpgrade.upgradeName
	self.upgradeTitle = SkulkUpgrade.upgradeTitle
	self.upgradeDesc = SkulkUpgrade.upgradeDesc
	self.upgradeTechId = SkulkUpgrade.upgradeTechId
	
end

function SkulkUpgrade:GetClassName()
	return "SkulkUpgrade"
end