//________________________________
//
//   	NS2 Combat Mod     
//	Made by JimWest and MCMLXXXIV, 2012
//
//________________________________

// Alien Upgrades
						
class 'CamouflageUpgrade' (FactionsUpgrade)

CamouflageUpgrade.cost 				= { 250, 250, 250, 250 }                       // cost of the upgrade in xp
CamouflageUpgrade.upgradeName		= "camo"	                    // text code of the upgrade if using it via console
CamouflageUpgrade.upgradeTitle 		= "Camouflage"       			// Title of the upgrade, e.g. Submachine Gun
CamouflageUpgrade.upgradeDesc 		= "Get camouflage"             	// Description of the upgrade
CamouflageUpgrade.upgradeTechId 	= kTechId.Camouflage			// techId of the upgrade, default is kTechId.Move cause its the first 

function CamouflageUpgrade:Initialize()

	FactionsAlienUpgrade.Initialize(self)
	
	self.hideUpgrade = true
	self.cost = CamouflageUpgrade.cost
	self.upgradeName = CamouflageUpgrade.upgradeName
	self.upgradeTitle = CamouflageUpgrade.upgradeTitle
	self.upgradeDesc = CamouflageUpgrade.upgradeDesc
	self.upgradeTechId = CamouflageUpgrade.upgradeTechId
	
end

function CamouflageUpgrade:GetClassName()
	return "CamouflageUpgrade"
end

// Give the weapon to the player when they buy the upgrade.
function CamouflageUpgrade:OnAdd(player)

	// Apply the same logic to the player as GiveUpgrade does
	if HasMixin(player, "Camouflage") then
		player:SetCanCamouflage(true)
	end

end