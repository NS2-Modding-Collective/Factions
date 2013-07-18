//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'PhantomUpgrade' (FactionsAlienUpgrade)

PhantomUpgrade.cost 			= { 250 }    				// cost of the upgrade in xp
PhantomUpgrade.upgradeName		= "phantom"	                // text code of the upgrade if using it via console
PhantomUpgrade.upgradeTitle 	= "Phantom"       			// Title of the upgrade, e.g. Submachine Gun
PhantomUpgrade.upgradeDesc 		= "Get phantom"             // Description of the upgrade
PhantomUpgrade.upgradeTechId 	= kTechId.Phantom			// techId of the upgrade, default is kTechId.Move cause its the first 

function PhantomUpgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.cost = PhantomUpgrade.cost
	self.upgradeName = PhantomUpgrade.upgradeName
	self.upgradeTitle = PhantomUpgrade.upgradeTitle
	self.upgradeDesc = PhantomUpgrade.upgradeDesc
	self.upgradeTechId = PhantomUpgrade.upgradeTechId
	
end

function PhantomUpgrade:GetClassName()
	return "PhantomUpgrade"
end